//
//  SBPlusButton.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import "SBPlusButton.h"

#import "SBTabBarController.h"



CGFloat SBPlusButtonWidth = 0.0f;
UIButton<SBPlusButtonSubclassing> *SBExternPlusButton = nil;
UIViewController *SBPlusChildViewController = nil;

@implementation SBPlusButton


#pragma mark -
#pragma mark - public Methods

+ (void)registerPlusButton {
    if (![self conformsToProtocol:@protocol(SBPlusButtonSubclassing)]) {
        return;
    }
    Class<SBPlusButtonSubclassing> class = self;
    UIButton<SBPlusButtonSubclassing> *plusButton = [class plusButton];
    SBExternPlusButton = plusButton;
    SBPlusButtonWidth = plusButton.frame.size.width;
    if ([[self class] respondsToSelector:@selector(plusChildViewController)]) {
        SBPlusChildViewController = [class plusChildViewController];
        if ([[self class] respondsToSelector:@selector(tabBarContext)]) {
            NSString *tabBarContext = [class tabBarContext];
            if (tabBarContext && tabBarContext.length) {
                [SBPlusChildViewController sb_setContext:tabBarContext];
            }
        } else {
            [SBPlusChildViewController sb_setContext:NSStringFromClass([SBTabBarController class])];
        }
        [[self class] addSelectViewControllerTarget:plusButton];
        if ([[self class] respondsToSelector:@selector(indexOfPlusButtonInTabBar)]) {
            SBPlusButtonIndex = [[self class] indexOfPlusButtonInTabBar];
        } else {
            [NSException raise:NSStringFromClass([SBTabBarController class]) format:@"If you want to add PlusChildViewController, you must realizse `+indexOfPlusButtonInTabBar` in your custom plusButton class.【Chinese】如果你想使用PlusChildViewController样式，你必须同时在你自定义的plusButton中实现 `+indexOfPlusButtonInTabBar`，来指定plusButton的位置"];
        }
    }
}

+ (void)removePlusButton {
    SBExternPlusButton = nil;
    [SBPlusChildViewController sb_setPlusViewControllerEverAdded:NO];
    SBPlusChildViewController = nil;
}


- (void)plusChildViewControllerButtonClicked:(UIButton<SBPlusButtonSubclassing> *)sender {
    BOOL notNeedConfigureSelectionStatus = [[self class] respondsToSelector:@selector(shouldSelectPlusChildViewController)] && ![[self class] shouldSelectPlusChildViewController];
    if (notNeedConfigureSelectionStatus) {
        return;
    }
    SBTabBarController *tabBarController = [sender sb_tabBarController];
    NSInteger index = [tabBarController.viewControllers indexOfObject:SBPlusChildViewController];
    if (NSNotFound != index && (index < tabBarController.viewControllers.count)) {
        [tabBarController setSelectedIndex:index];
    }
}

#pragma mark -
#pragma mark - Private Methods

+ (void)addSelectViewControllerTarget:(UIButton<SBPlusButtonSubclassing> *)plusButton {
    id target = self;
    NSArray<NSString *> *selectorNamesArray = [plusButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
    if (selectorNamesArray.count == 0) {
        target = plusButton;
        selectorNamesArray = [plusButton actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
    }
    [selectorNamesArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SEL selector =  NSSelectorFromString(obj);
        [plusButton removeTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }];
    [plusButton addTarget:plusButton action:@selector(plusChildViewControllerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  按钮选中状态下点击先显示normal状态的颜色，松开时再回到selected状态下颜色。
 *  重写此方法即不会出现上述情况，与 UITabBarButton 相似
 */
- (void)setHighlighted:(BOOL)highlighted {}

@end
