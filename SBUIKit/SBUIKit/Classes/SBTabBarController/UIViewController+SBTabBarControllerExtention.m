//
//  UIViewController+SBTabBarControllerExtention.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import "UIViewController+SBTabBarControllerExtention.h"

#import "SBTabBarController.h"

#import <objc/runtime.h>

#define kActualView     [self sb_getActualBadgeSuperView]

@implementation UIViewController (SBTabBarControllerExtention)

#pragma mark -
#pragma mark - public Methods

- (UIViewController *)sb_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index {
    return [self sb_popSelectTabBarChildViewControllerAtIndex:index animated:NO];
}

- (UIViewController *)sb_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated {
    UIViewController *viewController = [self sb_getViewControllerInsteadOfNavigationController];
    [viewController checkTabBarChildControllerValidityAtIndex:index];
    SBTabBarController *tabBarController = [viewController sb_tabBarController];
    [viewController.navigationController popToRootViewControllerAnimated:animated];
    tabBarController.selectedIndex = index;
    UIViewController *selectedTabBarChildViewController = tabBarController.selectedViewController;
    return [selectedTabBarChildViewController sb_getViewControllerInsteadOfNavigationController];
}

- (void)sb_popSelectTabBarChildViewControllerAtIndex:(NSUInteger)index
                                           completion:(SBPopSelectTabBarChildViewControllerCompletion)completion {
    UIViewController *selectedTabBarChildViewController = [self sb_popSelectTabBarChildViewControllerAtIndex:index];
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion(selectedTabBarChildViewController);
    });
}

- (UIViewController *)sb_popSelectTabBarChildViewControllerForClassType:(Class)classType {
    SBTabBarController *tabBarController = [[self sb_getViewControllerInsteadOfNavigationController] sb_tabBarController];
    NSArray *viewControllers = tabBarController.viewControllers;
    NSInteger atIndex = [self sb_indexForClassType:classType inViewControllers:viewControllers];
    return [self sb_popSelectTabBarChildViewControllerAtIndex:atIndex];
}

- (void)sb_popSelectTabBarChildViewControllerForClassType:(Class)classType
                                                completion:(SBPopSelectTabBarChildViewControllerCompletion)completion {
    UIViewController *selectedTabBarChildViewController = [self sb_popSelectTabBarChildViewControllerForClassType:classType];
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion(selectedTabBarChildViewController);
    });
}

- (void)sb_pushOrPopToViewController:(UIViewController *)viewController
                             animated:(BOOL)animated
                             callback:(SBPushOrPopCallback)callback {
    if (!callback) {
        [self.navigationController pushViewController:viewController animated:animated];
        return;
    }
    
    void (^popSelectTabBarChildViewControllerCallback)(BOOL shouldPopSelectTabBarChildViewController, NSUInteger index) = ^(BOOL shouldPopSelectTabBarChildViewController, NSUInteger index) {
        if (shouldPopSelectTabBarChildViewController) {
            [self sb_popSelectTabBarChildViewControllerAtIndex:index completion:^(__kindof UIViewController *selectedTabBarChildViewController) {
                [selectedTabBarChildViewController.navigationController pushViewController:viewController animated:animated];
            }];
        } else {
            [self.navigationController pushViewController:viewController animated:animated];
        }
    };
    NSArray<__kindof UIViewController *> *otherSameClassTypeViewControllersInCurrentNavigationControllerStack = [self sb_getOtherSameClassTypeViewControllersInCurrentNavigationControllerStack:viewController];
    
    SBPushOrPopCompletionHandler completionHandler = ^(BOOL shouldPop,
                                                        __kindof UIViewController *viewControllerPopTo,
                                                        BOOL shouldPopSelectTabBarChildViewController,
                                                        NSUInteger index
                                                        ) {
        if (!otherSameClassTypeViewControllersInCurrentNavigationControllerStack || otherSameClassTypeViewControllersInCurrentNavigationControllerStack.count == 0) {
            shouldPop = NO;
        }
        dispatch_async(dispatch_get_main_queue(),^{
            if (shouldPop) {
                [self.navigationController popToViewController:viewControllerPopTo animated:animated];
                return;
            }
            popSelectTabBarChildViewControllerCallback(shouldPopSelectTabBarChildViewController, index);
        });
    };
    callback(otherSameClassTypeViewControllersInCurrentNavigationControllerStack, completionHandler);
}

