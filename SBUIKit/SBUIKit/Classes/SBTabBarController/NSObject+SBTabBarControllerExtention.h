//
//  NSObject+SBTabBarControllerExtention.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SBTabBarControllerExtention)

@property (nonatomic, assign, getter=sb_isForceLandscape, setter=sb_setIsForceLandscape:) BOOL sb_isForceLandscape;

+ (void)sb_forceUpdateInterfaceOrientation:(UIInterfaceOrientation)orientation;

+ (UIResponder<UIApplicationDelegate> *)sb_sharedAppDelegate;
+ (UIViewController * __nullable)sb_topmostViewController;

+ (UINavigationController * __nullable)sb_currentNavigationController;

+ (void)sb_dismissAll:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
