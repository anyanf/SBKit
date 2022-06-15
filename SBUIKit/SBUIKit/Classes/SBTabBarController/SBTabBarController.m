//
//  SBTabBarController.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/26.
//

#import "SBTabBarController.h"

#import <objc/runtime.h>

#import "UIImage+SBExtension.h"
#import "UIView+SBTabBarControllerExtention.h"
#import "UIView+SBBadgeExtention.h"
#import "UIControl+SBTabBarControllerExtention.h"


NSString *const SBTabBarItemTitle = @"SBTabBarItemTitle";
NSString *const SBTabBarItemImage = @"SBTabBarItemImage";
NSString *const SBTabBarItemSelectedImage = @"SBTabBarItemSelectedImage";
NSString *const SBTabBarItemImageInsets = @"SBTabBarItemImageInsets";
NSString *const SBTabBarItemTitlePositionAdjustment = @"SBTabBarItemTitlePositionAdjustment";
NSString *const SBTabBarLottieURL = @"SBTabBarLottieURL";
NSString *const SBTabBarLottieSize = @"SBTabBarLottieSize";

NSUInteger SBTabbarItemsCount = 0;
NSUInteger SBPlusButtonIndex = 0;
CGFloat SBTabBarItemWidth = 0.0f;
CGFloat SBTabBarHeight = 0.0f;

NSString *const SBTabBarItemWidthDidChangeNotification = @"SBTabBarItemWidthDidChangeNotification";
static void * const SBTabImageViewDefaultOffsetContext = (void*)&SBTabImageViewDefaultOffsetContext;

@interface SBTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, assign, getter=isObservingTabImageViewDefaultOffset) BOOL observingTabImageViewDefaultOffset;
@property (nonatomic, assign, getter=shouldInvokeOnceViewDidLayoutSubViewsBlock) BOOL invokeOnceViewDidLayoutSubViewsBlock;
@property (nonatomic, strong) NSMutableArray<NSURL *> *lottieURLs;
@property (nonatomic, strong) NSMutableArray *lottieSizes;
@property (nonatomic, assign, getter=isLottieViewAdded) BOOL lottieViewAdded;

@end

@implementation SBTabBarController

@synthesize viewControllers = _viewControllers;

@dynamic tabBar;

#pragma mark -
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SB_TAB_BAR_IS_IPHONE_X) {
        self.tabBarHeight = 83;
    }
    // 处理tabBar，使用自定义 tabBar 添加 发布按钮
    [self setUpTabBar];
    // KVO注册监听
    if (!self.isObservingTabImageViewDefaultOffset) {
        [self.tabBar addObserver:self forKeyPath:@"tabImageViewDefaultOffset" options:NSKeyValueObservingOptionNew context:SBTabImageViewDefaultOffsetContext];
        self.observingTabImageViewDefaultOffset = YES;
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    [self updateSelectionStatusIfNeededForTabBarController:nil shouldSelectViewController:nil];
    UIControl *selectedControl = [self.tabBar sb_tabBarButtonWithTabIndex:selectedIndex];
    if (selectedControl) {
        [self didSelectControl:selectedControl];
    }
}

- (void)setViewDidLayoutSubViewsBlockInvokeOnce:(BOOL)invokeOnce block:(SBViewDidLayoutSubViewsBlock)viewDidLayoutSubviewsBlock  {
    self.viewDidLayoutSubviewsBlock = viewDidLayoutSubviewsBlock;
    self.invokeOnceViewDidLayoutSubViewsBlock = YES;
}

- (void)setViewDidLayoutSubViewsBlock:(SBViewDidLayoutSubViewsBlock)viewDidLayoutSubviewsBlock {
    _viewDidLayoutSubviewsBlock = viewDidLayoutSubviewsBlock;
}

