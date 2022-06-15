//
//  UIViewController+SBNavigationControllerExtention.m
//  SBUIKit
//
//  Created by 安康 on 2019/10/4.
//

#import "UIViewController+SBNavigationControllerExtention.h"

#import <objc/runtime.h>


@implementation UIViewController (SBNavigationControllerExtention)


- (BOOL)sb_disablePopGestureRecognizer {
    NSNumber *disablePopGestureRecognizerObject = objc_getAssociatedObject(self, @selector(sb_disablePopGestureRecognizer));
    return [disablePopGestureRecognizerObject boolValue];
}

- (void)sb_setDisablePopGestureRecognizer:(BOOL)disablePopGestureRecognizer {
    NSNumber *disablePopGestureRecognizerObject = [NSNumber numberWithBool:disablePopGestureRecognizer];
    objc_setAssociatedObject(self, @selector(sb_disablePopGestureRecognizer), disablePopGestureRecognizerObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sb_hideNavigationBarSeparator {
    NSNumber *hideNavigationBarSeparatorObject = objc_getAssociatedObject(self, @selector(sb_hideNavigationBarSeparator));
    return [hideNavigationBarSeparatorObject boolValue];
}

- (void)sb_setHideNavigationBarSeparator:(BOOL)hideNavigationBarSeparator {
    NSNumber *hideNavigationBarSeparatorObject = [NSNumber numberWithBool:hideNavigationBarSeparator];
    objc_setAssociatedObject(self, @selector(sb_hideNavigationBarSeparator), hideNavigationBarSeparatorObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sb_navigationBarHidden {
    NSNumber *navigationBarHiddenObject = objc_getAssociatedObject(self, @selector(sb_navigationBarHidden));
    return [navigationBarHiddenObject boolValue];
}

- (void)sb_setNavigationBarHidden:(BOOL)navigationBarHidden {
    NSNumber *navigationBarHiddenObject = [NSNumber numberWithBool:navigationBarHidden];
    objc_setAssociatedObject(self, @selector(sb_navigationBarHidden), navigationBarHiddenObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// viewWillDisappear
// dealloc
// 在左滑动的过渡的时间段内禁用interactivePopGestureRecognizer
- (void)sb_disableInteractivePopGestureRecognizer {
    if (![self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        return;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

// viewDidDisappear
// 在左滑动的结束后启用interactivePopGestureRecognizer
- (void)sb_enableInteractivePopGestureRecognizer {
    if (![self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        return;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>)self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

// viewDidAppear
// 当新的视图控制器加载完成后再启用
- (void)sb_resetInteractivePopGestureRecognizer {
    if (![self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        return;
    }
    BOOL isSingleViewControllerInNavigationController = ([self.navigationController.viewControllers count] == 1);
    BOOL needDisableInteractivePopGestureRecognizer = (self.sb_disablePopGestureRecognizer) || isSingleViewControllerInNavigationController;
    if (needDisableInteractivePopGestureRecognizer) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

// viewWillAppear
- (void)sb_hideNavigationBarSeparatorIfNeeded {
    if (self.sb_hideNavigationBarSeparator) {
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.translucent = NO;
    }
}

// 在viewwilldisappear使用
- (BOOL)sb_shouldNavigationBarVisible {
    BOOL shouldSetNo = YES;
    
    BOOL isPop = YES;
    if (!self.navigationController) {
        return shouldSetNo;
    }
    // push的时候会先将vc添加到viewControllers，再调用viewWillDisappear
    // pop的时候会先将vc从viewControllers移除，再调用viewWillDisappear
    NSInteger selfIndex = -1;
    if (self.navigationController.viewControllers.count > 0) {
        NSArray *vcList = self.navigationController.viewControllers;
        for (NSInteger i = 0; i < vcList.count; i++) {
            UIViewController *vc = vcList[i];
            if (vc == self) {
                selfIndex = i;
                if (selfIndex == vcList.count - 1) {
                    //这种情况是navigationController push第一个vc或者present，不需要特殊处理，直接return
                    return YES;
                }
                isPop = NO;
                break;
            }
        }
        if (isPop) {
            UIViewController *preVc = (UIViewController *)self.navigationController.viewControllers.lastObject;
            if (self.sb_navigationBarHidden == preVc.sb_navigationBarHidden) {
                shouldSetNo = NO;
            }
        } else {
            if (selfIndex + 1 < self.navigationController.viewControllers.count) {
                UIViewController *nextVc = (UIViewController *)self.navigationController.viewControllers[selfIndex + 1];
                if (self.sb_navigationBarHidden == nextVc.sb_navigationBarHidden) {
                    shouldSetNo = NO;
                }
            }
        }
    }
    return shouldSetNo;
}

// viewWillDisappear
- (void)sb_setNavigationBarVisibleIfNeeded:(BOOL)animated {
    if (self.sb_navigationBarHidden && [self sb_shouldNavigationBarVisible]) {
        [self.navigationController setNavigationBarHidden:!self.sb_navigationBarHidden animated:animated];
    }
}

// viewWillAppear
- (void)sb_setNavigationBarHiddenIfNeeded:(BOOL)animated {
    if (self.sb_navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:self.sb_navigationBarHidden animated:animated];
    }
}

- (void)sb_viewWillAppearNavigationSetting:(BOOL)animated {
    [self sb_hideNavigationBarSeparatorIfNeeded];
    [self sb_setNavigationBarHiddenIfNeeded:animated];
}

- (void)sb_viewWillDisappearNavigationSetting:(BOOL)animated {
    [self sb_disableInteractivePopGestureRecognizer];
    [self sb_setNavigationBarVisibleIfNeeded:animated];
}

- (void)sb_viewDidDisappearNavigationSetting:(BOOL)animated {
    [self sb_enableInteractivePopGestureRecognizer];
}

- (void)sb_viewDidAppearNavigationSetting:(BOOL)animated {
    [self sb_resetInteractivePopGestureRecognizer];
}

- (void)sb_deallocNavigationSetting {
    [self sb_disableInteractivePopGestureRecognizer];
}

@end
