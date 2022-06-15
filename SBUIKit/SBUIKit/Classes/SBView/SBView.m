//
//  SBView.m
//  Masonry
//
//  Created by 安康 on 2019/9/24.
//

#import "SBView.h"

@implementation SBView

+ (instancetype)createWithFrame:(CGRect)frame {
    
    SBView *imgv = [[self alloc] initWithFrame:frame];
    
    return imgv;
}

- (void)setBorder:(CGFloat)width color:(UIColor *)color redius:(CGFloat)radius {
    self.layer.masksToBounds = YES; //允许绘制
    self.layer.cornerRadius = radius;//边框弧度
    self.layer.borderColor = color.CGColor; //边框颜色
    self.layer.borderWidth = width; //边框的宽度
}

- (void)dealloc {
//    LOG_AK
}

@end
