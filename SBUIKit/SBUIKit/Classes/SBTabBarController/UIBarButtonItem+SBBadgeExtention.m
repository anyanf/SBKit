//
//  UIBarButtonItem+SBBadgeExtention.m
//  SBUIKit
//
//  Created by 安康 on 2019/10/4.
//

#import "UIBarButtonItem+SBBadgeExtention.h"

#import "UIView+SBBadgeExtention.h"


#import <objc/runtime.h>

#define kActualView     [self sb_getActualBadgeSuperView]


@implementation UIBarButtonItem (SBBadgeExtention)


#pragma mark -- public methods

/**
 *  show badge with red dot style and SBBadgeAnimationTypeNone by default.
 */
- (void)sb_showBadge {
    [kActualView sb_showBadge];
}

- (void)sb_showBadgeValue:(NSString *)value
            animationType:(SBBadgeAnimationType)animationType {
    [kActualView sb_showBadgeValue:value animationType:animationType];
}

- (void)sb_clearBadge {
    [kActualView sb_clearBadge];
}

- (void)sb_resumeBadge {
    [kActualView sb_resumeBadge];
}

- (BOOL)sb_isPauseBadge {
    return [kActualView sb_isPauseBadge];
}

- (BOOL)sb_isShowBadge {
    return [kActualView sb_isShowBadge];
}

#pragma mark -- private method

/**
 *  Because UIBarButtonItem is kind of NSObject, it is not able to directly attach badge.
 This method is used to find actual view (non-nil) inside UIBarButtonItem instance.
 *
 *  @return view
 */
- (UIView *)sb_getActualBadgeSuperView {
    return [self valueForKeyPath:@"_view"];//use KVC to hack actual view
}

#pragma mark -- setter/getter
- (UILabel *)sb_badge {
    return kActualView.sb_badge;
}

- (void)sb_setBadge:(UILabel *)label {
    [kActualView sb_setBadge:label];
}

- (UIFont *)sb_badgeFont {
    return kActualView.sb_badgeFont;
}

- (void)sb_setBadgeFont:(UIFont *)badgeFont {
    [kActualView sb_setBadgeFont:badgeFont];
}

- (UIColor *)sb_badgeBackgroundColor {
    return [kActualView sb_badgeBackgroundColor];
}

- (void)sb_setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    [kActualView sb_setBadgeBackgroundColor:badgeBackgroundColor];
}

- (UIColor *)sb_badgeTextColor {
    return [kActualView sb_badgeTextColor];
}

- (void)sb_setBadgeTextColor:(UIColor *)badgeTextColor {
    [kActualView sb_setBadgeTextColor:badgeTextColor];
}

- (SBBadgeAnimationType)sb_badgeAnimationType {
    return [kActualView sb_badgeAnimationType];
}

- (void)sb_setBadgeAnimationType:(SBBadgeAnimationType)animationType {
    [kActualView sb_setBadgeAnimationType:animationType];
}

- (CGRect)sb_badgeFrame {
    return [kActualView sb_badgeFrame];
}

- (void)sb_setBadgeFrame:(CGRect)badgeFrame {
    [kActualView sb_setBadgeFrame:badgeFrame];
}

- (CGPoint)sb_badgeCenterOffset {
    return [kActualView sb_badgeCenterOffset];
}

- (void)sb_setBadgeCenterOffset:(CGPoint)badgeCenterOffset {
    [kActualView sb_setBadgeCenterOffset:badgeCenterOffset];
}

- (NSInteger)sb_badgeMaximumBadgeNumber {
    return [kActualView sb_badgeMaximumBadgeNumber];
}

- (void)sb_setBadgeMaximumBadgeNumber:(NSInteger)badgeMaximumBadgeNumber {
    [kActualView sb_setBadgeMaximumBadgeNumber:badgeMaximumBadgeNumber];
}

- (CGFloat)sb_badgeMargin {
    return [kActualView sb_badgeMargin];
}

- (void)sb_setBadgeMargin:(CGFloat)badgeMargin {
    [kActualView sb_setBadgeMargin:badgeMargin];
}

- (CGFloat)sb_badgeRadius {
    return [kActualView sb_badgeRadius];
}

- (void)sb_setBadgeRadius:(CGFloat)badgeRadius {
    [kActualView sb_setBadgeRadius:badgeRadius];
}

- (CGFloat)sb_badgeCornerRadius {
    return [kActualView sb_badgeCornerRadius];
}

- (void)sb_setBadgeCornerRadius:(CGFloat)sb_badgeCornerRadius {
    [kActualView sb_setBadgeCornerRadius:sb_badgeCornerRadius];
}


@end
