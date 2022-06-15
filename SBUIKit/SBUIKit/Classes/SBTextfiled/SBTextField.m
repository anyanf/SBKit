//
//  SBTextField.m
//  Masonry
//
//  Created by 安康 on 2019/9/24.
//

#import "SBTextField.h"

#import "UIColor+SBExtension.h"

@interface SBTextField ()

// 默认文字的大小
@property (nonatomic, strong) UIFont *placeholderFont;

// 默认文字的颜色
@property (nonatomic,strong) UIColor *placeholderColor;

@end

@implementation SBTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置定制属性
        [self setCustomAttribute];
    }
    return self;
}

// 设置定制属性，与APP的UI规范 有关
- (void)setCustomAttribute {
    // 默认为YES，允许粘贴复制操作
    _canPaste = YES;

    // 设置textField的样式
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeCenter;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

}

// 重写方法，设置占位文字的默认颜色和大小
- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    // 如果存在placeholder
    if (placeholder) {
        UIColor *colorPlaceholder = [UIColor sb_colorWithRGB:0x999999];
        UIFont *fontPlaceholder = [UIFont systemFontOfSize:15.0];
        
        _placeholderFont = fontPlaceholder;
        _placeholderColor = colorPlaceholder;
        
        // 设置占位文字默认的样式
        NSDictionary *dicAttri = @{
                                   NSForegroundColorAttributeName : colorPlaceholder,
                                   NSFontAttributeName : fontPlaceholder
                                   };
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                     attributes:dicAttri];
    }
}

- (void)setBorder:(CGFloat)width color:(UIColor *)color redius:(CGFloat)radius {
    self.layer.masksToBounds = YES; //允许绘制
    self.layer.cornerRadius = radius;//边框弧度
    self.layer.borderColor = color.CGColor; //边框颜色
    self.layer.borderWidth = width; //边框的宽度
}


#pragma mark - ********************************** 初始化方法 *********************************

// 创建一个普通的UItextField
+ (SBTextField *)createWithFrame:(CGRect)frame
                          target:(id)target {
    SBTextField *textField = [[self alloc] initWithFrame:frame
                                                  target:target
                                             placeholder:nil];    
    return textField;
}

// 创建一个普通的 UItextField 有默认的占位文字
+ (SBTextField *)createWithFrame:(CGRect)frame
                        target:(id)target
                   placeholder:(NSString *)placeholder {
    SBTextField *textField = [[self alloc] initWithFrame:frame
                                                  target:target
                                             placeholder:placeholder];
    
    return textField;
}

- (instancetype)initWithFrame:(CGRect)frame
                       target:(id)target
                  placeholder:(NSString * __nullable)placeholder {
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = target;
        self.placeholder = placeholder;
        
    }
    return self;
}


#pragma mark - ********************************** 设置 *********************************

// 设置占位文字的大小
- (void)setPlaceholderFont:(UIFont *)fontPlaceholder {
    
    if (self.placeholder && fontPlaceholder) {
        // 保存文字大小
        _placeholderFont = fontPlaceholder;
        
        // 设置占位文字的样式
        NSDictionary *dicAttri = @{
                                   NSForegroundColorAttributeName : _placeholderColor,
                                   NSFontAttributeName : fontPlaceholder
                                   };
        
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:dicAttri];
    }
}

// 设置占位文字的颜色
- (void)setPlaceholderColor:(UIColor *)colorPlaceholder {
    
    if (self.placeholder && colorPlaceholder) {
        /// 保存文字颜色
        _placeholderColor = colorPlaceholder;
        
        /// 设置占位文字的样式
        NSDictionary *dicAttri = @{
                                   NSForegroundColorAttributeName : colorPlaceholder,
                                   NSFontAttributeName : _placeholderFont
                                   };
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                          attributes:dicAttri];
    }
}

// 判断是否禁止使用粘贴板
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (!_canPaste) {
        if (action == @selector(cut:)) {
            return NO;
        }
        else if(action == @selector(copy:)) {
            return NO;
        }
        else if(action == @selector(paste:)) {
            return NO;
        }
        else if(action == @selector(select:)) {
            return NO;
        }
        else if(action == @selector(selectAll:)) {
            return NO;
        }
        else if(action == @selector(delete:)) {
            return NO;
        } else {
            return [super canPerformAction:action withSender:sender];
        }
    }
    return [super canPerformAction:action withSender:sender];
}


#pragma mark - *************************************** 长选删除 **************************************

- (void)delete:(id)content {
    // 未发现有异常情况，打开注释，修复长按出现删除没反应问题
    if (self.selectedTextRange.isEmpty) return;
    [self replaceRange:self.selectedTextRange withText:@""];
}

- (void)dealloc {
    LOG_AK
}

@end
