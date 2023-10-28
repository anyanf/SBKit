//
//  UIApplication+SBExtension.h
//  AFNetworking
//
//  Created by AnKang on 2023/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (SBExtension)

/// 顶部安全区高度
+ (CGFloat)sb_safeDistanceTop;

/// 底部安全区高度
+ (CGFloat)sb_safeDistanceBottom;

/// 顶部状态栏高度（包括安全区）
+ (CGFloat)sb_statusBarHeight;

/// 导航栏高度
+ (CGFloat)sb_navigationBarHeight;

/// 状态栏+导航栏的高度
+ (CGFloat)sb_navigationFullHeight;

/// 底部导航栏高度
+ (CGFloat)sb_tabBarHeight;

/// 底部导航栏高度（包括安全区）
+ (CGFloat)sb_tabBarFullHeight;

@end

NS_ASSUME_NONNULL_END
