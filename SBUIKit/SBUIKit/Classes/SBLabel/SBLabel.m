//
//  SBLabel.m
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import "SBLabel.h"
#import "CAAnimation+SBExtension.h"

@implementation SBLabel

+ (instancetype)createWithFrame:(CGRect)frame
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font {
    SBLabel *lab = [self createWithFrame:frame
                                    text:@""
                               textColor:textColor
                                    font:font];
    return lab;
}

+ (instancetype)createWithFrame:(CGRect)frame
                           text:(NSString *)text
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font {
    SBLabel *lab = [self createWithFrame:frame
                                    text:text
                               textColor:textColor
                                    font:font
                           textAlignment:NSTextAlignmentLeft];
    return lab;
}


+ (instancetype)createWithFrame:(CGRect)frame
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font
                  textAlignment:(NSTextAlignment)textAlignment {
    SBLabel *lab = [self createWithFrame:frame
                                    text:@""
                               textColor:textColor
                                    font:font
                           textAlignment:textAlignment];
    return lab;
}

+ (instancetype)createWithFrame:(CGRect)frame
                           text:(NSString *)text
                      textColor:(UIColor *)textColor
                           font:(UIFont *)font
                  textAlignment:(NSTextAlignment)textAlignment {
    SBLabel *lab = [[self alloc] initWithFrame:frame];
    lab.text = text;
    [lab setLabelTextColor:textColor
                      font:font
             textAlignment:textAlignment];
    return lab;
}



- (void)setLabelTextColor:(UIColor *)textColor
                     font:(UIFont *)font
            textAlignment:(NSTextAlignment)textAlignment {
    self.textColor = textColor;
    self.font = font;
    self.textAlignment = textAlignment;
}


+ (instancetype)createWithFrame:(CGRect)frame
                      borderColor:(UIColor *)borderColor {
    SBLabel *lab = [self createWithFrame:frame
                                      text:@""
                                 textColor:[UIColor grayColor]
                                      font:[UIFont systemFontOfSize:12]];
    
    CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    SBLabel *borderLab = [self createWithFrame:rect
                                      text:@""
                                 textColor:[UIColor grayColor]
                                      font:[UIFont systemFontOfSize:12]];
    borderLab.layer.masksToBounds = YES;
    borderLab.layer.borderColor = borderColor.CGColor;
    borderLab.layer.borderWidth = 1;
    borderLab.alpha = 0;
    borderLab.tag = 10000;
    
    [lab addSubview:borderLab];
    
    return lab;
}

- (void)borderAnimate:(CGFloat)time nextText:(NSString *)text {
    
    if ([self.text containsString:@"--"] ||
        self.text.floatValue == 0.0 ||
        [text containsString:@"--"] ||
        text.floatValue == 0.0)  {
        return;
    }
    
    if(self.text.floatValue == text.floatValue) {
        return;
    }
    
    UIColor *color = [UIColor colorWithRed:247/255.0 green:60/255.0 blue:46/255.0 alpha:1];
    if(self.text.floatValue > text.floatValue) {
        color = [UIColor colorWithRed:51/255.0 green:189/255.0 blue:89/255.0 alpha:1];
    }
    
    CAAnimation *ani = [CAAnimation sb_AnimaBackgroundColorFrom:self.backgroundColor to:[color colorWithAlphaComponent:0.2]];
    [self.layer addAnimation:ani forKey:@"bg"];
    
}

/*
 + (instancetype)createWithFrame:(CGRect)frame
                       borderColor:(UIColor *)borderColor {
     SBLabel *lab = [self createWithFrame:frame
                                       text:@""
                                  textColor:[UIColor grayColor]
                                       font:[UIFont systemFontOfSize:12]];
     
     CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
     SBLabel *borderLab = [self createWithFrame:rect
                                       text:@""
                                  textColor:[UIColor grayColor]
                                       font:[UIFont systemFontOfSize:12]];
     borderLab.layer.masksToBounds = YES;
     borderLab.layer.borderColor = borderColor.CGColor;
     borderLab.layer.borderWidth = 1;
     borderLab.alpha = 0;
     borderLab.tag = 10000;
     
     [lab addSubview:borderLab];
     
     return lab;
 }
 
- (void)borderAnimate:(CGFloat)time nextText:(NSString *)text {
    
    if ([self.text containsString:@"--"] ||
        self.text.floatValue == 0.0 ||
        [text containsString:@"--"] ||
        text.floatValue == 0.0)  {
        return;
    }
    
    if(self.text.floatValue == text.floatValue) {
        return;
    }
    
    SBLabel *label;
    for (int i=0; i<self.subviews.count; i++) {
        label = [self.subviews objectAtIndex:i];
        if ([label isKindOfClass:UILabel.class] && label.tag == 10000) {
            break;
        }
    }

    label.alpha = 1.0;
    [UIView animateWithDuration:time animations:^{
        label.alpha = 0.0;
    }];

}
*/

- (void)alignTop {
    CGSize fontSize = [self.text sb_sizeWithFont:self.font
                                            size:CGSizeMake(CGFLOAT_MAX,
                                                            CGFLOAT_MAX)];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;

    CGSize theStringSize = [self.text sb_sizeWithFont:self.font
                                                 size:CGSizeMake(finalWidth,
                                                                 finalHeight)
                                                 mode:self.lineBreakMode];
    

    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;

    for(int i=0; i< newLinesToPad; i++) {
        self.text = [self.text stringByAppendingString:@" \n"];
    }
}

- (void)alignBottom {
    CGSize fontSize = [self.text sb_sizeWithFont:self.font
                                            size:CGSizeMake(CGFLOAT_MAX,
                                                            CGFLOAT_MAX)];

    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label


    CGSize theStringSize = [self.text sb_sizeWithFont:self.font
                                                 size:CGSizeMake(finalWidth, finalHeight)
                                                 mode:self.lineBreakMode];


    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;

    for(int i=0; i< newLinesToPad; i++) {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    }
}

@end
