//
//  UIBarButtonItem+SBBadgeExtention.h
//  SBUIKit
//
//  Created by 安康 on 2019/10/4.
//


#import <UIKit/UIKit.h>

#import "SBBadgeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (SBBadgeExtention)<SBBadgeProtocol>

- (BOOL)sb_isShowBadge;

/**
 *  show badge with red dot style and SBBadgeAnimationTypeNone by default.
 */
- (void)sb_showBadge;

/**
 *  sb_showBadge
 *
 *  @param value String value, default is `nil`. if value equal @"" means red dot style.
 *  @param animationType animationType
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