- (void)viewDidLayoutSubviews {
    [self.tabBar layoutSubviews];//Fix issue #93 #392
    SBTabBar *tabBar =  (SBTabBar *)self.tabBar;
    // add callback for visiable control, included all plusButton.
    [tabBar.sb_visibleControls enumerateObjectsUsingBlock:^(UIControl * _Nonnull control, NSUInteger idx, BOOL * _Nonnull stop) {
        //to avoid invoking didSelectControl twice, because plusChildViewControllerButtonClicked will invoke setSelectedIndex
        if ([control sb_isChildViewControllerPlusButton]) {
            return;
        }
        SEL actin = @selector(didSelectControl:);
        [control addTarget:self action:actin forControlEvents:UIControlEventTouchUpInside];
        if (idx == self.selectedIndex) {
            control.selected = YES;
        }
    }];

    do {
        if (self.isLottieViewAdded) {
            break;
        }
        //FIXME:
        NSArray *subTabBarButtonsWithoutPlusButton = tabBar.sb_subTabBarButtonsWithoutPlusButton;
        BOOL isLottieEnabled = [self isLottieEnabled];
        if(!isLottieEnabled || (subTabBarButtonsWithoutPlusButton.count != self.lottieURLs.count)) {
            self.lottieViewAdded = YES;
            break;
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [subTabBarButtonsWithoutPlusButton enumerateObjectsUsingBlock:^(UIControl * _Nonnull control, NSUInteger idx, BOOL * _Nonnull stop) {
                UIControl *tabButton = control;
                BOOL defaultSelected = NO;
                if (idx == self.selectedIndex) {
                    defaultSelected = YES;
                }
                [self addLottieImageWithControl:tabButton animation:defaultSelected defaultSelected:defaultSelected];
            }];
            self.lottieViewAdded = YES;
        });
        break;
    } while (NO);
    
    
    if (self.shouldInvokeOnceViewDidLayoutSubViewsBlock) {
        //在对象生命周期内，不添加 flag 属性的情况下，防止多次调进这个方法
        if (objc_getAssociatedObject(self, _cmd)) {
            return;
        } else {
            !self.viewDidLayoutSubviewsBlock ?: self.viewDidLayoutSubviewsBlock(self);
            objc_setAssociatedObject(self, _cmd, @"shouldInvokeOnceViewDidLayoutSubViewsBlock", OBJC_ASSOCIATION_RETAIN);
        }
        return;
    }
    !self.viewDidLayoutSubviewsBlock ?: self.viewDidLayoutSubviewsBlock(self);
}

- (void)viewWillLayoutSubviews {
    if (!(self.tabBarHeight > 0)) {
        return;
    }
    self.tabBar.frame = ({
        CGRect frame = self.tabBar.frame;
        CGFloat tabBarHeight = self.tabBarHeight;
        frame.size.height = tabBarHeight;
        frame.origin.y = self.view.frame.size.height - tabBarHeight;
        frame;
    });
}

- (void)setTabBarHeight:(CGFloat)tabBarHeight {
    _tabBarHeight = tabBarHeight;
    SBTabBarHeight = tabBarHeight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *controller = self.selectedViewController;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)controller;
        return navigationController.topViewController.supportedInterfaceOrientations;
    } else {
        return controller.supportedInterfaceOrientations;
    }
}

- (void)dealloc {
    UIButton<SBPlusButtonSubclassing> *plusButton = SBExternPlusButton;
    if (plusButton.superview && (plusButton.superview == self.tabBar)) {
        plusButton.selected = NO;
        [plusButton removeFromSuperview];
    }
    BOOL isAdded = [self isPlusViewControllerAdded:_viewControllers];
    BOOL hasPlusChildViewController = [self hasPlusChildViewController] && isAdded;
    if (isAdded && hasPlusChildViewController && SBPlusChildViewController.sb_plusViewControllerEverAdded == YES) {
        [SBPlusChildViewController sb_setPlusViewControllerEverAdded:NO];
    }
    // KVO反注册
    if (self.isObservingTabImageViewDefaultOffset) {
        [self.tabBar removeObserver:self forKeyPath:@"tabImageViewDefaultOffset"];
    }
}

#pragma mark -
#pragma mark - public Methods




- (instancetype)initWithViewControllers:(nullable NSArray<UIViewController *> * )viewControllers
                  tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes
                            imageInsets:(UIEdgeInsets)imageInsets
                titlePositionAdjustment:(UIOffset)titlePositionAdjustment
                                context:(NSString *)context {
    if (self = [super init]) {
        
        _imageInsets = imageInsets;
        _titlePositionAdjustment = titlePositionAdjustment;
        _tabBarItemsAttributes = tabBarItemsAttributes;
        self.context = context;
        self.viewControllers = viewControllers;
    }
    return self;
}

- (void)setContext:(NSString *)context {
    if (context && context.length > 0) {
        _context = [context copy];
    } else {
        _context = NSStringFromClass([SBTabBarController class]);
    }
    [self.tabBar setValue:_context forKey:@"context"];
}

