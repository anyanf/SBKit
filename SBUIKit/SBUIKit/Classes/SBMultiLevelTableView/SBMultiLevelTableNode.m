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
        _leftMargin = 30.0;
        _height = 45.0;
    }
    return self;
}

+ (instancetype)nodeWithParentID:(NSString *)parentID name:(NSString *)name childrenID:(NSString *)childrenID isExpand:(BOOL)bol {
    return [self nodeWithParentID:parentID name:name childrenID:childrenID level:-1 isExpand:bol];
}

+ (instancetype)nodeWithParentID:(NSString*)parentID name:(NSString*)name childrenID:(NSString*)childrenID level:(NSUInteger)level isExpand:(BOOL)bol {
    
    SBMultiLevelTableNode *node = [[SBMultiLevelTableNode alloc] init];
    node.parentID = parentID;
    node.name = name;
    node.childrenID = childrenID;
    node.level = level;
    node.expand = bol;
    
    return node;
}

@end
