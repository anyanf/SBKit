//
//  UITabBarItem+SBBadgeExtention.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//


#import <UIKit/UIKit.h>

#import "SBBadgeProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface UITabBarItem (SBBadgeExtention)<SBBadgeProtocol>

- (BOOL)sb_isShowBadge;
/**
 *  show badge with red dot style and SBBadgeAnimationTypeNone by default.
 */
- (void)sb_showBadge;

/**
 *
 *  @param value String value, default is `nil`. if value equal @"" means red dot style.
 *  @param animationType animationType
 *  @attention
                - 调用该方法前已经添加了系统的角标，调用该方法后，系统的角标并未被移除，只是被隐藏，调用 `-sb_removeTabBadgePoint` 后会重新展示。
                - 不支持 SBPlusChildViewController 对应的 TabBarItem 角标设置，调用会被忽略。
 */
- (void)sb_showBadgeValue:(NSString *)value
             animationType:(SBBadgeAnimationType)animationType;

/**
 *  clear badge(hide badge)
 */
- (void)sb_clearBadge;

/**
 *  make bage(if existing) not hiden
 */
- (void)sb_resumeBadge;

- (BOOL)sb_isPauseBadge;

@end

NS_ASSUME_NONNULL_END
