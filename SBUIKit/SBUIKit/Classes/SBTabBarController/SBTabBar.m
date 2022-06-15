//
//  SBTabBar.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import "SBTabBar.h"

#import "SBTabBarController.h"

#import "UIColor+SBTabBarControllerExtension.h"
#import "UIView+SBTabBarControllerExtention.h"
#import "UIView+SBBadgeExtention.h"
#import "UIControl+SBTabBarControllerExtention.h"


static void *const SBTabBarContext = (void*)&SBTabBarContext;

@interface SBTabBar ()

/** 发布按钮 */
@property (nonatomic, strong) UIButton<SBPlusButtonSubclassing> *plusButton;
@property (nonatomic, assign) CGFloat tabBarItemWidth;
@property (nonatomic, copy) NSArray<UIControl *> *tabBarButtonArray;
@property (nonatomic, assign, getter=hasAddPlusButton) BOOL addPlusButton;

@end

@implementation SBTabBar
@synthesize plusButton = _plusButton;

#pragma mark -
#pragma mark - LifeCycle Method

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (void)setPlusButton:(UIButton<SBPlusButtonSubclassing> *)plusButton {
    if (!plusButton) {
        return;
    }
    _plusButton = plusButton;
    if (!self.hasAddPlusButton) {
        NSString *tabBarContext = self.plusButtonTabBarContext;
        BOOL isFirstAdded = (_plusButton.superview == nil);
        BOOL isSameContext = [tabBarContext isEqualToString:self.context] && (tabBarContext && self.context);
        if (_plusButton && isSameContext && isFirstAdded) {
            [self addSubview:(UIButton *)_plusButton];
            self.addPlusButton = YES;
            [_plusButton sb_setTabBarController:[self sb_tabBarController]];
        }
    }
}

- (void)setContext:(NSString *)context {
    _context = context;
    self.plusButton = SBExternPlusButton;
}

- (instancetype)sharedInit {
    // KVO注册监听
    _tabBarItemWidth = SBTabBarItemWidth;
    [self addObserver:self forKeyPath:@"tabBarItemWidth" options:NSKeyValueObservingOptionNew context:SBTabBarContext];
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [super sizeThatFits:size];
    CGFloat height = [self sb_tabBarController].tabBarHeight;
    if (height > 0) {
        sizeThatFits.height = height;
    }
    return sizeThatFits;
}

/**
 *  lazy load tabBarButtonArray
 *
 *  @return NSArray
 */
- (NSArray *)tabBarButtonArray {
    if (_tabBarButtonArray == nil) {
        _tabBarButtonArray = @[];
    }
    return _tabBarButtonArray;
}

- (NSString *)plusButtonTabBarContext {
    NSString *tabBarContext;
    if ([[_plusButton class] respondsToSelector:@selector(tabBarContext)]) {
        tabBarContext = [[_plusButton class] tabBarContext];
    }
    if (tabBarContext && tabBarContext.length > 0) {
        return tabBarContext;
    }
    tabBarContext = NSStringFromClass([SBTabBarController class]);
    return tabBarContext;
}

- (UIButton<SBPlusButtonSubclassing> *)plusButton {
    if (!SBExternPlusButton || !_plusButton) {
        return nil;
    }
    NSString *plusButtonTabBarContext = self.plusButtonTabBarContext;
    BOOL addedToTabBar = [_plusButton.superview isEqual:self];
    BOOL isSameContext = [plusButtonTabBarContext isEqualToString:self.context] && (plusButtonTabBarContext && self.context);//|| (!tabBarContext  && !self.context);
    if (_plusButton  &&  addedToTabBar && isSameContext) {
        return _plusButton;
    }
    return nil;
}

