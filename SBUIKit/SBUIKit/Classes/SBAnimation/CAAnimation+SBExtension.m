//
//  CAAnimation+SBExtension.m
//  SBUIKit
//
//  Created by 安康 on 2020/3/23.
//

#import "CAAnimation+SBExtension.h"



@implementation CAAnimation (SBExtension)

+ (CAAnimation *)sb_AnimaBackgroundColorFrom:(UIColor *)fromeColor
                                          to:(UIColor *)toColor {
    
    if (![fromeColor isKindOfClass:UIColor.class]) {
        fromeColor = UIColor.clearColor;
    }
    
    if (![toColor isKindOfClass:UIColor.class]) {
        toColor = UIColor.blackColor;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.fromValue = (__bridge id _Nullable)(fromeColor.CGColor);
    animation.toValue = (__bridge id _Nullable)(toColor.CGColor);
    animation.autoreverses = YES;
    animation.duration = 1.0;
    animation.repeatCount = 0;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeRemoved;
    return animation;
}

@end
