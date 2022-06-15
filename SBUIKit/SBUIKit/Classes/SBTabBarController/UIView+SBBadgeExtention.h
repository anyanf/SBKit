//
//  UIView+SBBadgeExtention.h
//  Masonry
//
//  Created by 安康 on 2019/9/27.
//


#import <UIKit/UIKit.h>

#import "SBBadgeProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface UIView (SBBadgeExtention)<SBBadgeProtocol>


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
;

// wBadgeStyle default is SBBadgeStyleNumber ;
// SBBadgeAnimationType defualt is  SBBadgeAnimationTypeNone
- (void)sb_showBadgeValue:(NSString *)value;

/**
 *  clear badge(hide badge)
 */
- (void)sb_clearBadge;

/**
 *  make bage(if existing) not hiden
 */
- (void)sb_resumeBadge;

- (BOOL)sb_isPauseBadge;

- (BOOL)sb_isInvisiable;
- (BOOL)sb_canNotResponseEvent;

@end

NS_ASSUME_NONNULL_END
