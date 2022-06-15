//
//  SBTabBar+SBTabBarControllerExtention.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//


#import "SBTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBTabBar (SBTabBarControllerExtention)

- (NSArray<UIControl *> *)sb_visibleControls;
- (NSArray<UIControl *> *)sb_subTabBarButtons;
- (NSArray<UIControl *> *)sb_subTabBarButtonsWithoutPlusButton;
- (UIControl *)sb_tabBarButtonWithTabIndex:(NSUInteger)tabIndex;
- (void)sb_animationLottieImageWithSelectedControl:(UIControl *)selectedControl
                                          lottieURL:(NSURL *)lottieURL
                                               size:(CGSize)size
                                          defaultSelected:(BOOL)defaultSelected;
- (void)sb_stopAnimationOfAllLottieView;
- (NSArray *)sb_originalTabBarButtons;
- (BOOL)sb_hasPlusChildViewController;

@end

NS_ASSUME_NONNULL_END
