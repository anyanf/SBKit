//
//  SBWarningView.m
//  SBUIKit
//
//  Created by 安康 on 2020/2/6.
//

#import "SBWarningView.h"

#import "SBImageView.h"
#import "SBButton.h"

#import "UIView+SBExtension.h"
#import "UILabel+SBExtension.h"

@implementation SBWarningViewItem @end


@implementation SBWarningView


- (void)config:(NSArray<SBWarningViewItem *> *)items {
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    static CGFloat defautItemHeight = 44;
    
    CGFloat allHeight = 0;
    
    for (SBWarningViewItem *item in items) {
        
        if (item.size.height > 0) {
            allHeight += item.size.height;
        } else {
            allHeight += defautItemHeight;
        }
    }
    
    
    CGFloat originY = ceil((self.sb_h - allHeight)/2);
    
    for (SBWarningViewItem *item in items) {
        
        CGRect frame =  CGRectMake(ceil((self.sb_w - item.size.width)/2),
                                   originY,
                                   item.size.width,
                                   item.size.height > 0 ? item.size.height : defautItemHeight);
        
        switch (item.type) {
            case SBWarningViewItem_Type_None: {
                
            }
                break;
                
            case SBWarningViewItem_Type_Title: {
                
                UILabel *title = [UILabel createWithFrame:frame
                                                     text:item.text
                                                textColor:item.textColor
                                                     font:item.textFont
                                            textAlignment:NSTextAlignmentCenter];
                [self addSubview:title];
                
            }
                break;
            case SBWarningViewItem_Type_Desc: {
                UILabel *desc = [UILabel createWithFrame:frame
                                                    text:item.text
                                               textColor:item.textColor
                                                    font:item.textFont
                                           textAlignment:NSTextAlignmentCenter];
                [self addSubview:desc];
            }
                break;
            case SBWarningViewItem_Type_Btn: {
                SBButton *btn = [SBButton createWithFrame:frame
                                               eventBlock:item.btnEventBlock];
                
                [btn setTitle:item.text titleColor:item.textColor forState:UIControlStateNormal];
                btn.titleLabel.font = item.textFont;
                
                [self addSubview:btn];
            }
                break;
            case SBWarningViewItem_Type_Img: {
                SBImageView *img = [SBImageView createWithFrame:frame image:item.img];
                [self addSubview:img];
            }
                break;
        }
        
        originY = CGRectGetMaxY(frame);
    }
    
}



@end
