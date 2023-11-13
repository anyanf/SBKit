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

@property (nonatomic, strong) NSString *parentID;

@property (nonatomic, strong) NSString *childrenID;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign, getter=isExpand) BOOL expand;


@property (nonatomic, assign) NSUInteger level; // depth in the tree sturct

@property (nonatomic, assign, getter=isLeaf) BOOL leaf;

@property (nonatomic, assign, getter=isRoot) BOOL root;


#pragma mark - UI

/// 层级缩进
@property (nonatomic, assign) CGFloat levelIndent;
/// 水平margin
@property (nonatomic, assign) CGFloat horiMargin;

@property (nonatomic, assign) CGFloat height;


/**
 *  初始化节点
 *
 *  @param parentID parent node's ID
 *  @param name       node's name
 *  @param childrenID this node's ID
 *  @param level      depth in the tree
 *  @param bol        this node's child node is expand or not
 */
+ (instancetype)nodeWithParentID:(NSString*)parentID name:(NSString*)name childrenID:(NSString*)childrenID level:(NSUInteger)level isExpand:(BOOL)bol;

+ (instancetype)nodeWithParentID:(NSString*)parentID name:(NSString*)name childrenID:(NSString*)childrenID isExpand:(BOOL)bol;

@end
