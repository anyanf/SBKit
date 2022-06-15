//
//  SBButton.h
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SBButton;

typedef void(^SBButtonEventBlock)(SBButton *button, UIControlEvents controlEvents);

@interface SBButton : UIButton

/**
 自定义响应边界 UIEdgeInsetsMake(-3, -4, -5, -6). 表示扩大
 例如： self.btn.hitEdgeInsets = UIEdgeInsetsMake(-3, -4, -5, -6);
 */
@property(nonatomic, assign) UIEdgeInsets hitEdgeInsets;

+ (instancetype)createWithFrame:(CGRect)frame;

+ (instancetype)createWithFrame:(CGRect)frame
                     eventBlock:(SBButtonEventBlock __nullable)eventBlock;

- (instancetype)initWithFrame:(CGRect)frame
                   eventBlock:(SBButtonEventBlock __nullable)eventBlock;


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


- (void)setBorder:(CGFloat)width color:(UIColor *)color redius:(CGFloat)radius;

- (void)addEvent:(SBButtonEventBlock)eventBlock;

@end

NS_ASSUME_NONNULL_END
