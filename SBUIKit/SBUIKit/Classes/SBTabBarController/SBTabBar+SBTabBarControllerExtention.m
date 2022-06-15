//
//  SBTabBar+SBTabBarControllerExtention.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import "SBTabBar+SBTabBarControllerExtention.h"

#import <objc/runtime.h>

#import "SBTabBarController.h"

#import "UIView+SBTabBarControllerExtention.h"
#import "UIView+SBBadgeExtention.h"
#import "UIControl+SBTabBarControllerExtention.h"


@implementation SBTabBar (SBTabBarControllerExtention)

- (BOOL)sb_hasPlusChildViewController {
    NSString *context = SBPlusChildViewController.sb_context;
    BOOL isSameContext = [context isEqualToString:self.context] && (context && (context.length > 0) && self.context && self.context.length > 0);
    BOOL isAdded = [[self sb_tabBarController].viewControllers containsObject:SBPlusChildViewController];
    BOOL isEverAdded = SBPlusChildViewController.sb_plusViewControllerEverAdded;
    if (SBPlusChildViewController && isSameContext && isAdded && isEverAdded) {
        return YES;
    }
    return NO;
}

- (NSArray *)sb_originalTabBarButtons {
    NSArray *tabBarButtons = [self sb_tabBarButtonFromTabBarSubviews:[self sb_sortedSubviews]];
    return tabBarButtons;
}

- (NSArray *)sb_sortedSubviews {
    if (self.subviews.count == 0) {
        return self.subviews;
    }
    NSMutableArray *tabBarButtonArray = [NSMutableArray arrayWithCapacity:self.subviews.count];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj sb_isTabButton]) {
            [tabBarButtonArray addObject:obj];
        }
    }];
    
    NSArray *sortedSubviews = [[tabBarButtonArray copy] sortedArrayUsingComparator:^NSComparisonResult(UIView * formerView, UIView * latterView) {
        CGFloat formerViewX = formerView.frame.origin.x;
        CGFloat latterViewX = latterView.frame.origin.x;
        return  (formerViewX > latterViewX) ? NSOrderedDescending : NSOrderedAscending;
    }];
    return sortedSubviews;
}

- (NSArray *)sb_tabBarButtonFromTabBarSubviews:(NSArray *)tabBarSubviews {
    if (tabBarSubviews.count == 0) {
        return tabBarSubviews;
    }
    NSMutableArray *tabBarButtonMutableArray = [NSMutableArray arrayWithCapacity:tabBarSubviews.count];
    [tabBarSubviews enumerateObjectsUsingBlock:^(UIControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj sb_isTabButton]) {
            [tabBarButtonMutableArray addObject:obj];
            [obj sb_setTabBarChildViewControllerIndex:idx];
        }
    }];
    if ([self sb_hasPlusChildViewController]) {
        @try {
            UIControl *control = tabBarButtonMutableArray[SBPlusButtonIndex];
            control.userInteractionEnabled = NO;
            control.hidden = YES;
        } @catch (NSException *exception) {}
    }
    return [tabBarButtonMutableArray copy];
}

- (NSArray *)sb_visibleControls {
    NSMutableArray *originalTabBarButtons = [NSMutableArray arrayWithArray:[self.sb_originalTabBarButtons copy]];
    BOOL notAdded = (NSNotFound == [originalTabBarButtons indexOfObject:SBExternPlusButton]);
    if (SBExternPlusButton && notAdded) {
        [originalTabBarButtons addObject:SBExternPlusButton];
    }
        if (originalTabBarButtons.count == 0) {
            return nil;
        }
        NSMutableArray *tabBarButtonArray = [NSMutableArray arrayWithCapacity:originalTabBarButtons.count];
        [originalTabBarButtons enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat width = obj.frame.size.width;
            BOOL isInvisiable = obj.sb_canNotResponseEvent;
            BOOL isNotSubView = (width < 10);
            BOOL canNotResponseEvent = isInvisiable || isNotSubView ;
            if (canNotResponseEvent) {
                return;
            }
            if (([obj sb_isTabButton] || [obj sb_isPlusButton] ) ) {
                [tabBarButtonArray addObject:obj];
            }
        }];
        
        NSArray *sortedSubviews = [[tabBarButtonArray copy] sortedArrayUsingComparator:^NSComparisonResult(UIView * formerView, UIView * latterView) {
            CGFloat formerViewX = formerView.frame.origin.x;
            CGFloat latterViewX = latterView.frame.origin.x;
            return  (formerViewX > latterViewX) ? NSOrderedDescending : NSOrderedAscending;
        }];
        return sortedSubviews;
}