- (void)presetUnselectedItemTintColor {
    if (@available(iOS 13.0, *)) {
        if (self.unselectedItemTintColor) {
            return;
        }
        __block UIColor *tabLabelTextColor = nil;//for iOS13+
        tabLabelTextColor = [UIColor sb_systemGrayColor];
        [self.tabBarButtonArray enumerateObjectsUsingBlock:^(UIControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIControl *childView = obj;
            if (childView.selected) {
                return;
            }
            if (childView.sb_tabEffectView && childView.sb_tabLabel ) {
                tabLabelTextColor = childView.sb_tabLabel.textColor;
            }
        }];
        self.unselectedItemTintColor = tabLabelTextColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tabBarButtonArray = [self sb_originalTabBarButtons];
    if (self.tabBarButtonArray.count == 0) {
        return;
    }
    [self presetUnselectedItemTintColor];
    [self setupTabImageViewDefaultOffset:self.tabBarButtonArray[0]];
    CGFloat tabBarWidth = self.bounds.size.width;
    CGFloat tabBarHeight = self.bounds.size.height;
    
    if (!self.addPlusButton) {
        return;
    }
    
    BOOL addedToTabBar = [_plusButton.superview isEqual:self];
    if (!addedToTabBar) {
        SBTabBarItemWidth = (tabBarWidth) / SBTabbarItemsCount;
        [self.tabBarButtonArray enumerateObjectsUsingBlock:^(UIControl * _Nonnull childView, NSUInteger buttonIndex, BOOL * _Nonnull stop) {
            //仅修改childView的x和宽度,yh值不变
            CGFloat childViewX = buttonIndex * SBTabBarItemWidth;
            [self changeXForChildView:childView
                           childViewX:childViewX
                      tabBarItemWidth:SBTabBarItemWidth
                                index:buttonIndex
             ];
        }];
        return;
    }
    SBTabBarItemWidth = (tabBarWidth - SBPlusButtonWidth) / SBTabbarItemsCount;
    CGFloat multiplierOfTabBarHeight = [self multiplierOfTabBarHeight:tabBarHeight];
    CGFloat constantOfPlusButtonCenterYOffset = [self constantOfPlusButtonCenterYOffsetForTabBarHeight:tabBarHeight];
    _plusButton.center = CGPointMake(tabBarWidth * 0.5, tabBarHeight * multiplierOfTabBarHeight + constantOfPlusButtonCenterYOffset);
    NSUInteger plusButtonIndex = [self plusButtonIndex];
    [self.tabBarButtonArray enumerateObjectsUsingBlock:^(UIControl * _Nonnull childView, NSUInteger buttonIndex, BOOL * _Nonnull stop) {
        //调整UITabBarItem的位置
        CGFloat childViewX;
        CGFloat visiableTabIndex = buttonIndex;
        CGFloat tabBarItemWidth = SBTabBarItemWidth;

        if ([self sb_hasPlusChildViewController]) {
            if (buttonIndex <= plusButtonIndex) {
                childViewX = buttonIndex * SBTabBarItemWidth;
            } else {
                childViewX = (buttonIndex - 1) * SBTabBarItemWidth + SBPlusButtonWidth;
            }
            if (buttonIndex == plusButtonIndex) {
                tabBarItemWidth = SBPlusButtonWidth;
            }
        } else {
            if (buttonIndex >= plusButtonIndex) {
                childViewX = buttonIndex * SBTabBarItemWidth + SBPlusButtonWidth;
                visiableTabIndex = buttonIndex  + 1;
            } else {
                childViewX = buttonIndex * SBTabBarItemWidth;
            }
        }
       
        [childView sb_setTabBarChildViewControllerIndex:buttonIndex];
        [self changeXForChildView:childView
                       childViewX:childViewX
                  tabBarItemWidth:tabBarItemWidth
                            index:visiableTabIndex
         ];
        //仅修改childView的x和宽度,yh值不变
    }];
    //bring the plus button to top
    [self bringSubviewToFront:_plusButton];
}

- (void)changeXForChildView:(UIControl *)childView
                 childViewX:(CGFloat)childViewX
            tabBarItemWidth:(CGFloat)tabBarItemWidth
                      index:(NSUInteger)index {
    //仅修改childView的x和宽度,yh值不变
    childView.frame = CGRectMake(childViewX,
                                 CGRectGetMinY(childView.frame),
                                 tabBarItemWidth,
                                 CGRectGetHeight(childView.frame)
                                 );
    [childView sb_setTabBarItemVisibleIndex:index];
}

#pragma mark -
#pragma mark - Private Methods

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    return NO;
}

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != SBTabBarContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == SBTabBarContext) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SBTabBarItemWidthDidChangeNotification object:self];
        if (SB_TAB_BAR_IS_IPHONE_X) {
            [self layoutIfNeeded];
        }
    }
}

- (void)dealloc {
    // KVO反注册
    [self removeObserver:self forKeyPath:@"tabBarItemWidth"];
}

- (void)setTabBarItemWidth:(CGFloat )tabBarItemWidth {
    if (_tabBarItemWidth != tabBarItemWidth) {
        [self willChangeValueForKey:@"tabBarItemWidth"];
        _tabBarItemWidth = tabBarItemWidth;
        [self didChangeValueForKey:@"tabBarItemWidth"];
    }
}

- (void)setTabImageViewDefaultOffset:(CGFloat)tabImageViewDefaultOffset {
    if (tabImageViewDefaultOffset != 0.f) {
        [self willChangeValueForKey:@"tabImageViewDefaultOffset"];
        _tabImageViewDefaultOffset = tabImageViewDefaultOffset;
        [self didChangeValueForKey:@"tabImageViewDefaultOffset"];
    }
}

- (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
    CGFloat multiplierOfTabBarHeight;
    if ([[self.plusButton class] respondsToSelector:@selector(multiplierOfTabBarHeight:)]) {
        multiplierOfTabBarHeight = [[self.plusButton class] multiplierOfTabBarHeight:tabBarHeight];
    } else {
        CGSize sizeOfPlusButton = self.plusButton.frame.size;
        CGFloat heightDifference = sizeOfPlusButton.height - self.bounds.size.height;
        if (heightDifference < 0) {
            multiplierOfTabBarHeight = 0.5;
        } else {
            CGPoint center = CGPointMake(self.bounds.size.height * 0.5, self.bounds.size.height * 0.5);
            center.y = center.y - heightDifference * 0.5;
            multiplierOfTabBarHeight = center.y / self.bounds.size.height;
        }
    }
    return multiplierOfTabBarHeight;
}

