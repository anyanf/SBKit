//
//  SBMultiLevelTableView.m
//  SBMultiLevelTableView
//
//  Created by ankang on 23/11/13.
//  Copyright © 2016年 ankang. All rights reserved.
//

#import "SBMultiLevelTableView.h"

#import "UIColor+SBExtension.h"

@interface SBMultiLevelTableView ()

/// 默认是 SBMultiLevelTableViewCell
@property (nonatomic, assign) Class cellClass;

@property (nonatomic, strong) NSMutableArray<SBMultiLevelTableNode *> *displayNodesMutAry;

@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *needReloadNodesMutAry;

@property (nonatomic, copy) SBMultiLevelTableSelectBlock block;

@end

@implementation SBMultiLevelTableView

#pragma mark
#pragma mark life cycle
- (instancetype)initWithFrame:(CGRect)frame
                    cellClass:(Class)cellClass
                  selectBlock:(SBMultiLevelTableSelectBlock)block {
    self = [self initWithFrame:frame];
    if (self) {
        self.cellClass = cellClass;
        self.block = [block copy];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _displayNodesMutAry = [NSMutableArray array];
        _needReloadNodesMutAry = [NSMutableArray array];
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;

        self.canFoldAndExpand = YES;
        self.preservation = NO;
    }
    return self;
}

#pragma mark 刷新数据

- (void)reloadData {
    
    [self addFirstLoadNodes];
    
    [self setupNodeFrame];
    
    [super reloadData];
}

- (void)addFirstLoadNodes {
    // add parent nodes on the upper level
    for (int i = 0 ; i < _multiLevelNodes.count;i++) {
        
        SBMultiLevelTableNode *node = _multiLevelNodes[i];
        if (node.isRoot) {
            [_displayNodesMutAry addObject:node];
            
            if (node.isExpand) {
                [self expandNodesForParentID:node.nodeID insertIndex:[_displayNodesMutAry indexOfObject:node]];
            }
        }
    }
    [self.needReloadNodesMutAry removeAllObjects];
}

- (void)setupNodeFrame {
    for (int i = 0 ; i < _multiLevelNodes.count;i++) {
        SBMultiLevelTableNode *node = _multiLevelNodes[i];
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
    return self.displayNodesMutAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBMultiLevelTableNode *node = [self.displayNodesMutAry sb_objectAtIndex:indexPath.row];
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
    SBMultiLevelTableNode *node = [self.displayNodesMutAry sb_objectAtIndex:indexPath.row];
    cell.node = node;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.canFoldAndExpand) {
        return;
    }
    
    SBMultiLevelTableNode *currentNode = [self.displayNodesMutAry objectAtIndex:indexPath.row];
    if (currentNode.isLeaf) {
        self.block(currentNode);
        return;
    } else {
        currentNode.expand = !currentNode.expand;
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.needReloadNodesMutAry removeAllObjects];
    if (currentNode.isExpand) {
        //expand
        [self expandNodesForParentID:currentNode.nodeID insertIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:self.needReloadNodesMutAry withRowAnimation:UITableViewRowAnimationNone];
    }else{
        //fold
        [self foldNodesForLevel:currentNode.level currentIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:self.needReloadNodesMutAry withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - reload node


#pragma mark -  fold and expand
- (void)foldNodesForLevel:(NSUInteger)level currentIndex:(NSUInteger)currentIndex {
    
    if (currentIndex + 1 < self.displayNodesMutAry.count) {
        NSMutableArray *tempArr = [self.displayNodesMutAry copy];
        for (NSUInteger i = currentIndex+1 ; i<tempArr.count;i++) {
            SBMultiLevelTableNode *node = tempArr[i];
            if (node.level <= level) {
                break;
            } else {
                [self.displayNodesMutAry removeObject:node];
                [self.needReloadNodesMutAry addObject:[NSIndexPath indexPathForRow:i inSection:0]]; //need reload nodes
            }
        }
    }
}

- (NSUInteger)expandNodesForParentID:(NSString*)parentID insertIndex:(NSUInteger)insertIndex {
    
    NSUInteger currentIdx = insertIndex;

    for (int i = 0 ; i < _multiLevelNodes.count;i++) {
        SBMultiLevelTableNode *node = _multiLevelNodes[i];
        if ([node.parentID isEqualToString:parentID]) {
            if (!self.isPreservation) {
                node.expand = NO;
            }
            
            currentIdx++;
            [self.displayNodesMutAry insertObject:node atIndex:currentIdx];
            [self.needReloadNodesMutAry addObject:[NSIndexPath indexPathForRow:currentIdx inSection:0]]; //need reload nodes
            
            if (node.isExpand) {
                currentIdx = [self expandNodesForParentID:node.nodeID insertIndex:currentIdx];
            }
        }
    }
    
    return currentIdx;
}



@end
