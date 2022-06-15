//
//  SBTableViewController.m
//  SBUIKit
//
//  Created by 安康 on 2019/10/4.
//

#import "SBTableViewController.h"

#import "UIViewController+SBNavigationControllerExtention.h"

@interface SBTableViewController ()

@end

@implementation SBTableViewController

#pragma mark - UIViewController Life

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sb_viewWillAppearNavigationSetting:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self sb_viewDidAppearNavigationSetting:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self sb_viewWillDisappearNavigationSetting:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self sb_viewDidDisappearNavigationSetting:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self sb_deallocNavigationSetting];
}

@end
