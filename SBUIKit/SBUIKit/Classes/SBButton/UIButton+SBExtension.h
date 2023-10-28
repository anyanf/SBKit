//
//  UIButton+SBExtension.h
//  SBUIKit
//
//  Created by AnKang on 2023/10/28.
//

#import <UIKit/UIKit.h>

#import "UIControl+SBExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SBExtension)

- (void)setTitle:(NSString *)titleStr
      titleColor:(UIColor *)titleColor
        forState:(UIControlState)state;

- (void)setTitle:(NSString *)titleStr
      titleColor:(UIColor *)titleColor
           image:(nullable UIImage *)image
 backgroundImage:(nullable UIImage *)backgroundImage
        forState:(UIControlState)state;

- (void)setImageForALLState:(nullable UIImage *)image;

- (void)setBackgroundImageForALLState:(nullable UIImage *)image;


@end

NS_ASSUME_NONNULL_END