- (void)sb_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *fromViewController = [self sb_getViewControllerInsteadOfNavigationController];
    NSArray *childViewControllers = fromViewController.navigationController.childViewControllers;
    if (childViewControllers.count > 0) {
        if ([[childViewControllers lastObject] isKindOfClass:[viewController class]]) {
            return;
        }
    }
    [fromViewController.navigationController pushViewController:viewController animated:animated];
}

- (UIViewController *)sb_getViewControllerInsteadOfNavigationController {
    BOOL isNavigationController = [[self class] isSubclassOfClass:[UINavigationController class]];
    if (isNavigationController && ((UINavigationController *)self).viewControllers.count > 0) {
        return ((UINavigationController *)self).viewControllers[0];
    }
    return self;
}

#pragma mark - public method

- (BOOL)sb_isPlusChildViewController {
    if (!SBPlusChildViewController) {
        return NO;
    }
    return (self == SBPlusChildViewController);
}


- (BOOL)sb_isEmbedInTabBarController {
    if (self.sb_tabBarController == nil) {
        return NO;
    }
    if (self.sb_isPlusChildViewController) {
        return NO;
    }
    BOOL isEmbedInTabBarController = NO;
    UIViewController *viewControllerInsteadIOfNavigationController = [self sb_getViewControllerInsteadOfNavigationController];
    for (NSInteger i = 0; i < self.sb_tabBarController.viewControllers.count; i++) {
        UIViewController * vc = self.sb_tabBarController.viewControllers[i];
        if ([vc sb_getViewControllerInsteadOfNavigationController] == viewControllerInsteadIOfNavigationController) {
            isEmbedInTabBarController = YES;
            [self sb_setTabIndex:i];
            break;
        }
    }
    return isEmbedInTabBarController;
}