- (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
    CGFloat constantOfPlusButtonCenterYOffset = 0.f;
    if ([[self.plusButton class] respondsToSelector:@selector(constantOfPlusButtonCenterYOffsetForTabBarHeight:)]) {
        constantOfPlusButtonCenterYOffset = [[self.plusButton class] constantOfPlusButtonCenterYOffsetForTabBarHeight:tabBarHeight];
    }
    return constantOfPlusButtonCenterYOffset;
}

- (NSUInteger)plusButtonIndex {
    NSUInteger plusButtonIndex;
    if ([[self.plusButton class] respondsToSelector:@selector(indexOfPlusButtonInTabBar)]) {
        plusButtonIndex = [[self.plusButton class] indexOfPlusButtonInTabBar];
    } else {
        if (SBTabbarItemsCount % 2 != 0) {
            [NSException raise:NSStringFromClass([SBTabBarController class]) format:@"If the count of SBTabbarControllers is odd,you must realizse `+indexOfPlusButtonInTabBar` in your custom plusButton class.【Chinese】如果SBTabbarControllers的个数是奇数，你必须在你自定义的plusButton中实现`+indexOfPlusButtonInTabBar`，来指定plusButton的位置"];
        }
        plusButtonIndex = SBTabbarItemsCount * 0.5;
    }
    CGFloat childViewX = plusButtonIndex * SBTabBarItemWidth;
    CGFloat tabBarItemWidth = CGRectGetWidth(self.plusButton.frame);
    [self changeXForChildView:self.plusButton
                   childViewX:childViewX
              tabBarItemWidth:tabBarItemWidth
                        index:plusButtonIndex
     ];
    SBPlusButtonIndex = plusButtonIndex;
    return plusButtonIndex;
}

- (void)setupTabImageViewDefaultOffset:(UIView *)tabBarButton {
    if (self.tabImageViewDefaultOffset > 0) {
        return;
    }
    __block BOOL shouldCustomizeImageView = YES;
    __block CGFloat tabImageViewDefaultOffset = 0.f;
    CGFloat tabButtonCenterY = tabBarButton.center.y;
    [tabBarButton.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj sb_isTabLabel]) {
            shouldCustomizeImageView = NO;
        }
        CGFloat tabImageViewCenterY = obj.center.y;
        
        BOOL isTabImageView = [obj sb_isTabImageView];
        if (isTabImageView) {
            tabImageViewDefaultOffset = (tabButtonCenterY - tabImageViewCenterY) * 0.5;
        }
        if (isTabImageView && tabImageViewDefaultOffset == 0.f) {
            shouldCustomizeImageView = NO;
        }
    }];
    if (shouldCustomizeImageView) {
        self.tabImageViewDefaultOffset = tabImageViewDefaultOffset;
    }
}

/*!
 *  Capturing touches on a subview outside the frame of its superview.
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //1. 边界情况：不能响应点击事件
    
    BOOL canNotResponseEvent = self.sb_canNotResponseEvent;
    if (canNotResponseEvent) {
        return nil;
    }
    
    //2. 优先处理 PlusButton （包括其突出的部分）、TabBarItems 未凸出的部分
    //这一步主要是在处理只有两个 TabBarItems 的场景。
    // 2.1先考虑clipsToBounds情况：子view超出部分没有显示出来
    if (self.clipsToBounds && ![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    if (self.plusButton) {
        CGRect plusButtonFrame = self.plusButton.frame;
        BOOL isInPlusButtonFrame = CGRectContainsPoint(plusButtonFrame, point);
        if (isInPlusButtonFrame) {
            return self.plusButton;
        }
    }
    NSArray *tabBarButtons = self.tabBarButtonArray;
    if (self.tabBarButtonArray.count == 0) {
        tabBarButtons = [self sb_visibleControls];
    }
    for (NSUInteger index = 0; index < tabBarButtons.count; index++) {
        UIView *selectedTabBarButton = tabBarButtons[index];
        CGRect selectedTabBarButtonFrame = selectedTabBarButton.frame;
        BOOL isTabBarButtonFrame = CGRectContainsPoint(selectedTabBarButtonFrame, point);
        if (isTabBarButtonFrame && !selectedTabBarButton.hidden) {
            return selectedTabBarButton;
        }
    }
    
    //3. 最后处理 TabBarItems 凸出的部分、添加到 TabBar 上的自定义视图、点击到 TabBar 上的空白区域
    UIView *result = [super hitTest:point withEvent:event];
    if (result) {
        return result;
    }
    
    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        result = [subview hitTest:subPoint withEvent:event];
        if (result) {
            return result;
        }
    }
    return nil;
}

@end
