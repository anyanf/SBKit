//
//  UIView+SBTabBarControllerExtention.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import "UIView+SBTabBarControllerExtention.h"

#import "SBPlusButton.h"

#if __has_include(<Lottie/Lottie.h>)
#import <Lottie/Lottie.h>
#else
#endif


@implementation UIView (SBTabBarControllerExtention)


- (BOOL)sb_isPlusButton {
    return [self isKindOfClass:[SBExternPlusButton class]];
}

- (BOOL)sb_isTabButton {
    BOOL isKindOfButton = [self sb_isKindOfClass:[UIControl class]];
    return isKindOfButton;
}

- (BOOL)sb_isTabImageView {
    BOOL isKindOfImageView = [self sb_isKindOfClass:[UIImageView class]];
    if (!isKindOfImageView) {
        return NO;
    }
    NSString *subString = [NSString stringWithFormat:@"%@cat%@ew", @"Indi" , @"orVi"];
    BOOL isBackgroundImage = [self sb_classStringHasSuffix:subString];
    BOOL isTabImageView = !isBackgroundImage;
    return isTabImageView;
}

- (BOOL)sb_isTabLabel {
    BOOL isKindOfLabel = [self sb_isKindOfClass:[UILabel class]];
    return isKindOfLabel;
}

- (BOOL)sb_isTabBadgeView {
    BOOL isKindOfClass = [self isKindOfClass:[UIView class]];
    BOOL isClass = [self isMemberOfClass:[UIView class]];
    BOOL isKind = isKindOfClass && !isClass;
    if (!isKind) {
        return NO;
    }
    NSString *tabBarClassString = [NSString stringWithFormat:@"%@IB%@", @"_U" , @"adg"];
    BOOL isTabBadgeView = [self sb_classStringHasPrefix:tabBarClassString];;
    return isTabBadgeView;
}

- (BOOL)sb_isTabBackgroundView {
    BOOL isKindOfClass = [self isKindOfClass:[UIView class]];
    BOOL isClass = [self isMemberOfClass:[UIView class]];
    BOOL isKind = isKindOfClass && !isClass;
    if (!isKind) {
        return NO;
    }
    NSString *tabBackgroundViewString = [NSString stringWithFormat:@"%@IB%@", @"_U" , @"arBac"];
    BOOL isTabBackgroundView = [self sb_classStringHasPrefix:tabBackgroundViewString] && [self sb_classStringHasSuffix:@"nd"];
    return isTabBackgroundView;
}

- (UIImageView *)sb_tabImageView {
    for (UIImageView *subview in self.sb_allSubviews) {
        if ([subview sb_isTabImageView]) {
            return (UIImageView *)subview;
        }
    }
    return nil;
}

- (NSArray *)sb_allSubviews {
    __block NSArray* allSubviews = [NSArray arrayWithObject:self];
    [self.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL*stop) {
        allSubviews = [allSubviews arrayByAddingObjectsFromArray:[view sb_allSubviews]];
    }];
    return allSubviews;
}

- (UIView *)sb_tabBadgeView {
    for (UIView *subview in self.sb_allSubviews) {
        if ([subview sb_isTabBadgeView]) {
            return (UIView *)subview;
        }
    }
    return nil;
}

- (UILabel *)sb_tabLabel {
    for (UILabel *subview in self.sb_allSubviews) {
        if ([subview sb_isTabLabel]) {
            return (UILabel *)subview;
        }
    }
    return nil;
}

//UIVisualEffectView
- (BOOL)sb_isTabEffectView {
    BOOL isClass = [self isMemberOfClass:[UIVisualEffectView class]];
    return isClass;
}

