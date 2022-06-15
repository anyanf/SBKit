//
//  UIControl+SBTabBarControllerExtention.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//


#import <UIKit/UIKit.h>

#import "SBTabBarController.h"


NS_ASSUME_NONNULL_BEGIN

@class LOTAnimationView;

@interface UIControl (SBTabBarControllerExtention)


- (LOTAnimationView *)sb_lottieAnimationView;
- (BOOL)sb_isChildViewControllerPlusButton;

/*!
 * 调用该方法前已经添加了系统的角标，调用该方法后，系统的角标并未被移除，只是被隐藏，调用 `-sb_removeTabBadgePoint` 后会重新展示。
 */
- (void)sb_showTabBadgePoint;
- (void)sb_removeTabBadgePoint;
- (BOOL)sb_isShowTabBadgePoint;
- (BOOL)sb_isSelected;
@property (nonatomic, strong, setter=sb_setTabBadgePointView:, getter=sb_tabBadgePointView) UIView *sb_tabBadgePointView;
@property (nonatomic, assign, setter=sb_setTabBadgePointViewOffset:, getter=sb_tabBadgePointViewOffset) UIOffset sb_tabBadgePointViewOffset;
/*!
 * PlusButton without plusViewController equals NSNotFound
 */
@property (nonatomic, assign, getter=sb_tabBarChildViewControllerIndex, setter=sb_setTabBarChildViewControllerIndex:) NSInteger sb_tabBarChildViewControllerIndex;

/*!
 * PlusButton has its own visible index,
 * in this case PlusButton is same as TabBarItem
 */
@property (nonatomic, assign, getter=sb_tabBarItemVisibleIndex, setter=sb_setTabBarItemVisibleIndex:) NSInteger sb_tabBarItemVisibleIndex;

@property (nonatomic, assign, getter=sb_shouldNotSelect, setter=sb_setShouldNotSelect:) BOOL sb_shouldNotSelect;

- (void)sb_addLottieImageWithLottieURL:(NSURL *)lottieURL
                                   size:(CGSize)size;

- (void)sb_replaceTabImageViewWithNewView:(UIView *)newView
                             show:(BOOL)show;

- (void)sb_replaceTabImageViewWithNewView:(UIView *)newView
                                           offset:(UIOffset)offset
                                    show:(BOOL)show
                                       completion:(void(^)(BOOL isReplaced, UIControl *tabBarButton, UIView *newView))completion;

- (void)sb_replaceTabButtonWithNewView:(UIView *)newView
                                   show:(BOOL)show;

- (void)sb_replaceTabButtonWithNewView:(UIView *)newView
                                 offset:(UIOffset)offset
                                   show:(BOOL)theShow
                             completion:(void(^)(BOOL isReplaced, UIControl *tabBarButton, UIView *newView))completion;

@end

NS_ASSUME_NONNULL_END
