//
//  SBTabBarController.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/26.
//

#import <UIKit/UIKit.h>

#import "SBPlusButton.h"

#import "NSObject+SBTabBarControllerExtention.h"

#import "SBTabBar+SBTabBarControllerExtention.h"

#import "UIViewController+SBTabBarControllerExtention.h"

#import "UITabBarItem+SBTabBarControllerExtention.h"
#import "UITabBarItem+SBBadgeExtention.h"



NS_ASSUME_NONNULL_BEGIN

@class SBTabBarController;

typedef void(^SBViewDidLayoutSubViewsBlock)(SBTabBarController *tabBarController);

FOUNDATION_EXTERN NSString *const SBTabBarItemTitle;
FOUNDATION_EXTERN NSString *const SBTabBarItemImage;
FOUNDATION_EXTERN NSString *const SBTabBarItemSelectedImage;
FOUNDATION_EXTERN NSString *const SBTabBarLottieURL;
FOUNDATION_EXTERN NSString *const SBTabBarLottieSize;
FOUNDATION_EXTERN NSString *const SBTabBarItemImageInsets;
FOUNDATION_EXTERN NSString *const SBTabBarItemTitlePositionAdjustment;
FOUNDATION_EXTERN NSUInteger SBTabbarItemsCount;
FOUNDATION_EXTERN NSUInteger SBPlusButtonIndex;
FOUNDATION_EXTERN CGFloat SBPlusButtonWidth;
FOUNDATION_EXTERN CGFloat SBTabBarItemWidth;
FOUNDATION_EXTERN CGFloat SBTabBarHeight;

FOUNDATION_EXTERN NSString *const SBTabBarItemWidthDidChangeNotification;

@protocol SBTabBarControllerDelegate <NSObject, UITabBarControllerDelegate>
@optional
/*!
 * @param tabBarController The tab bar controller containing viewController.
 * @param control Selected UIControl in TabBar.
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control;

@end

@interface SBTabBarController : UITabBarController

@property (nonatomic, copy) SBViewDidLayoutSubViewsBlock viewDidLayoutSubviewsBlock;

- (void)setViewDidLayoutSubViewsBlock:(SBViewDidLayoutSubViewsBlock)viewDidLayoutSubviewsBlock;
- (void)setViewDidLayoutSubViewsBlockInvokeOnce:(BOOL)invokeOnce block:(SBViewDidLayoutSubViewsBlock)viewDidLayoutSubviewsBlock;
/*!
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, readwrite, copy) NSArray<UIViewController *> *viewControllers;

/*!
 * The Attributes of items which is displayed on the tab bar.
 */
@property (nonatomic, readwrite, copy) NSArray<NSDictionary *> *tabBarItemsAttributes;

/*!
 * Customize UITabBar height
 */
@property (nonatomic, assign) CGFloat tabBarHeight;

/*!
 * To set both UIBarItem image view attributes in the tabBar,
 * default is UIEdgeInsetsZero.
 */
@property (nonatomic, readonly, assign) UIEdgeInsets imageInsets;

@property (nonatomic, strong, readonly) SBTabBar *tabBar;

/*!
 * To set both UIBarItem label text attributes in the tabBar,
 * use the following to tweak the relative position of the label within the tab button (for handling visual centering corrections if needed because of custom text attributes)
 */
@property (nonatomic, readonly, assign) UIOffset titlePositionAdjustment;

@property (nonatomic, readonly, copy) NSString *context;



- (instancetype)initWithViewControllers:(nullable NSArray<UIViewController *> *)viewControllers
                  tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes
                            imageInsets:(UIEdgeInsets)imageInsets
                titlePositionAdjustment:(UIOffset)titlePositionAdjustment
                                context:(NSString *)context;

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                              tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes
                                        imageInsets:(UIEdgeInsets)imageInsets
                            titlePositionAdjustment:(UIOffset)titlePositionAdjustment
                                            context:(NSString *)context;

- (void)updateSelectionStatusIfNeededForTabBarController:(nullable UITabBarController *)tabBarController shouldSelectViewController:(nullable UIViewController *)viewController;

- (void)updateSelectionStatusIfNeededForTabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController shouldSelect:(BOOL)shouldSelect;

- (void)hideTabBarShadowImageView;

- (void)setTintColor:(UIColor *)tintColor;

/*!
 * Judge if there is plus button.
 */
+ (BOOL)havePlusButton;

/*!
 * @attention Include plusButton if exists.
 */
+ (NSUInteger)allItemsInTabBarCount;

- (id<UIApplicationDelegate>)appDelegate;

- (UIWindow *)rootWindow;

@end

@interface NSObject (SBTabBarControllerReferenceExtension)

/*!
 * If `self` is kind of `UIViewController`, this method will return the nearest ancestor in the view controller hierarchy that is a tab bar controller. If `self` is not kind of `UIViewController`, it will return the `rootViewController` of the `rootWindow` as long as you have set the `SBTabBarController` as the  `rootViewController`. Otherwise return nil. (read-only)
 */
@property (nonatomic, nullable, setter=sb_setTabBarController:) SBTabBarController *sb_tabBarController;

@end

NS_ASSUME_NONNULL_END