//_UIVisualEffectContentView
- (BOOL)sb_isTabEffectContentView {
    BOOL isKindOfClass = [self isKindOfClass:[UIView class]];
    BOOL isClass = [self isMemberOfClass:[UIView class]];
    BOOL isKind = isKindOfClass && !isClass;
    if (!isKind) {
        return NO;
    }
    NSString *tabBackgroundViewString = [NSString stringWithFormat:@"%@IVisualE%@", @"_U" , @"ffectC"];
    BOOL isTabBackgroundView = [self sb_classStringHasPrefix:tabBackgroundViewString] && [self sb_classStringHasSuffix:@"entView"];
    return isTabBackgroundView;
}

//UIVisualEffectView
- (UIVisualEffectView *)sb_tabEffectView {
    for (UIView *subview in self.subviews) {
        if ([subview sb_isTabEffectView]) {
            return (UIVisualEffectView *)subview;
        }
    }
    return nil;
}


- (UIImageView *)sb_tabShadowImageView {
    UIView *subview = [self sb_tabBackgroundView];
    if (!subview) {
        return nil;
    }
    NSArray<__kindof UIView *> *backgroundSubviews = subview.subviews;
    if (backgroundSubviews.count > 1) {
        for (UIView *subview in backgroundSubviews) {
            if (CGRectGetHeight(subview.bounds) <= 1.0 ) {
                return (UIImageView *)subview;
            }
        }
    }
    return nil;
}

- (UIView *)sb_tabBackgroundView {
    for (UIImageView *subview in self.subviews) {
        if ([subview sb_isTabBackgroundView]) {
            return (UIImageView *)subview;
        }
    }
    return nil;
}

- (BOOL)sb_isLottieAnimationView {
    BOOL isKindOfClass = [self isKindOfClass:[UIView class]];
    BOOL isClass = [self isMemberOfClass:[UIView class]];
    BOOL isKind = isKindOfClass && !isClass;
    if (!isKind) {
        return NO;
    }
    Class classType = NSClassFromString(@"LOTAnimationView");
    BOOL isLottieAnimationView = ([self isKindOfClass:classType] || [self isMemberOfClass:classType]);
    return isLottieAnimationView;
}

- (BOOL)sb_isKindOfClass:(Class)class {
    BOOL isKindOfClass = [self isKindOfClass:class];
    BOOL isClass = [self isMemberOfClass:class];
    BOOL isKind = isKindOfClass && !isClass;
    if (!isKind) {
        return NO;
    }
    BOOL isTabBarClass = [self sb_isTabBarClass];
    return isTabBarClass;
}

- (BOOL)sb_isTabBarClass {
    NSString *tabBarClassString = [NSString stringWithFormat:@"U%@a%@ar", @"IT" , @"bB"];
    BOOL isTabBarClass = [self sb_classStringHasPrefix:tabBarClassString];
    return isTabBarClass;
}

- (BOOL)sb_classStringHasPrefix:(NSString *)prefix {
    NSString *classString = NSStringFromClass([self class]);
    return [classString hasPrefix:prefix];
}

- (BOOL)sb_classStringHasSuffix:(NSString *)suffix {
    NSString *classString = NSStringFromClass([self class]);
    return [classString hasSuffix:suffix];
}

+ (UIView *)sb_tabBadgePointViewWithClolor:(UIColor *)color radius:(CGFloat)radius {
    UIView *defaultTabBadgePointView = [[UIView alloc] init];
    [defaultTabBadgePointView setTranslatesAutoresizingMaskIntoConstraints:NO];
    defaultTabBadgePointView.backgroundColor = color;
    defaultTabBadgePointView.layer.cornerRadius = radius;
    defaultTabBadgePointView.layer.masksToBounds = YES;
    defaultTabBadgePointView.hidden = YES;
    // Width constraint
    [defaultTabBadgePointView addConstraint:[NSLayoutConstraint constraintWithItem:defaultTabBadgePointView
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute: NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1
                                                                          constant:radius * 2]];
    // Height constraint
    [defaultTabBadgePointView addConstraint:[NSLayoutConstraint constraintWithItem:defaultTabBadgePointView
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute: NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1
                                                                          constant:radius * 2]];
    return defaultTabBadgePointView;
}


@end
