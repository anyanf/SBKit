//
//  CAAnimation+SBExtension.h
//  SBUIKit
//
//  Created by 安康 on 2020/3/23.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAAnimation (SBExtension)

+ (CAAnimation *)sb_AnimaBackgroundColorFrom:(UIColor *)fromeColor
                                          to:(UIColor *)toColor;

@end

NS_ASSUME_NONNULL_END