+ (instancetype)tabBarControllerWithViewControllers:(NSArray<UIViewController *> *)viewControllers
                              tabBarItemsAttributes:(NSArray<NSDictionary *> *)tabBarItemsAttributes
                                        imageInsets:(UIEdgeInsets)imageInsets
                            titlePositionAdjustment:(UIOffset)titlePositionAdjustment
                                            context:(NSString *)context {
    return [[self alloc] initWithViewControllers:viewControllers
                           tabBarItemsAttributes:tabBarItemsAttributes
                                     imageInsets:imageInsets
                         titlePositionAdjustment:titlePositionAdjustment
                                         context:context];
}


- (void)hideTabBarShadowImageView {
    [self.tabBar layoutIfNeeded];
    UIImageView *imageView = self.tabBar.sb_tabShadowImageView;
    imageView.hidden = YES;//iOS13+
    imageView.alpha = 0;
}

+ (BOOL)havePlusButton {
    if (SBExternPlusButton) {
        return YES;
    }
    return NO;
}

+ (NSUInteger)allItemsInTabBarCount {
    NSUInteger allItemsInTabBar = SBTabbarItemsCount;
    if ([SBTabBarController havePlusButton]) {
        allItemsInTabBar += 1;
    }
    return allItemsInTabBar;
}

- (id<UIApplicationDelegate>)appDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (UIWindow *)rootWindow {
    UIWindow *result = nil;
    do {
        if ([self.appDelegate respondsToSelector:@selector(window)]) {
            result = [self.appDelegate window];
        }
        
        if (result) {
            break;
        }
    } while (NO);
    return result;
}

#pragma mark -
#pragma mark - Private Methods

/**
 *  利用 KVC 把系统的 tabBar 类型改为自定义类型。
 */
