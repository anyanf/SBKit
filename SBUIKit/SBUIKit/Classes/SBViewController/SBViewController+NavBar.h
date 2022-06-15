//
//  SBViewController+NavBar.h
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import "SBViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBViewController (NavBar)

- (void)setNavBarTitle:(id)title;

- (void)setNavBarBackItemWithclickBlock:(void(^ __nullable)(void))clickBlock;

- (void)setNavBarBackItemWithclickBlock:(void(^)(void))clickBlock isAutoPop:(BOOL)isAutoPop;

- (void)setNavBarLeftItemWithCustomView:(UIView *)customView clickBlock:(void(^)(void))clickBlock;

- (void)setNavBarRightItemWithCustomView:(UIView *)customView clickBlock:(void(^)(void))clickBlock;

- (UIImage *)sb_captureNavBar;

@end

NS_ASSUME_NONNULL_END
