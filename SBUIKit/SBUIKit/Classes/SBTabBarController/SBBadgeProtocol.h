//
//  SBBadgeProtocol.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#ifndef SBBadgeProtocol_h
#define SBBadgeProtocol_h

#pragma mark -- types definition

#define SBBadgeBreatheAnimationKey     @"breathe"
#define SBBadgeRotateAnimationKey      @"rotate"
#define SBBadgeShakeAnimationKey       @"shake"
#define SBBadgeScaleAnimationKey       @"scale"
#define SBBadgeBounceAnimationKey      @"bounce"

typedef NS_ENUM(NSUInteger, SBBadgeStyle) {
    SBBadgeStyleRedDot = 1,          /* red dot style */
    SBBadgeStyleNumber,              /* badge with number */
    SBBadgeStyleNew,                  /* badge with a fixed text "new" */
    SBBadgeStyleOther                /* badge with a fixed text */
};

typedef NS_ENUM(NSUInteger, SBBadgeAnimationType) {
    SBBadgeAnimationTypeNone = 0,         /* without animation, badge stays still */
    SBBadgeAnimationTypeScale,            /* scale effect */
    SBBadgeAnimationTypeShake,            /* shaking effect */
    SBBadgeAnimationTypeBounce,           /* bouncing effect */
    SBBadgeAnimationTypeBreathe           /* breathing light effect, which makes badge more attractive */
};

#pragma mark -- protocol definition

@protocol SBBadgeProtocol <NSObject>

@required

@property (nonatomic, strong, getter=sb_badge, setter=sb_setBadge:) UILabel *sb_badge; /* badge entity, which is adviced not to set manually */

@property (nonatomic, strong, getter=sb_badgeFont, setter=sb_setBadgeFont:) UIFont *sb_badgeFont; /* [UIFont boldSystemFontOfSize:9] by default if not set */

@property (nonatomic, strong, getter=sb_badgeBackgroundColor, setter=sb_setBadgeBackgroundColor:) UIColor *sb_badgeBackgroundColor; /* red color by default if not set */
@property (nonatomic, strong, getter=sb_badgeTextColor, setter=sb_setBadgeTextColor:) UIColor *sb_badgeTextColor; /* white color by default if not set */
@property (nonatomic, assign, getter=sb_badgeFrame, setter=sb_setBadgeFrame:) CGRect sb_badgeFrame; /* we have optimized the badge frame and center.
                                                                                                         This property is adviced not to set manually */

@property (nonatomic, assign, getter=sb_badgeCenterOffset, setter=sb_setBadgeCenterOffset:) CGPoint sb_badgeCenterOffset; /* offset from right-top corner. {0,0} by default */
/* For x, negative number means left offset
 For y, negative number means bottom offset */

@property (nonatomic, assign, getter=sb_badgeAnimationType, setter=sb_setBadgeAnimationType:) SBBadgeAnimationType sb_badgeAnimationType;/* NOTE that this is not animation type of badge's
                                                                                                                                              //                                                                                                      appearing, nor  hidding*/

@property (nonatomic, assign, getter=sb_badgeMaximumBadgeNumber, setter=sb_setBadgeMaximumBadgeNumber:) NSInteger sb_badgeMaximumBadgeNumber; /*for SBBadgeStyleNumber style badge,
                                                                                                                                                  if badge value is above badgeMaximumBadgeNumber,
                                                                                                                                                  "badgeMaximumBadgeNumber+" will be printed. */

@property (nonatomic, assign, getter=sb_badgeRadius, setter=sb_setBadgeRadius:) CGFloat sb_badgeRadius;

@property (nonatomic, assign, getter=sb_badgeMargin, setter=sb_setBadgeMargin:) CGFloat sb_badgeMargin; /**< // normal use for text and number style of badge */

@property (nonatomic, assign, getter=sb_badgeCornerRadius, setter=sb_setBadgeCornerRadius:) CGFloat sb_badgeCornerRadius;

- (BOOL)sb_isShowBadge;

/**
 *  show badge with red dot style and SBBadgeAnimationTypeNone by default.
 */
- (void)sb_showBadge;

/**
 *
 *  @param value String value, default is `nil`. if value equal @"" means red dot style.
 *  @param animationType  animationType
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


#endif /* SBBadgeProtocol_h */
