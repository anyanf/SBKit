//
//  CAAnimation+SBBadgeExtention.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//


#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, SBAxis) {
    SBAxisX = 0,
    SBAxisY,
    SBAxisZ
};

// Degrees to radians
#define SB_DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define SB_RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface CAAnimation (SBBadgeExtention)

/**
 *  breathing forever
 *
 *  @param time duritaion, from clear to fully seen
 *
 *  @return animation obj
 */
+ (CABasicAnimation *)sb_opacityForever_Animation:(float)time;

/**
 *  breathing with fixed repeated times
 *
 *  @param repeatTimes times
 *  @param time        duritaion, from clear to fully seen
 *
 *  @return animation obj
 */
+ (CABasicAnimation *)sb_opacityTimes_Animation:(float)repeatTimes durTimes:(float)time;

/**
 *  //rotate
 *
 *  @param dur         duration
 *  @param degree      rotate degree in radian(弧度)
 *  @param axis        axis
 *  @param repeatCount repeat count
 *
 *  @return animation obj
 */
+ (CABasicAnimation *)sb_rotation:(float)dur degree:(float)degree direction:(SBAxis)axis repeatCount:(int)repeatCount;


/**
 *  scale animation
 *
 *  @param fromScale   the original scale value, 1.0 by default
 *  @param toScale     target scale
 *  @param time        duration
 *  @param repeatTimes repeat counts
 *
 *  @return animaiton obj
 */
+ (CABasicAnimation *)sb_scaleFrom:(CGFloat)fromScale toScale:(CGFloat)toScale durTimes:(float)time rep:(float)repeatTimes;
/**
 *  shake
 *
 *  @param repeatTimes time
 *  @param time        duration
 *  @param obj         always be CALayer at present
 *  @return aniamtion obj
 */
+ (CAKeyframeAnimation *)sb_shake_AnimationRepeatTimes:(float)repeatTimes durTimes:(float)time forObj:(id)obj;

/**
 *  bounce
 *
 *  @param repeatTimes time
 *  @param time        duration
 *  @param obj         always be CALayer at present
 *  @return aniamtion obj
 */
+ (CAKeyframeAnimation *)sb_bounce_AnimationRepeatTimes:(float)repeatTimes durTimes:(float)time forObj:(id)obj;


@end

NS_ASSUME_NONNULL_END
