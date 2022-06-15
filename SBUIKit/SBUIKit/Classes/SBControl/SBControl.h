//
//  SBControl.h
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBControl : UIControl


+ (instancetype)createWithFrame:(CGRect)frame
                     eventBlock:(void(^)(SBControl *control, UIControlEvents controlEvents))eventBlock;

- (void)addEvent:(void(^)(SBControl *control, UIControlEvents controlEvents))eventBlock;

@end

NS_ASSUME_NONNULL_END
