//
//  UIControl+SBTabBarControllerExtention.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import "UIControl+SBTabBarControllerExtention.h"

#import <objc/runtime.h>

#import "UIView+SBTabBarControllerExtention.h"

#import "SBTabBarConstants.h"

#import "SBTabBarController.h"
#if __has_include(<Lottie/Lottie.h>)
#import <Lottie/Lottie.h>
#else
#endif

@implementation UIControl (SBTabBarControllerExtention)

- (BOOL)sb_isChildViewControllerPlusButton {
    BOOL isChildViewControllerPlusButton = ([self sb_isPlusButton] && SBPlusChildViewController.sb_plusViewControllerEverAdded);
    return isChildViewControllerPlusButton;
}

- (BOOL)sb_shouldNotSelect {
    NSNumber *shouldNotSelectObject = objc_getAssociatedObject(self, @selector(sb_shouldNotSelect));
    return [shouldNotSelectObject boolValue];
}

- (void)sb_setShouldNotSelect:(BOOL)shouldNotSelect {
    NSNumber *shouldNotSelectObject = @(shouldNotSelect);
    objc_setAssociatedObject(self, @selector(sb_shouldNotSelect), shouldNotSelectObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)sb_tabBarItemVisibleIndex {
    if (!self.sb_isTabButton && !self.sb_isPlusButton ) {
        return NSNotFound;
    }
    NSNumber *tabBarItemVisibleIndexObject = objc_getAssociatedObject(self, @selector(sb_tabBarItemVisibleIndex));
    return [tabBarItemVisibleIndexObject integerValue];
}

- (void)sb_setTabBarItemVisibleIndex:(NSInteger)tabBarItemVisibleIndex {
    NSNumber *tabBarItemVisibleIndexObject = [NSNumber numberWithInteger:tabBarItemVisibleIndex];
    objc_setAssociatedObject(self, @selector(sb_tabBarItemVisibleIndex), tabBarItemVisibleIndexObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)sb_tabBarChildViewControllerIndex {
    if (!self.sb_isTabButton && !self.sb_isPlusButton ) {
        return NSNotFound;
    }
    NSNumber *tabBarChildViewControllerIndexObject = objc_getAssociatedObject(self, @selector(sb_tabBarChildViewControllerIndex));
    return [tabBarChildViewControllerIndexObject integerValue];
}

- (void)sb_setTabBarChildViewControllerIndex:(NSInteger)tabBarChildViewControllerIndex {
    NSNumber *tabBarChildViewControllerIndexObject = [NSNumber numberWithInteger:tabBarChildViewControllerIndex];
    objc_setAssociatedObject(self, @selector(sb_tabBarChildViewControllerIndex), tabBarChildViewControllerIndexObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sb_showTabBadgePoint {
    [self sb_setShowTabBadgePointIfNeeded:YES];
}

- (void)sb_removeTabBadgePoint {
    [self sb_setShowTabBadgePointIfNeeded:NO];
}

- (BOOL)sb_isShowTabBadgePoint {
    return !self.sb_tabBadgePointView.hidden;
}

- (BOOL)sb_isSelected {
    BOOL isSelected = NO;
    NSUInteger tabBarSelectedIndex = self.sb_tabBarController.selectedIndex;
    NSUInteger tabBarChildViewControllerIndex = self.sb_tabBarChildViewControllerIndex;
    BOOL defaultSelected = self.selected;
    if ((tabBarSelectedIndex == tabBarChildViewControllerIndex) && defaultSelected) {
        isSelected = YES;
    }
    return isSelected;
}

- (void)sb_setShowTabBadgePointIfNeeded:(BOOL)showTabBadgePoint {
    @try {
        [self sb_setShowTabBadgePoint:showTabBadgePoint];
    } @catch (NSException *exception) {
        NSLog(@"SBPlusChildViewController do not support set TabBarItem red point");
    }
}

- (void)sb_setShowTabBadgePoint:(BOOL)showTabBadgePoint {
    if (showTabBadgePoint && self.sb_tabBadgePointView.superview == nil) {
        [self addSubview:self.sb_tabBadgePointView];
        [self bringSubviewToFront:self.sb_tabBadgePointView];
        self.sb_tabBadgePointView.layer.zPosition = MAXFLOAT;
        // X constraint
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:self.sb_tabBadgePointView
                                      attribute:NSLayoutAttributeCenterX
                                      relatedBy:0
                                         toItem:self.sb_tabImageView
                                      attribute:NSLayoutAttributeRight
                                     multiplier:1
                                       constant:self.sb_tabBadgePointViewOffset.horizontal]];
        //Y constraint
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:self.sb_tabBadgePointView
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:0
                                         toItem:self.sb_tabImageView
                                      attribute:NSLayoutAttributeTop
                                     multiplier:1
                                       constant:self.sb_tabBadgePointViewOffset.vertical]];
    }
    self.sb_tabBadgePointView.hidden = showTabBadgePoint == NO;
    self.sb_tabBadgeView.hidden = showTabBadgePoint == YES;
}

