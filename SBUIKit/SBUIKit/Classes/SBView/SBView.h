//
//  SBView.h
//  Masonry
//
//  Created by 安康 on 2019/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBView : UIView

+ (instancetype)createWithFrame:(CGRect)frame;
- (void)setBorder:(CGFloat)width color:(UIColor *)color redius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
