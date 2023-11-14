//
//  SBMultiLevelTableView.m
//  SBMultiLevelTableView
//
//  Created by ankang on 23/11/13.
//  Copyright © 2016年 ankang. All rights reserved.
//

#import "SBMultiLevelTableView.h"

#import "UIColor+SBExtension.h"

#import "SBMultiLevelTableNode.h"


@interface SBMultiLevelTableViewCell ()

@property (nonatomic, strong) SBMultiLevelTableNode *node;

@property (nonatomic, strong, readwrite) UIView *sb_contentView;

@end


@implementation SBMultiLevelTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _sb_contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_sb_contentView];
    }
    return self;
}

- (void)setNode:(SBMultiLevelTableNode *)node {
    _node = node;
    
    // set indentation
    CGFloat indentationX = (node.level - 1) * self.node.levelIndent;
    [self moveNode:indentationX];
    
    // color 测试 sb_contentView 区域
//    CGFloat rgbValue = (node.level - 1) * 50;
//    self.sb_contentView.backgroundColor  = [UIColor sb_r:rgbValue g:rgbValue b:rgbValue];
}

- (void)moveNode:(CGFloat)indentationX {
    
    CGSize cellSize = self.node.cellSizeValue.CGSizeValue;
    CGFloat cellHeight = cellSize.height;
    CGFloat cellWidth  = cellSize.width;
    
    self.sb_contentView.frame = CGRectMake(self.node.horiMargin + indentationX,
                                           0,
                                           cellWidth - indentationX - self.node.horiMargin * 2,
                                           cellHeight);
}

+ (NSValue *)cellSizeWithNode:(SBMultiLevelTableNode *)node
                      maxSize:(NSValue *)maxSizeValue {
    
    if (node.cellSizeValue) {
        return node.cellSizeValue;
    }
    
    node.cellSizeValue = [NSValue valueWithCGSize:CGSizeMake(maxSizeValue.CGSizeValue.width, 44)];
    return node.cellSizeValue;
}

@end


//_______________________________________________________________________________________________________________
#pragma mark
#pragma mark SBMultiLevelTableView
@interface SBMultiLevelTableView ()<UITableViewDelegate, UITableViewDataSource>

/// 默认是 SBMultiLevelTableViewCell
@property (nonatomic, assign) Class cellClass;

@property (nonatomic, copy) NSString *rootID;

//all nodes
@property (nonatomic, copy) NSMutableArray *nodes;

//show the last status all child nodes keep when yes, or just show next level child nodes
@property (nonatomic, assign ,getter=isPreservation) BOOL preservation;

@property (nonatomic, strong) NSMutableArray *tempNodes;

@property (nonatomic, strong) NSMutableArray *reloadArray;

@property (nonatomic, copy) SBMultiLevelTableSelectBlock block;

@end

@implementation SBMultiLevelTableView

#pragma mark
#pragma mark life cycle
- (instancetype)initWithFrame:(CGRect)frame
                    cellClass:(Class)cellClass
                        nodes:(NSArray*)nodes
                   rootNodeID:(NSString*)rootID
             needPreservation:(BOOL)need selectBlock:(SBMultiLevelTableSelectBlock)block {
    self = [self initWithFrame:frame];
    if (self) {
        self.cellClass = cellClass;
        self.rootID = rootID ?: @"";
        self.preservation = need;
        self.nodes = [nodes copy];
        self.block = [block copy];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _tempNodes = [NSMutableArray array];
        _reloadArray = [NSMutableArray array];
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;

        self.canFoldAndExpand = YES;
    }
    return self;
}

#pragma mark
#pragma mark set node's leaf and root propertys ,and level
- (void)setNodes:(NSMutableArray *)nodes {
    _nodes = nodes;
    
    [self judgeLeafAndRootNodes];
    
    [self updateNodesLevel];
    
    [self addFirstLoadNodes];
    
    [self setupNodeFrame];
    
    [self reloadData];
}

- (void)addFirstLoadNodes {
    // add parent nodes on the upper level
    for (int i = 0 ; i < _nodes.count;i++) {
        
        SBMultiLevelTableNode *node = _nodes[i];
        if (node.isRoot) {
            [_tempNodes addObject:node];
            
            if (node.isExpand) {
                [self expandNodesForParentID:node.nodeID insertIndex:[_tempNodes indexOfObject:node]];
            }
        }
    }
    [_reloadArray removeAllObjects];
}