- (NSArray<UIControl *> *)sb_subTabBarButtons {
    NSMutableArray *subControls = [NSMutableArray arrayWithCapacity:self.sb_visibleControls.count];
    [self.sb_visibleControls enumerateObjectsUsingBlock:^(UIControl * _Nonnull control, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([control sb_isPlusButton] && !SBPlusChildViewController.sb_plusViewControllerEverAdded) {
            return;
        }
        [subControls addObject:control];
    }];
    return subControls;
}

- (NSArray<UIControl *> *)sb_subTabBarButtonsWithoutPlusButton {
    NSMutableArray *subControls = [NSMutableArray arrayWithCapacity:self.sb_visibleControls.count];
    [self.sb_visibleControls enumerateObjectsUsingBlock:^(UIControl * _Nonnull control, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([control sb_isPlusButton]) {
            return;
        }
        [subControls addObject:control];
    }];
    return subControls;
}

- (UIControl *)sb_tabBarButtonWithTabIndex:(NSUInteger)tabIndex {
    UIControl *selectedControl = [self sb_visibleControlWithIndex:tabIndex];
    
    NSInteger plusViewControllerIndex = [self.sb_tabBarController.viewControllers indexOfObject:SBPlusChildViewController];
    BOOL isPlusViewControllerAdded =  SBPlusChildViewController.sb_plusViewControllerEverAdded && (plusViewControllerIndex != NSNotFound);
    
    if (isPlusViewControllerAdded) {
        return selectedControl;
    }
    
    @try {
        selectedControl = [self sb_subTabBarButtonsWithoutPlusButton][tabIndex];
    } @catch (NSException *exception) {
        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), exception.reason);
    }
    return selectedControl;
}

- (UIControl *)sb_visibleControlWithIndex:(NSUInteger)index {
    UIControl *selectedControl;
    @try {
        NSArray *subControls =  self.sb_visibleControls;
        selectedControl = subControls[index];
    } @catch (NSException *exception) {
        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), exception.reason);
    }
    return selectedControl;
}
- (void)sb_animationLottieImageWithSelectedControl:(UIControl *)selectedControl
                                          lottieURL:(NSURL *)lottieURL
                                               size:(CGSize)size
                                    defaultSelected:(BOOL)defaultSelected {
#if __has_include(<Lottie/Lottie.h>)
    [selectedControl sb_addLottieImageWithLottieURL:lottieURL size:size];
    [self sb_stopAnimationOfAllLottieView];
    LOTAnimationView *lottieView = selectedControl.sb_lottieAnimationView;
    if (!lottieView) {
        [selectedControl sb_addLottieImageWithLottieURL:lottieURL size:size];
    }
    if (lottieView && [lottieView isKindOfClass:[LOTAnimationView class]]) {
        if (defaultSelected) {
            lottieView.animationProgress = 1;
            [lottieView forceDrawingUpdate];
            return;
        }
        lottieView.animationProgress = 0;
        [lottieView play];
    }
#else
#endif
}

- (void)sb_stopAnimationOfAllLottieView {
#if __has_include(<Lottie/Lottie.h>)
    [self.sb_visibleControls enumerateObjectsUsingBlock:^(UIControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.sb_lottieAnimationView stop];
    }];
#else
#endif
}


@end

@implementation NSObject (SBTabBarControllerReferenceExtension)


- (void)sb_setTabBarController:(SBTabBarController *)tabBarController {
    //OBJC_ASSOCIATION_ASSIGN instead of OBJC_ASSOCIATION_RETAIN_NONATOMIC to avoid retain circle
    id __weak weakObject = tabBarController;
    id (^block)(void) = ^{ return weakObject; };
    objc_setAssociatedObject(self, @selector(sb_tabBarController),
                             block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//TODO: 更新实现，多实例场景下进行栈操作，弹出最新一个。
- (SBTabBarController *)sb_tabBarController {
    SBTabBarController *tabBarController;
    id (^block)(void) = objc_getAssociatedObject(self, @selector(sb_tabBarController));
    tabBarController = (block ? block() : nil);
    if (tabBarController && [tabBarController isKindOfClass:[SBTabBarController class]]) {
        return tabBarController;
    }
    if ([self isKindOfClass:[UIViewController class]] && [(UIViewController *)self parentViewController]) {
        tabBarController = [[(UIViewController *)self parentViewController] sb_tabBarController];
        if ([tabBarController isKindOfClass:[SBTabBarController class]]) {
            return tabBarController;
        }
    }
    id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
    UIWindow *window = delegate.window;
    UIViewController *rootViewController = [window.rootViewController sb_getViewControllerInsteadOfNavigationController];;
    if ([rootViewController isKindOfClass:[SBTabBarController class]]) {
        tabBarController = (SBTabBarController *)rootViewController;
    }
    return tabBarController;
}


@end

