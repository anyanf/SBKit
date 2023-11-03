//
//  UIButton+SBExtension.m
//  SBUIKit
//
//  Created by AnKang on 2023/10/28.
//

#import "UIButton+SBExtension.h"

@implementation UIButton (SBExtension)


- (void)setTitle:(NSString *)titleStr
      titleColor:(UIColor *)titleColor
        forState:(UIControlState)state {
    [self setTitle:titleStr forState:state];
    [self setTitleColor:titleColor forState:state];
}

- (void)setTitle:(NSString *)titleStr
      titleColor:(UIColor *)titleColor
           image:(UIImage *)image
 backgroundImage:(UIImage *)backgroundImage
        forState:(UIControlState)state {
    
    [self setTitle:titleStr forState:state];
    [self setTitleColor:titleColor forState:state];
    [self setImage:image forState:state];
    [self setBackgroundImage:backgroundImage forState:state];
}


- (void)setImageForALLState:(nullable UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateDisabled];
    [self setImage:image forState:UIControlStateSelected];
    
}


- (void)setBackgroundImageForALLState:(nullable UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    [self setBackgroundImage:image forState:UIControlStateDisabled];
    [self setBackgroundImage:image forState:UIControlStateSelected];
}

- (void)setBorder:(CGFloat)width color:(UIColor *)color redius:(CGFloat)radius {
    self.layer.masksToBounds = YES; //允许绘制
    self.layer.cornerRadius = radius;//边框弧度
    self.layer.borderColor = color.CGColor; //边框颜色
    self.layer.borderWidth = width; //边框的宽度
}

/// 文字图片都在中间
- (void)centerTextAndImage:(BOOL)imageAboveText spacing:(CGFloat)spacing {
    if (imageAboveText) {
        
        CGSize imageSize = self.imageView.image.size;
        NSString *text = self.titleLabel.text;
        UIFont *font = self.titleLabel.font;
        
        if (CGSizeEqualToSize(imageSize, CGSizeZero) ||
            !text ||
            !font) {
            return;
        }
        
        CGSize titleSize = [text sizeWithAttributes:@{NSFontAttributeName: font}];
        
        CGFloat titleOffset = -(imageSize.height + spacing);
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, titleOffset, 0.0);

        CGFloat imageOffset = -(titleSize.height + spacing);
        self.imageEdgeInsets = UIEdgeInsetsMake(imageOffset, 0.0, 0.0, -titleSize.width);
        
        CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    } else {
        CGFloat insetAmount = spacing / 2;
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -insetAmount, 0, insetAmount);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, -insetAmount);
        self.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
    }
}


/// 文字左图片右
- (void)centerTextAndImage:(CGFloat)spacing {
    
    CGSize imageSize = self.imageView.image.size;
    NSString *text = self.titleLabel.text;
    UIFont *font = self.titleLabel.font;
    
    if (CGSizeEqualToSize(imageSize, CGSizeZero) ||
        !text ||
        !font) {
        return;
    }
    
    CGSize titleSize = [text sizeWithAttributes:@{NSFontAttributeName: font}];

    CGFloat titleOffset = -(imageSize.width + spacing);
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, titleOffset, 0.0, -titleOffset);
    
    CGFloat imageOffset = (titleSize.width + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, imageOffset, 0.0, -imageOffset);
    
    CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    self.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
}

@end