//judge leaf node and root node
- (void)judgeLeafAndRootNodes {
    for (int i = 0 ; i < _nodes.count;i++) {
        SBMultiLevelTableNode *node = _nodes[i];
        
        BOOL isLeaf = YES;
        BOOL isRoot = YES;
        for (SBMultiLevelTableNode *tempNode in _nodes) {
            if ([tempNode.parentID isEqualToString:node.nodeID]) {
                isLeaf = NO;
            }
            if ([tempNode.nodeID isEqualToString:node.parentID]) {
                isRoot = NO;
            }
            if (!isRoot && !isLeaf) {
                break;
            }
        }
        node.leaf = isLeaf;
        node.root = isRoot;
    }
}

//set depath for all nodes
- (void)updateNodesLevel {
    [self setDepth:1 parentIDs:@[_rootID] childrenNodes:_nodes];
}

- (void)setDepth:(NSUInteger)level parentIDs:(NSArray*)parentIDs childrenNodes:(NSMutableArray*)childrenNodes {
    
    NSMutableArray *newParentIDs = [NSMutableArray array];
    NSMutableArray *leftNodes = [childrenNodes  mutableCopy];
    
    for (SBMultiLevelTableNode *node in childrenNodes) {
        if ([parentIDs containsObject:node.parentID]) {
            node.level = level;
            [leftNodes removeObject:node];
            [newParentIDs addObject:node.nodeID];
        }
    }
    
    if (leftNodes.count > 0) {
        level += 1;
        [self setDepth:level parentIDs:[newParentIDs copy] childrenNodes:leftNodes];
    }
}

- (void)setupNodeFrame {
    for (int i = 0 ; i < _nodes.count;i++) {
        SBMultiLevelTableNode *node = _nodes[i];
        if ([self.cellClass isSubclassOfClass:SBMultiLevelTableViewCell.class]) {
            node.cellSizeValue = [self.cellClass performSelector:@selector(cellSizeWithNode:maxSize:)
                                                      withObject:node
                                                      withObject:[NSValue valueWithCGSize:self.frame.size]];
        } else {
            node.cellSizeValue = [SBMultiLevelTableViewCell cellSizeWithNode:node
                                                                     maxSize:[NSValue valueWithCGSize:self.frame.size]];
        }
    }
}

#pragma mark
#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tempNodes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBMultiLevelTableNode *node = [self.tempNodes sb_objectAtIndex:indexPath.row];
    return node.cellSizeValue.CGSizeValue.height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    SBMultiLevelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        if ([self.cellClass isSubclassOfClass:SBMultiLevelTableViewCell.class]) {
            cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        } else {
            cell = [[SBMultiLevelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
    }
    SBMultiLevelTableNode *node = [self.tempNodes sb_objectAtIndex:indexPath.row];
    cell.node = node;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.canFoldAndExpand) {
        return;
    }
    
    
    SBMultiLevelTableNode *currentNode = [_tempNodes objectAtIndex:indexPath.row];
    if (currentNode.isLeaf) {
        self.block(currentNode);
        return;
    }else{
        currentNode.expand = !currentNode.expand;
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [_reloadArray removeAllObjects];
    if (currentNode.isExpand) {
        //expand
        [self expandNodesForParentID:currentNode.nodeID insertIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:_reloadArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        //fold
        [self foldNodesForLevel:currentNode.level currentIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:_reloadArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark
#pragma mark fold and expand
- (void)foldNodesForLevel:(NSUInteger)level currentIndex:(NSUInteger)currentIndex {
    
    if (currentIndex+1<_tempNodes.count) {
        NSMutableArray *tempArr = [_tempNodes copy];
        for (NSUInteger i = currentIndex+1 ; i<tempArr.count;i++) {
            SBMultiLevelTableNode *node = tempArr[i];
            if (node.level <= level) {
                break;
            } else {
                [_tempNodes removeObject:node];
                [_reloadArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];//need reload nodes
            }
        }
    }
}

- (NSUInteger)expandNodesForParentID:(NSString*)parentID insertIndex:(NSUInteger)insertIndex {
    
    NSUInteger currentIdx = insertIndex;

    for (int i = 0 ; i<_nodes.count;i++) {
        SBMultiLevelTableNode *node = _nodes[i];
        if ([node.parentID isEqualToString:parentID]) {
            if (!self.isPreservation) {
                node.expand = NO;
            }
            
            currentIdx++;
            [_tempNodes insertObject:node atIndex:currentIdx];
            [_reloadArray addObject:[NSIndexPath indexPathForRow:currentIdx inSection:0]]; //need reload nodes
            
            if (node.isExpand) {
                currentIdx = [self expandNodesForParentID:node.nodeID insertIndex:currentIdx];
            }
        }
    }
    
    return currentIdx;
}



@end
