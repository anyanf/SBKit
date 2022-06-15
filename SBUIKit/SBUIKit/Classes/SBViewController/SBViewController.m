//
//  SBViewController.m
//  Masonry
//
//  Created by 安康 on 2019/8/24.
//

#import "SBViewController.h"

#import "UIViewController+SBNavigationControllerExtention.h"

#import "SBUIKitMacro.h"

@interface SBViewController ()

@end

@implementation SBViewController


#pragma mark - *********************************** View Lifecycle **********************************

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 默认modal全屏
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"\n((((((%@ viewDidLoad))))))\n", NSStringFromClass([self class]));
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {

    } else {
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }

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
    
    NSLog(@"\n((((((%@ dealloc))))))\n", NSStringFromClass([self class]));

}

//#pragma mark - 控制屏幕旋转方法，三个同时实现生效
//
//// 是否自动旋转,返回YES可以自动旋转,返回NO禁止旋转
//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//// 返回支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//// 由模态推出的视图控制器 优先支持的屏幕方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}

#pragma mark - *********************************** Create All Views **********************************


#pragma mark - ************************************* Functions *************************************


// 判断当前VC是否第一优先级
- (BOOL)isFirstResponderController {
    NSArray *array = self.navigationController.viewControllers;
    
    if (array.count > 0 && [[array lastObject] isEqual:self]) {
        return YES;
    }
    
    return NO;
}

// 解决不能立即模态问题
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    });
}



@end
