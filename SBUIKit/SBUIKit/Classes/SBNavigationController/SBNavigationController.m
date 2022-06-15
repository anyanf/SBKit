//
//  SBNavigationController.m
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import "SBNavigationController.h"

@interface SBNavigationController ()

@end

@implementation SBNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        // 默认modal全屏
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        // 默认modal全屏
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = true;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    
    // push的时候先收起来键盘，防止有黑线
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)topViewController {
    return self.viewControllers.lastObject;
}

@end
