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
@property (nonatomic, copy) NSArray<SBMultiLevelTableNode *> *multiLevelNodes;

// 是否支持折叠展开，默认yes
@property (nonatomic, assign) BOOL canFoldAndExpand;
// 是否展开全部子节点 show the last status all child nodes keep when yes, or just show next level child nodes
@property (nonatomic, assign ,getter=isPreservation) BOOL preservation;

- (instancetype)initWithFrame:(CGRect)frame
                    cellClass:(Class)cellClass
                  selectBlock:(SBMultiLevelTableSelectBlock)block;

/// 更新指定node以及子node
- (void)reloadNodeAndChildrenNode:(SBMultiLevelTableNode *)node;

/* demo
 
 
 - (void)viewDidLoad {
     [super viewDidLoad];
     // Do any additional setup after loading the view.
     
     CGRect frame = CGRectMake(0, 0, self.view.sb_w, SB_SAFE_SCREEN_NO_NAV_H_K);
     
     NSArray *nodes = [self returnData];
     
     NSArray *multiLevelNodes = [SBMultiLevelTableNode handleSingleLevelNodesDepth:1 parentIDs:@[@""] childrenNodes:nodes];

     SBMultiLevelTableView *mutableTable = [[SBMultiLevelTableView alloc] initWithFrame:frame
                                                                              cellClass:MMCostReportDetailItemCell.class
                                                                            selectBlock:^(SBMultiLevelTableNode *node) {
 //        NSLog(@"--select node name=%@", node.name);
         
     }];
     mutableTable.multiLevelNodes = multiLevelNodes;
     mutableTable.canFoldAndExpand = YES;
     mutableTable.preservation = NO;
     mutableTable.backgroundColor = UIColor.clearColor;
     [self.view addSubview:mutableTable];
 }


 - (NSArray*)returnData{
     NSArray *list = @[@{@"parentID":@"", @"name":@"Node1", @"ID":@"1"},
                       @{@"parentID":@"1", @"name":@"Node10", @"ID":@"10"},
                       @{@"parentID":@"1", @"name":@"Node11", @"ID":@"11"},
                       @{@"parentID":@"10", @"name":@"Node100", @"ID":@"100"},
                       @{@"parentID":@"10", @"name":@"Node101", @"ID":@"101"},
                       @{@"parentID":@"11", @"name":@"Node110", @"ID":@"110"},
                       @{@"parentID":@"11", @"name":@"Node111", @"ID":@"111"},
                       @{@"parentID":@"111", @"name":@"Node1110", @"ID":@"1110"},
                       @{@"parentID":@"111", @"name":@"Node1111", @"ID":@"1111"},
                       @{@"parentID":@"", @"name":@"Node2", @"ID":@"2"},
                       @{@"parentID":@"2", @"name":@"Node20", @"ID":@"20"},
                       @{@"parentID":@"20", @"name":@"Node200", @"ID":@"200"},
                       @{@"parentID":@"20", @"name":@"Node101", @"ID":@"201"},
                       @{@"parentID":@"20", @"name":@"Node202", @"ID":@"202"},
                       @{@"parentID":@"2", @"name":@"Node21", @"ID":@"21"},
                       @{@"parentID":@"21", @"name":@"Node210", @"ID":@"210"},
                       @{@"parentID":@"21", @"name":@"Node211", @"ID":@"211"},
                       @{@"parentID":@"21", @"name":@"Node212", @"ID":@"212"},
                       @{@"parentID":@"211", @"name":@"Node2110", @"ID":@"2110"},
                       @{@"parentID":@"211", @"name":@"Node2111", @"ID":@"2111"},];
     
     NSMutableArray *array = [NSMutableArray array];
     for (NSDictionary *dic in list) {
         SBMultiLevelTableNode *node  = [SBMultiLevelTableNode nodeWithParentID:dic[@"parentID"]
                                                                           name:dic[@"name"]
                                                                         nodeID:dic[@"ID"]
                                                                       isExpand:YES];
         node.horiMargin = 8;
         
         
         [array addObject:node];
     }
     
     SBMultiLevelTableNode *node1  = [SBMultiLevelTableNode nodeWithParentID:@""
                                                                       name:@"1"
                                                                     nodeID:@"-10"
                                                                   isExpand:YES];
     node1.isHeader = YES;
     node1.horiMargin = 8;
     
     SBMultiLevelTableNode *node2  = [SBMultiLevelTableNode nodeWithParentID:@""
                                                                       name:@"2"
                                                                     nodeID:@"-11"
                                                                   isExpand:YES];
     node2.isHeader = YES;
     node2.horiMargin = 8;
     
     [array insertObject:node1 atIndex:0];
     [array insertObject:node2 atIndex:10];

     
     return [array copy];
 }

 
 */

@end
