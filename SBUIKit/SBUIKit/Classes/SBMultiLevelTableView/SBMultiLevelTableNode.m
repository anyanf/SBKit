//
//  SBMultiLevelTableNode.m
//  SBMultiLevelTableNode
//
//  Created by ankang on 23/11/13.
//  Copyright © 2016年 ankang. All rights reserved.
//

#import "SBMultiLevelTableNode.h"

@implementation SBMultiLevelTableNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        _levelIndent = 12.0;
        _horiMargin = 0.0;
    }
    return self;
}

- (BOOL)isRoot {
    return !self.parentNode;
}

- (BOOL)isLeaf {
    return !SB_ARY_IS_VALID_K(self.childrenNodes);
}

- (NSMutableArray *)childrenNodes {
    if (!_childrenNodes) {
        _childrenNodes = [NSMutableArray array];
    }
    return _childrenNodes;
}

#pragma mark - node 初始化

+ (instancetype)nodeWithParentID:(NSString *)parentID name:(NSString *)name nodeID:(NSString *)nodeID isExpand:(BOOL)bol {
    return [self nodeWithParentID:parentID name:name nodeID:nodeID level:-1 isExpand:bol];
}

+ (instancetype)nodeWithParentID:(NSString*)parentID name:(NSString*)name nodeID:(NSString*)nodeID level:(NSUInteger)level isExpand:(BOOL)bol {
    
    SBMultiLevelTableNode *node = [[SBMultiLevelTableNode alloc] init];
    node.parentID = parentID;
    node.nodeID = nodeID;
    node.level = level;
    node.expand = bol;
    
    return node;
}


+ (instancetype)nodeWithNodeID:(NSString*)nodeID parentID:(NSString*)parentID  isExpand:(BOOL)isExpand{
    
    SBMultiLevelTableNode *node = [[SBMultiLevelTableNode alloc] init];
    node.nodeID = nodeID;
    node.parentID = parentID;
    node.expand = isExpand;
    
    return node;
}

#pragma 多叉树node数据处理

+ (void)handleMultiLevelNodes:(NSMutableArray<SBMultiLevelTableNode *> *)multiLevelNodes {
    
    for (SBMultiLevelTableNode *node in multiLevelNodes) {
        
        SBMultiLevelTableNode *parentNode = node.parentNode;
        NSMutableArray<SBMultiLevelTableNode *> *childrenNodes = node.childrenNodes;
        
        // 添加层级
        NSInteger level = 0;
        if (parentNode) {
            level = parentNode.level + 1;
        }
        node.level = level;
        
        // 如果有儿子，继续处理儿子
        if (SB_ARY_IS_VALID_K(childrenNodes)) {
            [self handleMultiLevelNodes:childrenNodes];
        }
    }
}


#pragma 单层node数组构建多叉树


+ (NSMutableArray<SBMultiLevelTableNode *> *)handleSingleLevelNodesDepth:(NSUInteger)level parentIDs:(NSArray*)parentIDs childrenNodes:(NSMutableArray *)childrenNodes {
    
    NSMutableArray *newParentIDs = [NSMutableArray array];
    NSMutableArray *newParentNodes = [NSMutableArray array];
    NSMutableArray *leftNodes = [childrenNodes mutableCopy];
    
    for (SBMultiLevelTableNode *node in childrenNodes) {
        if ([parentIDs containsObject:node.parentID]) {
            node.level = level;
            
            [leftNodes removeObject:node];
            [newParentNodes addObject:node];
            [newParentIDs addObject:node.nodeID];
        }
    }
    
    if (leftNodes.count > 0) {
        level += 1;
        [self handleSingleLevelNodesDepth:level parentNodes:[newParentNodes copy] childrenNodes:leftNodes];
    }
    return [newParentNodes copy];
}

+ (NSMutableArray<SBMultiLevelTableNode *> *)handleSingleLevelNodesDepth:(NSUInteger)level parentNodes:(NSArray*)parentNodes childrenNodes:(NSMutableArray *)childrenNodes {
    
    NSMutableArray *newParentNodes = [NSMutableArray array];
    NSMutableArray *leftNodes = [childrenNodes mutableCopy];
    
    for (SBMultiLevelTableNode *node in childrenNodes) {
        
        // 如果找到父node就建立关系
        for (SBMultiLevelTableNode *parentNode in parentNodes) {
            if ([parentNode.nodeID isEqualToString:node.parentID]) {
                node.level = level;
                
                node.parentNode = parentNode;
                [parentNode.childrenNodes addObject:node];
                
                [leftNodes removeObject:node];
                [newParentNodes addObject:node];
                continue;
            }
        }
    }
    
    if (leftNodes.count > 0) {
        level += 1;
        [self handleSingleLevelNodesDepth:level parentNodes:[newParentNodes copy] childrenNodes:leftNodes];
    }
    return [newParentNodes copy];
}


@end
