//
//  SBViewController+TableView.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/28.
//


#import "SBViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBViewController (TableView)
<
UITableViewDelegate,
UITableViewDataSource
>

/** 在SBVC创建默认的tableView，或者更新tableView */
- (void)createOrUpdateDefaultTableView;

/** 在SBVC创建默认的tableView，指定frame */
- (void)createTableViewWithFrame:(CGRect)frame;

/** 在SBVC创建默认的tableView，指定style */
- (void)createTableViewWithStyle:(UITableViewStyle)style;

/** 在SBVC创建默认的tableView，指定frame和style */
- (void)createTableViewWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style;

/** 设置tableview的底部布局到屏幕边缘 */
- (void)updateTableViewHeightToBottom;


#pragma mark - 更新SBVC中默认的tableView

/** 更新SBVC中默认的tableView */
- (void)updateDefaultTableView;

@end

NS_ASSUME_NONNULL_END
