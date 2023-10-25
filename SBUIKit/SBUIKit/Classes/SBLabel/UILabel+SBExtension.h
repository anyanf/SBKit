//
//  UILabel+SBExtension.h
//  SBUIKit
//
//  Created by ankang on 2023/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SBExtension)

+ (instancetype)createWithFrame:(CGRect)frame
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font;

+ (instancetype)createWithFrame:(CGRect)frame
                           text:(NSString *)text
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font;


+ (instancetype)createWithFrame:(CGRect)frame
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font
                  textAlignment:(NSTextAlignment)textAlignment;

+ (instancetype)createWithFrame:(CGRect)frame
                           text:(NSString *)text
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font
                  textAlignment:(NSTextAlignment)textAlignment;


- (void)setLabelTextColor:(UIColor *)textColor
                     font:(UIFont *)font
            textAlignment:(NSTextAlignment)textAlignment;

+ (instancetype)createWithFrame:(CGRect)frame
                    borderColor:(UIColor *)borderColor;
- (void)borderAnimate:(CGFloat)time nextText:(NSString *)text;

- (void)alignTop;

- (void)alignBottom;

@end

NS_ASSUME_NONNULL_END