- (void)setUpTabBar {
    SBTabBar *tabBar = [[SBTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    [tabBar sb_setTabBarController:self];
}

- (BOOL)hasPlusChildViewController {
    NSString *context = SBPlusChildViewController.sb_context;
    BOOL isSameContext = [context isEqualToString:self.context] && (context && self.context); // || (!context && !self.context);
    BOOL hasPlusChildViewController = SBPlusChildViewController && isSameContext;//&& !isAdded;
    return hasPlusChildViewController;
}

- (BOOL)isPlusViewControllerAdded:(NSArray *)viewControllers {
    if ([_viewControllers containsObject:SBPlusChildViewController]) {
        return YES;
    }
    __block BOOL isAdded = NO;
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isEqualViewController:obj compairedViewController:SBPlusChildViewController]) {
            isAdded = YES;
            *stop = YES;
            return;
        }
    }];
    return isAdded;;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
        BOOL isAdded = [self isPlusViewControllerAdded:_viewControllers];
        BOOL hasPlusChildViewController = [self hasPlusChildViewController] && !isAdded;
        if (hasPlusChildViewController) {
            [SBPlusChildViewController willMoveToParentViewController:nil];
            [SBPlusChildViewController.view removeFromSuperview];
            [SBPlusChildViewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        if ((!_tabBarItemsAttributes) || (_tabBarItemsAttributes.count != viewControllers.count)) {
            [NSException raise:NSStringFromClass([SBTabBarController class]) format:@"The count of SBTabBarControllers is not equal to the count of tabBarItemsAttributes.【Chinese】设置_tabBarItemsAttributes属性时，请确保元素个数与控制器的个数相同，并在方法`-setViewControllers:`之前设置"];
        }
        BOOL isAdded = [self isPlusViewControllerAdded:_viewControllers];
        BOOL addedFlag = [SBPlusChildViewController sb_plusViewControllerEverAdded];
        BOOL hasPlusChildViewController = [self hasPlusChildViewController] && !isAdded && !addedFlag;
        if (hasPlusChildViewController) {
            NSMutableArray *viewControllersWithPlusButton = [NSMutableArray arrayWithArray:viewControllers];
            [viewControllersWithPlusButton insertObject:SBPlusChildViewController atIndex:SBPlusButtonIndex];
            _viewControllers = [viewControllersWithPlusButton copy];
            [SBPlusChildViewController sb_setPlusViewControllerEverAdded:YES];
            [SBExternPlusButton sb_setTabBarChildViewControllerIndex:SBPlusButtonIndex];
        } else {
            _viewControllers = [viewControllers copy];
            [SBExternPlusButton sb_setTabBarChildViewControllerIndex:NSNotFound];
        }
        SBTabbarItemsCount = [viewControllers count];
        SBTabBarItemWidth = ([UIScreen mainScreen].bounds.size.width - SBPlusButtonWidth) / (SBTabbarItemsCount);
        NSUInteger idx = 0;
        for (UIViewController *viewController in _viewControllers) {
            NSString *title = nil;
            id normalImageInfo = nil;
            id selectedImageInfo = nil;
            UIOffset titlePositionAdjustment = UIOffsetZero;
            UIEdgeInsets imageInsets = UIEdgeInsetsZero;
            NSURL *lottieURL = nil;
            NSValue *lottieSizeValue = nil;
            if (viewController != SBPlusChildViewController) {
                title = _tabBarItemsAttributes[idx][SBTabBarItemTitle];
                normalImageInfo = _tabBarItemsAttributes[idx][SBTabBarItemImage];
                selectedImageInfo = _tabBarItemsAttributes[idx][SBTabBarItemSelectedImage];
                lottieURL = _tabBarItemsAttributes[idx][SBTabBarLottieURL];
                lottieSizeValue = _tabBarItemsAttributes[idx][SBTabBarLottieSize];

                NSValue *offsetValue = _tabBarItemsAttributes[idx][SBTabBarItemTitlePositionAdjustment];
                UIOffset offset = [offsetValue UIOffsetValue];
                titlePositionAdjustment = offset;
                
                NSValue *insetsValue = _tabBarItemsAttributes[idx][SBTabBarItemImageInsets];
                UIEdgeInsets insets = [insetsValue UIEdgeInsetsValue];
                imageInsets = insets;
            } else {
                idx--;
            }
            
            [self addOneChildViewController:viewController
                                  WithTitle:title
                            normalImageInfo:normalImageInfo
                          selectedImageInfo:selectedImageInfo
                    titlePositionAdjustment:titlePositionAdjustment
                                imageInsets:imageInsets
                                  lottieURL:lottieURL
                            lottieSizeValue:lottieSizeValue
             
             ];
            [[viewController sb_getViewControllerInsteadOfNavigationController] sb_setTabBarController:self];
            idx++;
        }
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [[viewController sb_getViewControllerInsteadOfNavigationController] sb_setTabBarController:nil];
        }
        _viewControllers = nil;
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.f) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.tabBar setSelectedImageTintColor:tintColor];
#pragma clang diagnostic pop
    }
    self.tabBar.tintColor = tintColor;
}

/**
 *  添加一个子控制器
 *
 *  @param viewController    控制器
 *  @param title             标题
 *  @param normalImageInfo   图片
 *  @param selectedImageInfo 选中图片
 */
- (void)addOneChildViewController:(UIViewController *)viewController
                        WithTitle:(NSString *)title
                  normalImageInfo:(id)normalImageInfo
                selectedImageInfo:(id)selectedImageInfo
          titlePositionAdjustment:(UIOffset)titlePositionAdjustment
                      imageInsets:(UIEdgeInsets)imageInsets
                        lottieURL:(NSURL *)lottieURL
                  lottieSizeValue:(NSValue *)lottieSizeValue {
    viewController.tabBarItem.title = title;
    CGSize placeholderSize = CGSizeMake(22, 22);
    UIImage *placeholderImage = [UIImage sb_imageWithColor:[UIColor whiteColor] size:placeholderSize];
    UIImage *normalImage = nil;
    if (normalImageInfo) {
        normalImage = [self getImageFromImageInfo:normalImageInfo];
    } else {
        normalImage = placeholderImage;
    }
    viewController.tabBarItem.image = normalImage;

    UIImage *selectedImage = nil;
    if (selectedImageInfo) {
        selectedImage = [self getImageFromImageInfo:selectedImageInfo];
    } else {
        selectedImage = placeholderImage;
    }
    viewController.tabBarItem.selectedImage = selectedImage;

    if (self.shouldCustomizeImageInsets || ([self isNOTEmptyForImageInsets:imageInsets])) {
        UIEdgeInsets insets = (([self isNOTEmptyForImageInsets:imageInsets]) ? imageInsets : self.imageInsets);
        viewController.tabBarItem.imageInsets = insets;
    }
    if (self.shouldCustomizeTitlePositionAdjustment || [self isNOTEmptyForTitlePositionAdjustment:titlePositionAdjustment]) {
        UIOffset offset = (([self isNOTEmptyForTitlePositionAdjustment:titlePositionAdjustment]) ? titlePositionAdjustment : self.titlePositionAdjustment);
        viewController.tabBarItem.titlePositionAdjustment = offset;
    }
    if (lottieURL) {
        [self.lottieURLs addObject:lottieURL];
        NSValue *tureLottieSizeValue = nil;
        do {
            if (!CGSizeEqualToSize(CGSizeZero, [lottieSizeValue CGSizeValue])) {
                tureLottieSizeValue = lottieSizeValue;
                break;
            }
            if (normalImage && !CGSizeEqualToSize(CGSizeZero, normalImage.size)) {
                tureLottieSizeValue = [NSValue valueWithCGSize:normalImage.size];
                break;
            }
            tureLottieSizeValue = [NSValue valueWithCGSize:placeholderSize];
            break;
        } while (NO);
        [self.lottieSizes addObject:tureLottieSizeValue];
    }
    [self addChildViewController:viewController];
}

