//
//  UIView+SBExtension.h
//  Masonry
//
//  Created by 安康 on 2019/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SBExtension)

/// 初始化
+ (instancetype)createWithFrame:(CGRect)frame;

@property (assign, nonatomic) CGFloat sb_x;
@property (assign, nonatomic) CGFloat sb_y;
@property (assign, nonatomic) CGFloat sb_w;
@property (assign, nonatomic) CGFloat sb_h;
@property (assign, nonatomic) CGSize sb_size;
@property (assign, nonatomic) CGPoint sb_origin;
@property (assign, nonatomic) CGFloat sb_maxX;
@property (assign, nonatomic) CGFloat sb_maxY;
@property (assign, nonatomic) CGFloat sb_centerX;
@property (assign, nonatomic) CGFloat sb_centerY;

@property (assign, nonatomic) CGFloat sb_cornerRadius;

/** 全面屏底部的安全区域 */
- (CGFloat)safeBottomInset;

@end

NS_ASSUME_NONNULL_END
