//
//  SBMultiLevelTableNode.h
//  SBMultiLevelTableNode
//
//  Created by ankang on 23/11/13.
//  Copyright © 2016年 ankang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBMultiLevelTableNode : NSObject

#pragma mark - 数据

@property (nonatomic, strong) NSString *nodeID;

@property (nonatomic, strong) NSString *parentID;

@property (nonatomic, weak) SBMultiLevelTableNode *parentNode;

@property (nonatomic, strong) NSMutableArray<SBMultiLevelTableNode *> *childrenNodes;

@property (nonatomic, assign, getter=isExpand) BOOL expand;

@property (nonatomic, assign) NSUInteger level; // depth in the tree sturct

@property (nonatomic, assign, getter=isLeaf) BOOL leaf;

@property (nonatomic, assign, getter=isRoot) BOOL root;

@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, assign) BOOL isFooter;


#pragma mark - UI

/// 层级缩进
@property (nonatomic, assign) CGFloat levelIndent;
/// 水平margin
@property (nonatomic, assign) CGFloat horiMargin;

@property (nonatomic, strong) NSValue *cellSizeValue;


/**
 *  初始化节点
 *
 *  @param parentID parent node's ID
 *  @param name       node's name
 *  @param nodeID this node's ID
 *  @param level      depth in the tree
 *  @param bol        this node's child node is expand or not
 */
+ (instancetype)nodeWithParentID:(NSString*)parentID name:(NSString*)name nodeID:(NSString*)nodeID level:(NSUInteger)level isExpand:(BOOL)bol;

+ (instancetype)nodeWithParentID:(NSString*)parentID name:(NSString*)name nodeID:(NSString*)nodeID isExpand:(BOOL)bol;

+ (void)handleMultiLevelNodes:(NSMutableArray<SBMultiLevelTableNode *> *)multiLevelNodes;

+ (NSMutableArray<SBMultiLevelTableNode *> *)handleSingleLevelNodesDepth:(NSUInteger)level 
                                                               parentIDs:(NSArray*)parentIDs
                                                           childrenNodes:(NSMutableArray*)childrenNodes;

+ (NSMutableArray<SBMultiLevelTableNode *> *)handleSingleLevelNodesDepth:(NSUInteger)level
                                                             parentNodes:(NSArray*)parentNodes
                                                           childrenNodes:(NSMutableArray*)childrenNodes;

@end
