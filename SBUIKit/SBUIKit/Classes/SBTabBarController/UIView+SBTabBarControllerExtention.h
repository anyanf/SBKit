//
//  UIView+SBTabBarControllerExtention.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//


#import <UIKit/UIKit.h>

#import "SBTabBarConstants.h"


NS_ASSUME_NONNULL_BEGIN


@interface UIView (SBTabBarControllerExtention)

- (BOOL)sb_isPlusButton;
- (BOOL)sb_isTabButton;
- (BOOL)sb_isTabImageView;
- (BOOL)sb_isTabLabel;
- (BOOL)sb_isTabBadgeView;
- (BOOL)sb_isTabBackgroundView;
- (UIView *)sb_tabBadgeView;
- (UIImageView *)sb_tabImageView;
- (UILabel *)sb_tabLabel;
- (UIImageView *)sb_tabShadowImageView;
- (UIVisualEffectView *)sb_tabEffectView;
- (BOOL)sb_isLottieAnimationView;
- (UIView *)sb_tabBackgroundView;
+ (UIView *)sb_tabBadgePointViewWithClolor:(UIColor *)color radius:(CGFloat)radius;
- (NSArray *)sb_allSubviews;

@end

NS_ASSUME_NONNULL_END
