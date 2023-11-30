//
//  SBMultiLevelTableView.h
//  SBMultiLevelTableView
//
//  Created by ankang on 23/11/13.
//  Copyright © 2016年 ankang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBMultiLevelTableViewCell.h"

#import "SBMultiLevelTableNode.h"

typedef void(^SBMultiLevelTableSelectBlock)(SBMultiLevelTableNode *node);

@interface SBMultiLevelTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

//all nodes
@property (nonatomic, copy) NSMutableArray<SBMultiLevelTableNode *> *multiLevelNodes;

// 是否支持折叠展开，默认yes
@property (nonatomic, assign) BOOL canFoldAndExpand;
// 是否展开全部子节点 show the last status all child nodes keep when yes, or just show next level child nodes
@property (nonatomic, assign ,getter=isPreservation) BOOL preservation;

- (instancetype)initWithFrame:(CGRect)frame
                    cellClass:(Class)cellClass
                  selectBlock:(SBMultiLevelTableSelectBlock)block;

@end
