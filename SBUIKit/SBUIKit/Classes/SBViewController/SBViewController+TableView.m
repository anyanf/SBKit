//
//  SBViewController+TableView.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/28.
//

#import "SBViewController+TableView.h"

#import "SBTabBarController.h"

#import "SBUIKitMacro.h"

#import "UIView+SBExtension.h"

@implementation SBViewController (TableView)

#pragma mark - ******************************* 创建 基本 属性 TableView ******************************

// 在SBVC创建默认的tableView，或者更新tableView
- (void)createOrUpdateDefaultTableView {
    if (self.sbTableView) {
        [self.sbTableView reloadData];
    } else {
        
        CGFloat tableViewH = ((SBTabBarController *)self.tabBarController).tabBar.isHidden ? SB_SAFE_SCREEN_NO_NAV_H_K : SB_SCREEN_NO_NAV_TAB_H_K;
        
        self.sbTableView = [SBTableView createWithFrame:CGRectMake(0,
                                                                   SB_SAFE_NAV_TOP_INSET,
                                                                   SB_SCREEN_W_K,
                                                                   tableViewH)
                                                 target:self
                                                  style:UITableViewStyleGrouped];
        

        [self.view addSubview:self.sbTableView];
                        
    }
}

// 在SBVC创建默认的tableView，指定frame
- (void)createTableViewWithFrame:(CGRect)frame {
    if (self.sbTableView) {
        [self.sbTableView setFrame:frame];
    } else {
        self.sbTableView = [SBTableView createWithFrame:frame
                                                 target:self
                                                  style:UITableViewStyleGrouped];
        [self.view addSubview:self.sbTableView];
        
    }
}

// 在SBVC创建默认的tableView，指定style
- (void)createTableViewWithStyle:(UITableViewStyle)style {
    // style只能在初始化时设置，所以只能删除
    if (self.sbTableView) {
        [self.sbTableView removeFromSuperview];
        self.sbTableView = nil;
    }
    
    CGFloat tableViewH = self.tabBarController.tabBar.isHidden ? SB_SAFE_SCREEN_NO_NAV_H_K : SB_SCREEN_NO_NAV_TAB_H_K;
    
    self.sbTableView = [SBTableView createWithFrame:CGRectMake(0,
                                                               SB_SAFE_NAV_TOP_INSET,
                                                               SB_SCREEN_W_K,
                                                               tableViewH)
                                             target:self
                                              style:style];
    [self.view addSubview:self.sbTableView];
    
}

// 在SBVC创建默认的tableView，指定frame和style
- (void)createTableViewWithFrame:(CGRect)frame
                       withStyle:(UITableViewStyle)style
{
    // style只能在初始化时设置，所以只能删除
    if (self.sbTableView)
    {
        [self.sbTableView removeFromSuperview];
        self.sbTableView = nil;
    }
    
    self.sbTableView = [SBTableView createWithFrame:frame
                                           target:self
                                            style:style];
    [self.view addSubview:self.sbTableView];
    
}



- (void)updateTableViewHeightToBottom {
    self.sbTableView.sb_h = SB_SCREEN_NO_NAV_H_K;
}

#pragma mark - 更新SBVC中默认的tableView

/// 更新SBVC中默认的tableView
- (void)updateDefaultTableView
{
    if (self.sbTableView)
    {
        [self.sbTableView reloadData];
    }

    else
    {
        // 15-05-07 15:05:27 yuwuchao 添加调试时奔溃
#ifdef DEBUG
        NSException *e = [NSException
                          exceptionWithName: @"sbTableView无法刷新"
                          reason: @"sbTableView为nil，请先创建。"
                          userInfo: nil];
        @throw e;
#endif
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource

// 三个高度必须有最小值

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

@end