- (void)sb_setTabIndex:(NSInteger)tabIndex {
    objc_setAssociatedObject(self, @selector(sb_tabIndex), @(tabIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)sb_tabIndex {
    if (!self.sb_isEmbedInTabBarController) {
        return NSNotFound;
    }
    
    id tabIndexObject = objc_getAssociatedObject(self, @selector(sb_tabIndex));
    NSInteger tabIndex = [tabIndexObject integerValue];
    return tabIndex;
}

- (UIControl *)sb_tabButton {
    if (!self.sb_isEmbedInTabBarController) {
        return nil;
    }
    UITabBarItem *tabBarItem;
    UIControl *control;
    @try {
        tabBarItem = self.sb_tabBarController.tabBar.items[self.sb_tabIndex];
        control = [tabBarItem sb_tabButton];
    } @catch (NSException *exception) {}
    return control;
}

- (NSString *)sb_context {
    return objc_getAssociatedObject(self, @selector(sb_context));
}

- (void)sb_setContext:(NSString *)sb_context {
    objc_setAssociatedObject(self, @selector(sb_context), sb_context, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)sb_plusViewControllerEverAdded {
    NSNumber *sb_plusViewControllerEverAddedObject = objc_getAssociatedObject(self, @selector(sb_plusViewControllerEverAdded));
    return [sb_plusViewControllerEverAddedObject boolValue];
}

- (void)sb_setPlusViewControllerEverAdded:(BOOL)sb_plusViewControllerEverAdded {
    NSNumber *sb_plusViewControllerEverAddedObject = [NSNumber numberWithBool:sb_plusViewControllerEverAdded];
    objc_setAssociatedObject(self, @selector(sb_plusViewControllerEverAdded), sb_plusViewControllerEverAddedObject, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark -
#pragma mark - Private Methods

- (NSArray<__kindof UIViewController *> *)sb_getOtherSameClassTypeViewControllersInCurrentNavigationControllerStack:(UIViewController *)viewController {
    NSArray *currentNavigationControllerStack = [self.navigationController childViewControllers];
    if (currentNavigationControllerStack.count < 2) {
        return nil;
    }
    NSMutableArray *mutableArray = [currentNavigationControllerStack mutableCopy];
    [mutableArray removeObject:self];
    currentNavigationControllerStack = [mutableArray copy];
    
    __block NSMutableArray *mutableOtherViewControllersInNavigationControllerStack = [NSMutableArray arrayWithCapacity:currentNavigationControllerStack.count];
    
    [currentNavigationControllerStack enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *otherViewController = obj;
        if ([otherViewController isKindOfClass:[viewController class]]) {
            [mutableOtherViewControllersInNavigationControllerStack addObject:otherViewController];
        }
    }];
    return [mutableOtherViewControllersInNavigationControllerStack copy];
}

- (void)checkTabBarChildControllerValidityAtIndex:(NSUInteger)index {
    SBTabBarController *tabBarController = [[self sb_getViewControllerInsteadOfNavigationController] sb_tabBarController];
    @try {
        UIViewController *viewController;
        viewController = tabBarController.viewControllers[index];
        UIButton *plusButton = SBExternPlusButton;
        BOOL shouldConfigureSelectionStatus = (SBPlusChildViewController) && ((index != SBPlusButtonIndex) && (viewController != SBPlusChildViewController));
        if (shouldConfigureSelectionStatus) {
            plusButton.selected = NO;
        }
    } @catch (NSException *exception) {
        NSString *formatString = @"\n\n\
        ------ BEGIN NSException Log ---------------------------------------------------------------------\n \
        class name: %@                                                                                    \n \
        ------line: %@                                                                                    \n \
        ----reason: The Class Type or the index or its NavigationController you pass in method `-sb_popSelectTabBarChildViewControllerAtIndex` or `-sb_popSelectTabBarChildViewControllerForClassType` is not the item of SBTabBarViewController \n \
        ------ END ---------------------------------------------------------------------------------------\n\n";
        NSString *reason = [NSString stringWithFormat:formatString,
                            @(__PRETTY_FUNCTION__),
                            @(__LINE__)];
        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), reason);
    }
}

- (NSInteger)sb_indexForClassType:(Class)classType inViewControllers:(NSArray *)viewControllers {
    __block NSInteger atIndex = NSNotFound;
    [viewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *obj_ = [obj sb_getViewControllerInsteadOfNavigationController];
        if ([obj_ isKindOfClass:classType]) {
            atIndex = idx;
            *stop = YES;
            return;
        }
    }];
    return atIndex;
}


- (void)sb_handleNavigationBackAction {
    [self sb_handleNavigationBackActionWithAnimated:YES];
}

- (void)sb_handleNavigationBackActionWithAnimated:(BOOL)animated {
    if (!self.presentationController) {
        [self.navigationController popViewControllerAnimated:animated];
        return;
    }
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:animated];
    } else {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
}

#pragma mark -- public methods

/**
 *  show badge with red dot style and SBBadgeAnimationTypeNone by default.
 */
- (void)sb_showBadge {
    [kActualView sb_showBadge];
}

- (void)sb_showBadgeValue:(NSString *)value
             animationType:(SBBadgeAnimationType)animationType {
    [kActualView sb_showBadgeValue:value animationType:animationType];
}

- (void)sb_clearBadge {
    [kActualView sb_clearBadge];
}

- (void)sb_resumeBadge {
    [kActualView sb_resumeBadge];
}