- (void)sb_setTabBadgePointView:(UIView *)tabBadgePointView {
    UIView *tempView = objc_getAssociatedObject(self, @selector(sb_tabBadgePointView));
    if (tempView) {
        [tempView removeFromSuperview];
    }
    if (tabBadgePointView.superview) {
        [tabBadgePointView removeFromSuperview];
    }
    
    tabBadgePointView.hidden = YES;
    objc_setAssociatedObject(self, @selector(sb_tabBadgePointView), tabBadgePointView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)sb_tabBadgePointView {
    UIView *tabBadgePointView = objc_getAssociatedObject(self, @selector(sb_tabBadgePointView));
    
    if (tabBadgePointView == nil) {
        tabBadgePointView = self.sb_defaultTabBadgePointView;
        objc_setAssociatedObject(self, @selector(sb_tabBadgePointView), tabBadgePointView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tabBadgePointView;
}

- (void)sb_setTabBadgePointViewOffset:(UIOffset)tabBadgePointViewOffset {
    objc_setAssociatedObject(self, @selector(sb_tabBadgePointViewOffset), [NSValue valueWithUIOffset:tabBadgePointViewOffset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//offset如果都是正数，则往右下偏移
- (UIOffset)sb_tabBadgePointViewOffset {
    id tabBadgePointViewOffsetObject = objc_getAssociatedObject(self, @selector(sb_tabBadgePointViewOffset));
    UIOffset tabBadgePointViewOffset = [tabBadgePointViewOffsetObject UIOffsetValue];
    return tabBadgePointViewOffset;
}

- (LOTAnimationView *)sb_lottieAnimationView {
    for (UILabel *subview in self.subviews) {
        if ([subview sb_isLottieAnimationView]) {
            return (LOTAnimationView *)subview;
        }
    }
    return nil;
}

- (void)sb_replaceTabImageViewWithNewView:(UIView *)newView
                             show:(BOOL)show {
    [self sb_replaceTabImageViewWithNewView:newView offset:UIOffsetZero show:show completion:^(BOOL isReplaced, UIControl *tabBarButton, UIView *newView) {
    }];
}

- (void)sb_replaceTabImageViewWithNewView:(UIView *)newView
                                           offset:(UIOffset)offset
                                    show:(BOOL)theShow
                                        completion:(void(^)(BOOL isReplaced, UIControl *tabBarButton, UIView *newView))completion {
    [self sb_replaceTabImageViewOrTabButton:NO newView:newView offset:offset show:theShow completion:completion];
}

- (void)sb_replaceTabButtonWithNewView:(UIView *)newView
                                    offset:(UIOffset)offset
                                      show:(BOOL)theShow
                                completion:(void(^)(BOOL isReplaced, UIControl *tabBarButton, UIView *newView))completion {
    [self sb_replaceTabImageViewOrTabButton:YES newView:newView offset:offset show:theShow completion:completion];
}

- (void)sb_replaceTabButtonWithNewView:(UIView *)newView
                                      show:(BOOL)show {
    [self sb_replaceTabButtonWithNewView:newView offset:UIOffsetZero show:show completion:^(BOOL isReplaced, UIControl *tabBarButton, UIView *newView) {
    }];
}

- (void)sb_replaceTabImageViewOrTabButton:(BOOL)isTabButton
                               newView:(UIView *)newView
                                    offset:(UIOffset)offset
                                      show:(BOOL)theShow
                                completion:(void(^)(BOOL isReplaced, UIControl *tabBarButton, UIView *newView))completion {
    UIControl *tabBarButton = self;
    UIImageView *swappableImageView = tabBarButton.sb_tabImageView;
    UIView *replacedView = swappableImageView;
    if (isTabButton) {
        replacedView = tabBarButton;
    }
    if (!replacedView) {
        return;
    }
    if (newView.frame.size.width == 0 || newView.frame.size.height == 0 || newView.frame.size.width > tabBarButton.frame.size.width || newView.frame.size.height > tabBarButton.frame.size.height) {
        UIImage *image = swappableImageView.image;
        newView.frame = ({
            CGRect frame = newView.frame;
            frame.size = CGSizeMake(image.size.width, image.size.height);
            frame;
        });
    }
    BOOL newViewCreated = (newView.superview != nil);
    BOOL newViewAddedToTabButton = [self.subviews containsObject:newView];
    BOOL isNewViewAddedToTabButton = newViewCreated && newViewAddedToTabButton;
    if (newView.superview && !newViewAddedToTabButton) {
        [newView removeFromSuperview];
    }
    if (isNewViewAddedToTabButton && theShow) {
        !completion?:completion(YES, self, newView);
        return;
    }
    BOOL show = (newView && theShow);
    swappableImageView.hidden = (show);
    if (isTabButton) {
        tabBarButton.sb_tabLabel.hidden = show;
    }
    BOOL shouldShowNewView = show && !newView.superview;
    BOOL shouldRemoveNewView = (newView.superview != nil);
    if (shouldShowNewView) {
        [tabBarButton addSubview:newView];
        [tabBarButton bringSubviewToFront:newView];
        CGSize newViewSize = newView.frame.size;
        if (@available(iOS 9.0, *)) {
            [NSLayoutConstraint activateConstraints:@[
                                                      [newView.centerXAnchor constraintEqualToAnchor:swappableImageView.centerXAnchor constant:offset.horizontal],
                                                      [newView.centerYAnchor constraintEqualToAnchor:replacedView.centerYAnchor constant:offset.vertical],
                                                      [newView.widthAnchor constraintEqualToConstant:newViewSize.width],
                                                      [newView.heightAnchor constraintEqualToConstant:newViewSize.height],
                                                      ]
             ];
        } else {
            [self addConstraints:@[
                                   [NSLayoutConstraint constraintWithItem:newView
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:swappableImageView
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:offset.horizontal],
                                   [NSLayoutConstraint constraintWithItem:newView
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:replacedView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:offset.vertical],
                                   [NSLayoutConstraint constraintWithItem:newView
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:replacedView
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:offset.vertical],
                                   [NSLayoutConstraint constraintWithItem:newView
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:newViewSize.width],
                                   [NSLayoutConstraint constraintWithItem:newView
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0
                                                                 constant:newViewSize.height]
                                   ]];
        }
        !completion?:completion(YES, self, newView);
        return;
    }
    if (shouldRemoveNewView) {
        [newView removeFromSuperview];
        newView = nil;
        !completion?:completion(NO, self, nil);
        return;
    }
}

- (void)sb_addLottieImageWithLottieURL:(NSURL *)lottieURL
                                   size:(CGSize)size {
#if __has_include(<Lottie/Lottie.h>)
    if (self.sb_lottieAnimationView) {
        return;
    }
    UIControl *tabButton = self;
    LOTAnimationView *lottieView = [[LOTAnimationView alloc] initWithContentsOfURL:lottieURL];
    lottieView.frame = CGRectMake(0, 0, size.width, size.height);
    lottieView.userInteractionEnabled = NO;
    lottieView.contentMode = UIViewContentModeScaleAspectFill;
    lottieView.translatesAutoresizingMaskIntoConstraints = NO;
    [lottieView setClipsToBounds:NO];
    [tabButton sb_replaceTabImageViewWithNewView:lottieView show:YES];
#else
#endif

}

#pragma mark - private method

- (UIView *)sb_defaultTabBadgePointView {
    UIView *defaultRedTabBadgePointView = [UIView sb_tabBadgePointViewWithClolor:[UIColor redColor] radius:4.5];
    return defaultRedTabBadgePointView;
}

@end
