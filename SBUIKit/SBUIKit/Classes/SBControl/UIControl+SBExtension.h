//
//  UIControl+SBExtension.h
//  SBUIKit
//
//  Created by AnKang on 2023/10/28.
//

#import <UIKit/UIKit.h>

#import "UIView+SBExtension.h"


NS_ASSUME_NONNULL_BEGIN

typedef void (^SBControlEventBlock)(UIControl *button, UIControlEvents controlEvents);

@interface UIControl (SBExtension)

/**
 自定义响应边界 UIEdgeInsetsMake(-3, -4, -5, -6). 表示扩大
 例如： self.btn.hitEdgeInsets = UIEdgeInsetsMake(-3, -4, -5, -6);
 */
@property (nonatomic, assign) UIEdgeInsets hitEdgeInsets;

@property (nonatomic, copy) SBControlEventBlock touchUpInsideEvent;

- (void)addTouchUpInsideEvent:(SBControlEventBlock)touchUpInsideEvent;

@end

NS_ASSUME_NONNULL_END
