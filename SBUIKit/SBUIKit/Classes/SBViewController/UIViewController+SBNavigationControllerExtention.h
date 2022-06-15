//
//  UIViewController+SBNavigationControllerExtention.h
//  SBUIKit
//
//  Created by 安康 on 2019/10/4.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SBNavigationControllerExtention)

@property (nonatomic, assign, getter=sb_disablePopGestureRecognizer, setter=sb_setDisablePopGestureRecognizer:) BOOL sb_disablePopGestureRecognizer;
@property (nonatomic, assign, getter=sb_hideNavigationBarSeparator, setter=sb_setHideNavigationBarSeparator:) BOOL sb_hideNavigationBarSeparator;
@property (nonatomic, assign, getter=sb_navigationBarHidden, setter=sb_setNavigationBarHidden:) BOOL sb_navigationBarHidden;

/*!
 * 使用方法：用在viewWillDisappear/dealloc
 * 作用：在左滑动的过渡的时间段内禁用interactivePopGestureRecognizer，解决自定义导航栏按钮无法响应右滑手势问题。
 */
- (void)sb_disableInteractivePopGestureRecognizer;
/*!
 * use in viewDidDisappear
 * 作用：在左滑动的结束后启用interactivePopGestureRecognizer，解决自定义导航栏按钮无法响应右滑手势问题。
 */
- (void)sb_enableInteractivePopGestureRecognizer;
/*!
 * use in viewDidAppear
 * 当新的视图控制器加载完成后再启用，解决自定义导航栏按钮无法响应右滑手势问题。
 */
- (void)sb_resetInteractivePopGestureRecognizer;
/*!
 * use in viewWillAppear
 */
- (void)sb_hideNavigationBarSeparatorIfNeeded;

- (BOOL)sb_shouldNavigationBarVisible;
//use in viewWillDisappear
- (void)sb_setNavigationBarVisibleIfNeeded:(BOOL)animated;
//use in viewWillAppear
- (void)sb_setNavigationBarHiddenIfNeeded:(BOOL)animated;

- (void)sb_viewWillAppearNavigationSetting:(BOOL)animated;
- (void)sb_viewWillDisappearNavigationSetting:(BOOL)animated;
- (void)sb_viewDidDisappearNavigationSetting:(BOOL)animated;
- (void)sb_viewDidAppearNavigationSetting:(BOOL)animated;
- (void)sb_deallocNavigationSetting;


@end

NS_ASSUME_NONNULL_END
