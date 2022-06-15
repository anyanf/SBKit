//
//  SBTableViewHeaderFooterView.m
//  Pods
//
//  Created by 安康 on 2019/11/13.
//

#import "SBTableViewHeaderFooterView.h"

@implementation SBTableViewHeaderFooterView




- (void)setViewAndContentViewBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    self.contentView.backgroundColor = backgroundColor;
}

//// 绘制分割线，暂时不需要
//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor); CGContextFillRect(context, rect);
//    CGContextSetStrokeColorWithColor(context, [UIColor sb_colorWithHexString:@"0xffffff"].CGColor);
//    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1)); //下分割线
//    CGContextSetStrokeColorWithColor(context, [UIColor sb_colorWithHexString:@"0xe2e2e2"].CGColor);
//    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
// }

- (void)handleModel:(id)model {

}

+ (CGFloat)viewHeightWithModel:(id)model {
    return CGFLOAT_MIN;
}
@end