- (BOOL)sb_isShowBadge {
    return [kActualView sb_isShowBadge];
}

- (BOOL)sb_isPauseBadge {
    return [kActualView sb_isPauseBadge];
}

#pragma mark -- private method

/**
 *  Because UIBarButtonItem is kind of NSObject, it is not able to directly attach badge.
 This method is used to find actual view (non-nil) inside UIBarButtonItem instance.
 *
 *  @return view
 */
- (UITabBarItem *)sb_getActualBadgeSuperView {
    UIViewController *viewController = self.sb_getViewControllerInsteadOfNavigationController;
    UITabBarItem *viewControllerItem = viewController.tabBarItem;
    UIControl *viewControllerControl = viewControllerItem.sb_tabButton;
    UITabBarItem *navigationViewControllerItem = viewController.navigationController.tabBarItem;
    if (viewControllerControl) {
        return viewControllerItem;
    }
    return navigationViewControllerItem;
}

#pragma mark -- setter/getter
- (UILabel *)sb_badge {
    return kActualView.sb_badge;
}

- (void)sb_setBadge:(UILabel *)label {
    [kActualView sb_setBadge:label];
}

- (UIFont *)sb_badgeFont {
    return kActualView.sb_badgeFont;
}

- (void)sb_setBadgeFont:(UIFont *)badgeFont {
    [kActualView sb_setBadgeFont:badgeFont];
}

- (UIColor *)sb_badgeBackgroundColor {
    return [kActualView sb_badgeBackgroundColor];
}

- (void)sb_setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    [kActualView sb_setBadgeBackgroundColor:badgeBackgroundColor];
}

- (UIColor *)sb_badgeTextColor {
    return [kActualView sb_badgeTextColor];
}

- (void)sb_setBadgeTextColor:(UIColor *)badgeTextColor {
    [kActualView sb_setBadgeTextColor:badgeTextColor];
}

- (SBBadgeAnimationType)sb_badgeAnimationType {
    return [kActualView sb_badgeAnimationType];
}

- (void)sb_setBadgeAnimationType:(SBBadgeAnimationType)animationType {
    [kActualView sb_setBadgeAnimationType:animationType];
}

- (CGRect)sb_badgeFrame {
    return [kActualView sb_badgeFrame];
}

- (void)sb_setBadgeFrame:(CGRect)badgeFrame {
    [kActualView sb_setBadgeFrame:badgeFrame];
}

- (CGPoint)sb_badgeCenterOffset {
    return [kActualView sb_badgeCenterOffset];
}

- (void)sb_setBadgeCenterOffset:(CGPoint)badgeCenterOffset {
    [kActualView sb_setBadgeCenterOffset:badgeCenterOffset];
}

- (NSInteger)sb_badgeMaximumBadgeNumber {
    return [kActualView sb_badgeMaximumBadgeNumber];
}

- (void)sb_setBadgeMaximumBadgeNumber:(NSInteger)badgeMaximumBadgeNumber {
    [kActualView sb_setBadgeMaximumBadgeNumber:badgeMaximumBadgeNumber];
}

- (CGFloat)sb_badgeMargin {
    return [kActualView sb_badgeMargin];
}

- (void)sb_setBadgeMargin:(CGFloat)badgeMargin {
    [kActualView sb_setBadgeMargin:badgeMargin];
}

- (CGFloat)sb_badgeRadius {
    return [kActualView sb_badgeRadius];
}

- (void)sb_setBadgeRadius:(CGFloat)badgeRadius {
    [kActualView sb_setBadgeRadius:badgeRadius];
}

- (CGFloat)sb_badgeCornerRadius {
    return [kActualView sb_badgeCornerRadius];
}

- (void)sb_setBadgeCornerRadius:(CGFloat)sb_badgeCornerRadius {
    [kActualView sb_setBadgeCornerRadius:sb_badgeCornerRadius];
}


@end
