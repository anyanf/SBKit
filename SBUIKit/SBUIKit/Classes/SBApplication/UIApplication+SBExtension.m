//
//  UIApplication+SBExtension.m
//  AFNetworking
//
//  Created by AnKang on 2023/10/28.
//

#import "UIApplication+SBExtension.h"

@implementation UIApplication (SBExtension)

/// 顶部安全区高度
+ (CGFloat)sb_safeDistanceTop {
    if (@available(iOS 13.0, *)) {
        UIScene *scene = UIApplication.sharedApplication.connectedScenes.anyObject;
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if ([windowScene isKindOfClass:UIWindowScene.class]) {
            UIWindow *window = windowScene.windows.firstObject;
            if (window) {
                return window.safeAreaInsets.top;
            }
        }
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        if (window) {
            return window.safeAreaInsets.top;
        }
    }
    return 0;
}

/// 底部安全区高度
+ (CGFloat)sb_safeDistanceBottom {
    if (@available(iOS 13.0, *)) {
        UIScene *scene = UIApplication.sharedApplication.connectedScenes.anyObject;
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if ([windowScene isKindOfClass:UIWindowScene.class]) {
            UIWindow *window = windowScene.windows.firstObject;
            if (window) {
                return window.safeAreaInsets.bottom;
            }
        }
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        if (window) {
            return window.safeAreaInsets.bottom;
        }
    }
    return 0;
}

/// 顶部状态栏高度（包括安全区）
+ (CGFloat)sb_statusBarHeight {
    
    CGFloat statusBarHeight = 0;
    
    if (@available(iOS 13.0, *)) {
        UIScene *scene = UIApplication.sharedApplication.connectedScenes.anyObject;
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if ([windowScene isKindOfClass:UIWindowScene.class]) {
            UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
            if (statusBarManager) {
                return statusBarManager.statusBarFrame.size.height;
            }
        }
    } else {
        statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;
    }
    return statusBarHeight;
}

/// 导航栏高度
+ (CGFloat)sb_navigationBarHeight {
    return 44;
}

/// 状态栏+导航栏的高度
+ (CGFloat)sb_navigationFullHeight {
    return UIApplication.sb_statusBarHeight + UIApplication.sb_navigationBarHeight;
}

/// 底部导航栏高度
+ (CGFloat)sb_tabBarHeight {
    return 49.0;
}

/// 底部导航栏高度（包括安全区）
+ (CGFloat)sb_tabBarFullHeight {
    return UIApplication.sb_tabBarHeight + UIApplication.sb_safeDistanceBottom;
}

/// 获取keywindow
+ (UIWindow *)sb_keyWindow {
        
    UIWindow *originalKeyWindow = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *))
    {
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes)
        {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]])
            {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows)
                {
                    if (window.isKeyWindow)
                    {
                        originalKeyWindow = window;
                        break;
                    }
                }
            }
        }
    }
    else
#endif
    {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
        originalKeyWindow = [UIApplication sharedApplication].keyWindow;
#endif
    }
    
    return originalKeyWindow;
}

@end