- (UIImage *)getImageFromImageInfo:(id)imageInfo {
    UIImage *image = nil;
    if ([imageInfo isKindOfClass:[NSString class]]) {
        image = [UIImage imageNamed:imageInfo];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else if ([imageInfo isKindOfClass:[UIImage class]]) {
        image = (UIImage *)imageInfo;
    }
    return image;
}

- (BOOL)shouldCustomizeImageInsets {
    BOOL shouldCustomizeImageInsets = [self isNOTEmptyForImageInsets:self.imageInsets];
    return shouldCustomizeImageInsets;
}

- (BOOL)shouldCustomizeTitlePositionAdjustment {
    BOOL shouldCustomizeTitlePositionAdjustment = [self isNOTEmptyForTitlePositionAdjustment:self.titlePositionAdjustment];
    return shouldCustomizeTitlePositionAdjustment;
}

- (BOOL)isNOTEmptyForImageInsets:(UIEdgeInsets)imageInsets {
    if (imageInsets.top != 0 || imageInsets.left != 0 || imageInsets.bottom != 0 || imageInsets.right != 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isNOTEmptyForTitlePositionAdjustment:(UIOffset)titlePositionAdjustment {
    if (titlePositionAdjustment.horizontal != 0 || titlePositionAdjustment.vertical != 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isNOTEmptyForSize:(UIOffset)titlePositionAdjustment {
    if (titlePositionAdjustment.horizontal != 0 || titlePositionAdjustment.vertical != 0) {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - KVO Method

// KVO监听执行
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(context != SBTabImageViewDefaultOffsetContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if(context == SBTabImageViewDefaultOffsetContext) {
        CGFloat tabImageViewDefaultOffset = [change[NSKeyValueChangeNewKey] floatValue];
        [self offsetTabBarTabImageViewToFit:tabImageViewDefaultOffset];
    }
}

- (void)offsetTabBarTabImageViewToFit:(CGFloat)tabImageViewDefaultOffset {
    if (self.shouldCustomizeImageInsets) {
        return;
    }
    NSArray<UITabBarItem *> *tabBarItems = self.tabBar.items;
    [tabBarItems enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIEdgeInsets imageInset = UIEdgeInsetsMake(tabImageViewDefaultOffset, 0, -tabImageViewDefaultOffset, 0);
        obj.imageInsets = imageInset;
        if (!self.shouldCustomizeTitlePositionAdjustment) {
            obj.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
        }
    }];
}

#pragma mark - delegate
- (void)updateSelectionStatusIfNeededForTabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [self updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController shouldSelect:YES];
}

- (void)updateSelectionStatusIfNeededForTabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController shouldSelect:(BOOL)shouldSelect {
    [[viewController.tabBarItem sb_tabButton] sb_setShouldNotSelect:!shouldSelect];
    if (!shouldSelect) {
        return;
    }
    UIButton *plusButton = SBExternPlusButton;
    if (!viewController) {
        viewController = self.selectedViewController;
    }
    BOOL isCurrentViewController = [self isEqualViewController:viewController compairedViewController:SBPlusChildViewController];
    BOOL shouldConfigureSelectionStatus = (!isCurrentViewController);
    plusButton.selected = !shouldConfigureSelectionStatus;
    if (!shouldConfigureSelectionStatus) {
        [self.tabBar sb_stopAnimationOfAllLottieView];
    }
}

- (BOOL)isEqualViewController:(UIViewController *)viewController compairedViewController:(UIViewController *)compairedViewController {
    if ([viewController isEqual:compairedViewController]) {
        return YES;
    }
    if ([[viewController sb_getViewControllerInsteadOfNavigationController] isEqual:[compairedViewController sb_getViewControllerInsteadOfNavigationController]]) {
        return YES;
    }
    return NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [self updateSelectionStatusIfNeededForTabBarController:tabBarController shouldSelectViewController:viewController];
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
}

- (BOOL)isLottieEnabled {
    NSInteger lottieURLCount = self.lottieURLs.count;
    BOOL isLottieEnabled = lottieURLCount > 0 ;
    return isLottieEnabled;
}

- (void)didSelectControl:(UIControl *)control {
    SEL actin = @selector(tabBarController:didSelectControl:);

    BOOL shouldSelectViewController =  YES;
    @try {
       shouldSelectViewController = (!control.sb_shouldNotSelect) && (!control.hidden) ;
    } @catch (NSException *exception) {
        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), exception.reason);
    }
    
    BOOL isSelected = control.sb_isSelected;
    if (shouldSelectViewController) {
        [self.tabBar.sb_visibleControls enumerateObjectsUsingBlock:^(UIControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        control.selected = YES;
        UIControl *tabButton = control;
        BOOL isChildViewControllerPlusButton = [control sb_isChildViewControllerPlusButton];
        BOOL isLottieEnabled = [self isLottieEnabled];
        if (!isSelected && isLottieEnabled && !isChildViewControllerPlusButton) {
            [self addLottieImageWithControl:tabButton animation:YES];
        }
    }
    
    if ([self.delegate respondsToSelector:actin] && shouldSelectViewController) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:actin withObject:self withObject:control ?: self.selectedViewController.tabBarItem.sb_tabButton];
#pragma clang diagnostic pop
    }
}

- (void)addLottieImageWithControl:(UIControl *)control animation:(BOOL)animation {
    [self addLottieImageWithControl:control animation:animation defaultSelected:NO];
}

- (void)addLottieImageWithControl:(UIControl *)control animation:(BOOL)animation defaultSelected:(BOOL)defaultSelected {
     NSUInteger index = [self.tabBar.sb_subTabBarButtonsWithoutPlusButton indexOfObject:control];
    if (NSNotFound == index) {
        return;
    }
    if (control.sb_isPlusButton) {
        return;
    }
    NSURL *lottieURL = self.lottieURLs[index];
    NSValue *lottieSizeValue = self.lottieSizes[index];
    CGSize lottieSize = [lottieSizeValue CGSizeValue];
    [control sb_addLottieImageWithLottieURL:lottieURL size:lottieSize];
    if (animation) {
        [self.tabBar sb_animationLottieImageWithSelectedControl:control lottieURL:lottieURL size:lottieSize defaultSelected:defaultSelected];
    }
}

- (id)rootViewController {
    SBTabBarController *tabBarController = nil;
    id<UIApplicationDelegate> delegate = ((id<UIApplicationDelegate>)[[UIApplication sharedApplication] delegate]);
    UIWindow *window = delegate.window;
    UIViewController *rootViewController = [window.rootViewController sb_getViewControllerInsteadOfNavigationController];;
    if ([rootViewController isKindOfClass:[SBTabBarController class]]) {
        tabBarController = (SBTabBarController *)rootViewController;
    }
    return tabBarController;
}

/**
 *  lazy load lottieURLs
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *)lottieURLs {
    if (_lottieURLs == nil) {
        NSMutableArray *lottieURLs = [[NSMutableArray alloc] init];
        _lottieURLs = lottieURLs;
    }
    return _lottieURLs;
}

/**
 *  lazy load lottieSizes
 *
 *  @return NSMutableArray
 */
- (NSMutableArray *)lottieSizes {
    if (_lottieSizes == nil) {
        NSMutableArray *lottieSizes = [[NSMutableArray alloc] init];
        _lottieSizes = lottieSizes;
    }
    return _lottieSizes;
}
@end
