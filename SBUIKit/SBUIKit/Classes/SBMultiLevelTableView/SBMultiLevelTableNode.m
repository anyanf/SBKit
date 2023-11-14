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

+ (instancetype)nodeWithParentID:(NSString *)parentID name:(NSString *)name nodeID:(NSString *)nodeID isExpand:(BOOL)bol {
    return [self nodeWithParentID:parentID name:name nodeID:nodeID level:-1 isExpand:bol];
}

+ (instancetype)nodeWithParentID:(NSString*)parentID name:(NSString*)name nodeID:(NSString*)nodeID level:(NSUInteger)level isExpand:(BOOL)bol {
    
    SBMultiLevelTableNode *node = [[SBMultiLevelTableNode alloc] init];
    node.parentID = parentID;
    node.name = name;
    node.nodeID = nodeID;
    node.level = level;
    node.expand = bol;
    
    return node;
}

@end
