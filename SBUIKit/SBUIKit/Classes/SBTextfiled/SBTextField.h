//
//  SBTextField.h
//  Masonry
//
//  Created by 安康 on 2019/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBTextField : UITextField

/** 判断是否使用粘贴板  Yes使用粘贴板，默认为YES */
@property (nonatomic, assign) BOOL canPaste;

/** 创建一个UItextField */
+ (SBTextField *)createWithFrame:(CGRect)frame
                          target:(id)target;


/** 创建一个UItextField 有默认的占位文字 */
+ (SBTextField *)createWithFrame:(CGRect)frame
                          target:(id)target
                     placeholder:(NSString *)placeholder;

- (instancetype)initWithFrame:(CGRect)frame
                       target:(id)target
                  placeholder:(NSString * __nullable)placeholder;


- (void)setPlaceholderFont:(UIFont *)fontPlaceholder;

- (void)setPlaceholderColor:(UIColor *)colorPlaceholder;


- (void)setBorder:(CGFloat)width color:(UIColor *)color redius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
