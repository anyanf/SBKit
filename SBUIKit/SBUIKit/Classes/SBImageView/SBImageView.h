//
//  SBImageView.h
//  Pods
//
//  Created by 安康 on 2019/10/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBImageView : UIImageView

+ (instancetype)createWithFrame:(CGRect)frame;

+ (instancetype)createWithFrame:(CGRect)frame image:(UIImage *)img;

- (void)addEvent:(void(^)(UIPanGestureRecognizer *gestureRecognizer))eventBlock;
- (void)drawRoundImageToImageView;
@end

NS_ASSUME_NONNULL_END
