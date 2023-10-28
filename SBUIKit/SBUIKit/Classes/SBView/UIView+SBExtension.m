//
//  UIView+SBExtension.m
//  Masonry
//
//  Created by 安康 on 2019/9/24.
//

#import "UIView+SBExtension.h"


@implementation UIView (SBExtension)

+ (instancetype)createWithFrame:(CGRect)frame {
    
    return [[self alloc] initWithFrame:frame];
}

- (void)setBorder:(CGFloat)width color:(UIColor *)color redius:(CGFloat)radius {
    self.layer.masksToBounds = YES; //允许绘制
    self.layer.cornerRadius = radius;//边框弧度
    self.layer.borderColor = color.CGColor; //边框颜色
    self.layer.borderWidth = width; //边框的宽度
}

- (void)setSb_x:(CGFloat)sb_x {
    CGRect frame = self.frame;
    frame.origin.x = sb_x;
    self.frame = frame;
}

- (CGFloat)sb_x {
    return self.frame.origin.x;
}

- (void)setSb_y:(CGFloat)sb_y {
    CGRect frame = self.frame;
    frame.origin.y = sb_y;
    self.frame = frame;
}

- (CGFloat)sb_y {
    return self.frame.origin.y;
}

- (void)setSb_w:(CGFloat)sb_w {
    CGRect frame = self.frame;
    frame.size.width = sb_w;
    self.frame = frame;
}

- (CGFloat)sb_w {
    return self.frame.size.width;
}

- (void)setSb_h:(CGFloat)sb_h {
    CGRect frame = self.frame;
    frame.size.height = sb_h;
    self.frame = frame;
}

- (CGFloat)sb_h {
    return self.frame.size.height;
}

- (void)setSb_size:(CGSize)sb_size {
    CGRect frame = self.frame;
    frame.size = sb_size;
    self.frame = frame;
}

- (CGSize)sb_size {
    return self.frame.size;
}

- (void)setSb_origin:(CGPoint)sb_origin {
    CGRect frame = self.frame;
    frame.origin = sb_origin;
    self.frame = frame;
}

- (CGPoint)sb_origin {
    return self.frame.origin;
}

- (CGFloat)sb_maxX {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setSb_maxX:(CGFloat)maxX {
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}

- (CGFloat)sb_maxY {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setSb_maxY:(CGFloat)maxY {
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}

- (CGFloat)sb_centerX {
    return self.center.x;
}

- (void)setSb_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)sb_centerY {
    return self.center.y;
}

- (void)setSb_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)sb_cornerRadius {
    return  self.layer.cornerRadius;
}

- (void)setSb_cornerRadius:(CGFloat)sb_cornerRadius {
    self.layer.cornerRadius = sb_cornerRadius;
    self.layer.masksToBounds = YES;
}


#pragma mark - SBViewProtocol默认实现

+ (CGFloat)sb_viewHeight {
    return 0;
}

+ (CGFloat)sb_viewHeightWithMaxSize:(CGSize)maxSize {
    return 0;
}

+ (CGFloat)sb_viewHeightWithModel:(id _Nullable)model andMaxSize:(CGSize)maxSize {
    return 0;
}

+ (CGSize)sb_viewSize {
    return CGSizeZero;
}

+ (CGSize)sb_viewSizeWithMaxSize:(CGSize)maxSize {
    return CGSizeZero;
}

+ (CGSize)sb_viewSizeWithModel:(id _Nullable)model andMaxSize:(CGSize)maxSize {
    return CGSizeZero;
}

- (void)sb_handleModel:(id _Nullable)model {
    // 等继承实现
}


@end
