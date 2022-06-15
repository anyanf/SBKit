//
//  UITabBarItem+SBBadgeExtention.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import "UITabBarItem+SBBadgeExtention.h"

#import <objc/runtime.h>

#import "UITabBarItem+SBTabBarControllerExtention.h"

#import "UIControl+SBTabBarControllerExtention.h"

#import "UIView+SBBadgeExtention.h"
#import "UIView+SBTabBarControllerExtention.h"

#define kActualView     [self sb_getActualBadgeSuperView]

@implementation UITabBarItem (SBBadgeExtention)
+ (void)load {
    [self sb_swizzleSetBadgeValue];
}

+ (void)sb_swizzleSetBadgeValue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sb_ClassMethodSwizzle([self class], @selector(setBadgeValue:), @selector(sb_setBadgeValue:));
    });
}

- (void)sb_setBadgeValue:(NSString *)badgeValue {
    [self.sb_tabButton sb_removeTabBadgePoint];
    [self sb_clearBadge];
    [self sb_setBadgeValue:badgeValue];
}

#pragma mark -- public methods

/**
 *  show badge with red dot style and SBBadgeAnimationTypeNone by default.
 */
- (void)sb_showBadge {
    [kActualView sb_showBadgeValue:@"" animationType:SBBadgeAnimationTypeNone];
}

- (void)sb_showBadgeValue:(NSString *)value animationType:(SBBadgeAnimationType)animationType {
    [kActualView sb_showBadgeValue:value animationType:animationType];
    self.sb_tabButton.sb_tabBadgeView.hidden = YES;
}

- (BOOL)sb_isShowBadge {
    return [kActualView sb_isShowBadge];
}

- (BOOL)sb_isPauseBadge {
    return [kActualView sb_isPauseBadge];
}

/**
 *  clear badge
 */
- (void)sb_clearBadge {
    [kActualView sb_clearBadge];
    self.sb_tabButton.sb_tabBadgeView.hidden = NO;
}

- (void)sb_resumeBadge {
    [kActualView sb_resumeBadge];
    self.sb_tabButton.sb_tabBadgeView.hidden = YES;
}

#pragma mark -- private method

/**
 *  Because UIBarButtonItem is kind of NSObject, it is not able to directly attach badge.
 This method is used to find actual view (non-nil) inside UIBarButtonItem instance.
 *
 *  @return view
 */
- (UIView *)sb_getActualBadgeSuperView {
    UIControl *tabButton = [self sb_tabButton];
    // badge label will be added onto imageView
    UIImageView *tabImageView = [tabButton sb_tabImageView];
    UIView *lottieAnimationView = (UIView *)tabButton.sb_lottieAnimationView ;
    UIView *actualBadgeSuperView = tabImageView;
    
    do {
        if (tabImageView && !tabImageView.sb_isInvisiable) {
            actualBadgeSuperView = tabImageView;
            break;
        }
        if (lottieAnimationView && !lottieAnimationView.sb_isInvisiable) {
            actualBadgeSuperView = lottieAnimationView;
            break;
        }
    } while (NO);
    [lottieAnimationView setClipsToBounds:NO];
    return actualBadgeSuperView;
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

#pragma mark - private method

BOOL sb_ClassMethodSwizzle(Class aClass, SEL originalSelector, SEL swizzleSelector) {
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(aClass, swizzleSelector);
    BOOL didAddMethod =
    class_addMethod(aClass,
                    originalSelector,
                    method_getImplementation(swizzleMethod),
                    method_getTypeEncoding(swizzleMethod));
    if (didAddMethod) {
        class_replaceMethod(aClass,
                            swizzleSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
    return YES;
}

@end
