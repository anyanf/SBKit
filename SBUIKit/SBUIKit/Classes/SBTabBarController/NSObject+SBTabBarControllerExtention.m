//
//  NSObject+SBTabBarControllerExtention.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import "NSObject+SBTabBarControllerExtention.h"

#import <objc/runtime.h>


@implementation NSObject (SBTabBarControllerExtention)


- (BOOL)sb_isForceLandscape {
    NSNumber *isForceLandscapeObject = objc_getAssociatedObject(self, @selector(sb_isForceLandscape));
    return [isForceLandscapeObject boolValue];
}

- (void)sb_setIsForceLandscape:(BOOL)isForceLandscape {
    NSNumber *isForceLandscapeObject = @(isForceLandscape);
    objc_setAssociatedObject(self, @selector(sb_isForceLandscape), isForceLandscapeObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIResponder<UIApplicationDelegate> *)sb_sharedAppDelegate {
    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    return (UIResponder<UIApplicationDelegate> *)appDelegate;
}

+ (void)sb_forceUpdateInterfaceOrientation:(UIInterfaceOrientation)orientation {
    UIResponder<UIApplicationDelegate> *appDelegate = [self sb_sharedAppDelegate];
    BOOL isForceLandscape = (UIInterfaceOrientationLandscapeLeft == orientation) || (UIInterfaceOrientationLandscapeRight == orientation);
    appDelegate.sb_isForceLandscape = isForceLandscape;
    if ([appDelegate respondsToSelector:@selector(application:supportedInterfaceOrientationsForWindow:)]) {
        [appDelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:UIApplication.sharedApplication.keyWindow];
    }
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *num = [[NSNumber alloc]initWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)withObject:(id)num];
        [UIViewController attemptRotationToDeviceOrientation];
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val  = [@(orientation) intValue];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

+ (UIViewController * __nullable)sb_topmostViewController {
    UIViewController *topViewController = [[[UIApplication sharedApplication] delegate].window rootViewController];
    
    if (topViewController == nil) {
        return nil;
    }
    
    while (true) {
        if (topViewController.presentedViewController != nil) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)topViewController;
            topViewController = navi.topViewController;
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    
    return topViewController;
}

+ (UINavigationController * __nullable)sb_currentNavigationController {
    return [[UIViewController sb_topmostViewController] navigationController];
}

+ (void)sb_dismissAll:(void (^ __nullable)(void))completion {
    UIViewController *topViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    if (topViewController == nil) {
        !completion ?: completion();
        return;
    }
    
    NSMutableArray *list = [NSMutableArray new];
    
    while (true) {
        if (topViewController.presentedViewController != nil) {
            topViewController = topViewController.presentedViewController;
            [list addObject:topViewController];
        } else if ([topViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)topViewController;
            topViewController = navi.topViewController;
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    
    if (list.count == 0) {
        if (completion) {
            completion();
        }
        return;
    }
    
    for (NSInteger i = list.count - 1; i >=0 ; i--) {
        
        UIViewController *vc = list[i];
        if (i == 0) {
            if ([vc isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)vc popToRootViewControllerAnimated:NO];
            }
            [vc dismissViewControllerAnimated:NO completion:completion];
        } else {
            if ([vc isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)vc popToRootViewControllerAnimated:NO];
            }
            [vc dismissViewControllerAnimated:NO completion:nil];
        }
    }
}


@end
