//
//  UIView+SBExtension.h
//  Masonry
//
//  Created by 安康 on 2019/9/24.
//

#import <UIKit/UIKit.h>

#import "SBViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SBExtension)
<SBViewProtocol>

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

- (CAGradientLayer *)sb_addGradientColorLayerWithColors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations frame:(CGRect)frame startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;


/// view所在vc
- (UIViewController *)sb_parentViewController;

@end

NS_ASSUME_NONNULL_END
