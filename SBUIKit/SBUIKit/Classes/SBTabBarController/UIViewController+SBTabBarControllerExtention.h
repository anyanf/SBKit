//
//  UIViewController+SBTabBarControllerExtention.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import <UIKit/UIKit.h>

#import "SBBadgeProtocol.h"
#import "SBTabBarConstants.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SBPopSelectTabBarChildViewControllerCompletion)(__kindof UIViewController *selectedTabBarChildViewController);

typedef void (^SBPushOrPopCompletionHandler)(BOOL shouldPop,
                                              __kindof UIViewController *viewControllerPopTo,
                                              BOOL shouldPopSelectTabBarChildViewController,
                                              NSUInteger index
                                              );

typedef void (^SBPushOrPopCallback)(NSArray<__kindof UIViewController *> *viewControllers, SBPushOrPopCompletionHandler completionHandler);

@interface UIViewController (SBTabBarControllerExtention)


@property (nonatomic, readonly, getter=sb_isEmbedInTabBarController) BOOL sb_embedInTabBarController;

@property (nonatomic, readonly, getter=sb_tabIndex) NSInteger sb_tabIndex;

@property (nonatomic, readonly) UIControl *sb_tabButton;

@property (nonatomic, copy, setter=sb_setContext:, getter=sb_context) NSString *sb_context;

@property (nonatomic, assign, setter=sb_setPlusViewControllerEverAdded:, getter=sb_plusViewControllerEverAdded) BOOL sb_plusViewControllerEverAdded;

- (BOOL)sb_isShowBadge;
/**
 *  show badge with red dot style and SBBadgeAnimationTypeNone by default.
 */
- (void)sb_showBadge;

/**
 *
 *  @param value String value, default is `nil`. if value equal @"" means red dot style.
 *  @param animationType animationType
 *  @attention
 - 调用该方法前已经添加了系统的角标，调用该方法后，系统的角标并未被移除，只是被隐藏，调用 `-sb_removeTabBadgePoint` 后会重新展示。
 - 不支持 SBPlusChildViewController 对应的 TabBarItem 角标设置，调用会被忽略。
 */
- (void)sb_showBadgeValue:(NSString *)value
             animationType:(SBBadgeAnimationType)animationType;

/**
 *  clear badge(hide badge)
 */
- (void)sb_clearBadge;

/**
 *  make bage(if existing) not hiden
 */
- (void)sb_resumeBadge;

- (BOOL)sb_isPauseBadge;


/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 @param index 需要选择的控制器在 `TabBar` 中的 index。
 @return 最终被选择的控制器。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类，该方法无 pop 动画。
 */
- (UIViewController *)sb_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 @param index 需要选择的控制器在 `TabBar` 中的 index。
 @param animated 动画
 @return 最终被选择的控制器。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */
- (UIViewController *)sb_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器在 `Block` 回调中返回。
 @param index 需要选择的控制器在 `TabBar` 中的 index。
 @attention 注意：方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
 */
- (void)sb_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index
                                           completion:(SBPopSelectTabBarChildViewControllerCompletion)completion;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器作为返回值返回。
 @param classType 需要选择的控制器所属的类。
 @return 最终被选择的控制器。
 @attention 注意：
                - 方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
                - 如果 TabBarViewController 的 viewControllers 中包含多个相同的 `classType` 类型，会返回最左端的一个。
 
 */
- (UIViewController *)sb_popSelectTabBarChildViewControllerForClassType:(Class)classType;

/*!
 * Pop 到当前 `NavigationController` 的栈底，并改变 `TabBarController` 的 `selectedViewController` 属性，并将被选择的控制器在 `Block` 回调中返回。
 @param classType 需要选择的控制器所属的类。
 @attention 注意：
                - 方法中的参数和返回值都是 `UIViewController` 的子类，但并非 `UINavigationController` 的子类。
                - 如果 TabBarViewController 的 viewControllers 中包含多个相同的 `classType` 类型，会返回最左端的一个。
 */
- (void)sb_popSelectTabBarChildViewControllerForClassType:(Class)classType
                                                completion:(SBPopSelectTabBarChildViewControllerCompletion)completion;

/*!
 *@brief 如果当前的 `NavigationViewController` 栈中包含有准备 Push 到的目标控制器，可以选择 Pop 而非 Push。
 *@param viewController Pop 或 Push 到的“目标控制器”，由 completionHandler 的参数控制 Pop 和 Push 的细节。
 *@param animated Pop 或 Push 时是否带动画
 *@param callback 回调，如果传 nil，将进行 Push。callback 包含以下几个参数：
                 * param : viewControllers 表示与“目标控制器”相同类型的控制器；
                 * param : completionHandler 包含以下几个参数：
                                            * param : shouldPop 是否 Pop
                                            * param : viewControllerPopTo Pop 回的控制器
                                            * param : shouldPopSelectTabBarChildViewController 在进行 Push 行为之前，是否 Pop 到当前 `NavigationController` 的栈底。
                                                                                             可能的值如下：
                                                                                             NO 如果上一个参数为 NO，下一个参数 index 将被忽略。
                                                                                             YES 会根据 index 参数改变 `TabBarController` 的 `selectedViewController` 属性。
                                                                                             注意：该属性在 Pop 行为时不起作用。
                                             * param : index Pop 改变 `TabBarController` 的 `selectedViewController` 属性。
                                                           注意：该属性在 Pop 行为时不起作用。
*/
- (void)sb_pushOrPopToViewController:(UIViewController *)viewController
                             animated:(BOOL)animated
                             callback:(SBPushOrPopCallback)callback;

/*!
 * 如果正要 Push 的页面与当前栈顶的页面类型相同则取消 Push
 * 这样做防止主界面卡顿时，导致一个 ViewController 被 Push 多次
 */
- (void)sb_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (UIViewController *)sb_getViewControllerInsteadOfNavigationController;
- (void)sb_handleNavigationBackAction;
- (void)sb_handleNavigationBackActionWithAnimated:(BOOL)animated;

@end



NS_ASSUME_NONNULL_END
