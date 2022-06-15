//
//  SBTableViewCell.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/28.
//

#import "SBTableViewCell.h"

#import "UIColor+SBExtension.h"

#import "UIImage+SBExtension.h"

@implementation SBTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self setCellAndContentViewBackgroundColor:[UIColor whiteColor]];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

    }

    return self;
}

- (void)setShowRightArrow:(BOOL)showRightArrow {
    _showRightArrow = showRightArrow;
    
    if (showRightArrow) {
        // SB_Next_Gray_Arrow_icon
        UIImage *img = SB_UIKit_IMG_K(@"SB_Next_Gray_Arrow_icon");
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        view.frame = CGRectMake(0, 0, 14, 24);
        self.accessoryView = view;
    } else {
        self.accessoryView = nil;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.showRightArrow) {
            // 去掉 accessoryView的h间距
        CGRect contentAdjustedFrame = self.contentView.frame;
        contentAdjustedFrame.size.width += 10.0f;
        self.contentView.frame = contentAdjustedFrame;
        
        CGRect accessoryAdjustedFrame = self.accessoryView.frame;
        accessoryAdjustedFrame.origin.x += 10.0f;
        self.accessoryView.frame = accessoryAdjustedFrame;
    }
}

- (void)setCellAndContentViewBackgroundColor:(UIColor *)backgroundColor {
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

+ (CGFloat)cellHeightWithModel:(id)model {
    return CGFLOAT_MIN;
}


@end
