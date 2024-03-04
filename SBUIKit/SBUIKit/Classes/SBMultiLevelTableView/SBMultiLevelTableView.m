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
    
    [self setupDisplayNodes];
    
    [self setupNodeFrame];
    
    [super reloadData];
}

- (void)setupDisplayNodes {
    // add parent nodes on the upper level
    for (int i = 0 ; i < self.multiLevelNodes.count;i++) {
        
        SBMultiLevelTableNode *node = self.multiLevelNodes[i];
        if (node.isRoot) {
            [self.displayNodesMutAry addObject:node];
            
            if (self.isPreservation) {
                node.expand = YES;
            }
            
            if (node.isExpand) {
                [self expandNode:node
                     insertIndex:[self.displayNodesMutAry indexOfObject:node]
             needReloadIdxMutAry:nil];
            }
        }
    }
}

- (void)setupNodeFrame {
    
    NSMutableArray<SBMultiLevelTableNode *> *stack = [NSMutableArray array];
    
    // 将子节点逆序压入栈中
    for (SBMultiLevelTableNode *childNode in [self.multiLevelNodes reverseObjectEnumerator]) {
        [stack addObject:childNode];
    }
    
    while ([stack count] > 0) {
        SBMultiLevelTableNode *currentNode = stack.lastObject;
        [stack removeObject:currentNode];

        // 处理当前节点
        if ([self.cellClass isSubclassOfClass:SBMultiLevelTableViewCell.class]) {
            currentNode.cellSizeValue = [self.cellClass performSelector:@selector(cellSizeWithNode:maxSize:)
                                                             withObject:currentNode
                                                             withObject:[NSValue valueWithCGSize:self.frame.size]];
        } else {
            currentNode.cellSizeValue = [SBMultiLevelTableViewCell cellSizeWithNode:currentNode
                                                                            maxSize:[NSValue valueWithCGSize:self.frame.size]];
        }

        // 将子节点逆序压入栈中
        for (SBMultiLevelTableNode *childNode in [currentNode.childrenNodes reverseObjectEnumerator]) {
            [stack addObject:childNode];
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
    
    NSMutableArray<NSIndexPath *> *needReloadIdxMutAry = [NSMutableArray array];
    if (currentNode.isExpand) {
        //expand
        [self expandNode:currentNode insertIndex:indexPath.row needReloadIdxMutAry:needReloadIdxMutAry];
        [tableView insertRowsAtIndexPaths:needReloadIdxMutAry withRowAnimation:UITableViewRowAnimationNone];
    } else {
        //fold
        [self foldNode:currentNode currentIndex:indexPath.row needReloadIdxMutAry:needReloadIdxMutAry];
        [tableView deleteRowsAtIndexPaths:needReloadIdxMutAry withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - reload node

- (void)reloadNodeAndChildrenNode:(SBMultiLevelTableNode *)node {
    
    NSMutableArray<NSIndexPath *> *needReloadIdxMutAry = [NSMutableArray array];
    
    // 先把自己加进去
    NSInteger currentIndex = [self.displayNodesMutAry indexOfObject:node];
    [needReloadIdxMutAry addObject:[NSIndexPath indexPathForRow:currentIndex inSection:0]]; //need reload nodes

    
    // 显示node中所有的子节点
    if (currentIndex + 1 < self.displayNodesMutAry.count) {
        NSMutableArray *tempArr = [self.displayNodesMutAry copy];
        for (NSUInteger i = currentIndex + 1 ; i < tempArr.count; i++) {
            SBMultiLevelTableNode *childNode = tempArr[i];
            if (childNode.level <= node.level) {
                // 说明 childNode 已经平级或者还高，结束
                break;
            } else {
                [needReloadIdxMutAry addObject:[NSIndexPath indexPathForRow:i inSection:0]]; //need reload nodes
            }
        }
    }
    
    // 不能直接reload cell，因为有键盘光标会因为reload消失
//    [self reloadRowsAtIndexPaths:needReloadIdxMutAry withRowAnimation:UITableViewRowAnimationNone];
    NSArray<NSIndexPath *> *indexPathsForVisibleRows =  self.indexPathsForVisibleRows;
    for (NSIndexPath *indexPath in needReloadIdxMutAry) {
        for (NSIndexPath *visiableIndexPath in indexPathsForVisibleRows) {
            if (indexPath.row == visiableIndexPath.row) {
                SBMultiLevelTableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
                if (cell) {
                    SBMultiLevelTableNode *node = [self.displayNodesMutAry sb_objectAtIndex:indexPath.row];
                    cell.node = node;
                }
                break;
            }
        }
    }
}

#pragma mark -  fold and expand

- (void)foldNode:(SBMultiLevelTableNode *)node
    currentIndex:(NSUInteger)currentIndex
    needReloadIdxMutAry:(NSMutableArray<NSIndexPath *> *)needReloadIdxMutAry {
    
    if (currentIndex + 1 < self.displayNodesMutAry.count) {
        NSMutableArray *tempArr = [self.displayNodesMutAry copy];
        for (NSUInteger i = currentIndex + 1 ; i < tempArr.count; i++) {
            SBMultiLevelTableNode *childNode = tempArr[i];
            if (childNode.level <= node.level) {
                // 说明 childNode 已经平级或者还高，结束
                break;
            } else {
                childNode.expand = NO;
                [self.displayNodesMutAry removeObject:childNode];
                [needReloadIdxMutAry addObject:[NSIndexPath indexPathForRow:i inSection:0]]; //need reload nodes
            }
        }
    }
}

- (NSUInteger)expandNode:(SBMultiLevelTableNode *)node
             insertIndex:(NSUInteger)insertIndex
     needReloadIdxMutAry:(NSMutableArray<NSIndexPath *> *)needReloadIdxMutAry {

    NSUInteger currentIdx = insertIndex;
    
    for (SBMultiLevelTableNode *childNode in node.childrenNodes) {
        
        if (self.isPreservation) {
            childNode.expand = YES;
        }
        
        currentIdx++;
        [self.displayNodesMutAry insertObject:childNode atIndex:currentIdx];
        [needReloadIdxMutAry addObject:[NSIndexPath indexPathForRow:currentIdx inSection:0]]; //need reload nodes
        
        if (childNode.isExpand) {
            currentIdx = [self expandNode:childNode insertIndex:currentIdx needReloadIdxMutAry:needReloadIdxMutAry];
        }
    }
    
    return currentIdx;
}





@end
