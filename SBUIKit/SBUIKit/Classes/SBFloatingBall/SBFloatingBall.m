//
//  SBFloatingBall.m
//  SBUIKit
//
//  Created by 安康 on 2019/11/29.
//

#import "SBFloatingBall.h"

#include <objc/runtime.h>

#pragma mark - SBFloatingBallWindow

@interface SBFloatingBallWindow : UIWindow
@end

@implementation SBFloatingBallWindow

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    __block SBFloatingBall *floatingBall = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SBFloatingBall class]]) {
            floatingBall = (SBFloatingBall *)obj;
            *stop = YES;
        }
    }];
    
    if (CGRectContainsPoint(floatingBall.bounds,
            [floatingBall convertPoint:point fromView:self])) {
        return [super pointInside:point withEvent:event];
    }
    
    return NO;
}
@end

#pragma mark - SBFloatingBallManager

@interface SBFloatingBallManager : NSObject
@property (nonatomic, assign) BOOL canRuntime;
@property (nonatomic,   weak) UIView *superView;
@end

@implementation SBFloatingBallManager

+ (instancetype)shareManager {
    static SBFloatingBallManager *ballMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ballMgr = [[SBFloatingBallManager alloc] init];
    });
    
    return ballMgr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.canRuntime = NO;
    }
    return self;
}
@end

#pragma mark - UIView (SBAddSubview)

@interface UIView (SBAddSubview)

@end

@implementation UIView (SBAddSubview)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(addSubview:)), class_getInstanceMethod(self, @selector(mis_addSubview:)));
    });
}

- (void)mis_addSubview:(UIView *)subview {
    [self mis_addSubview:subview];
    
    if ([SBFloatingBallManager shareManager].canRuntime) {
        if ([[SBFloatingBallManager shareManager].superView isEqual:self]) {
            [self.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[SBFloatingBall class]]) {
                    [self insertSubview:subview belowSubview:(SBFloatingBall *)obj];
                }
            }];
        }
    }
}

@end

#pragma mark - SBFloatingBall

@interface SBFloatingBall()
@property (nonatomic, assign) CGPoint centerOffset;
@property (nonatomic,   copy) SBEdgeRetractConfig(^edgeRetractConfigHander) (void);
@property (nonatomic, assign) NSTimeInterval autoEdgeOffsetDuration;

@property (nonatomic, assign, getter=isAutoEdgeRetract) BOOL autoEdgeRetract;

@property (nonatomic, strong) UIView *parentView;

// content
@property (nonatomic, strong) UIImageView *ballImageView;
@property (nonatomic, strong) UILabel *ballLabel;
@property (nonatomic, strong) UIView *ballCustomView;

@property (nonatomic, assign) UIEdgeInsets effectiveEdgeInsets;
@end

static const NSInteger minUpDownLimits = 60 * 1.5f;   // SBFloatingBallEdgePolicyAllEdge 下，悬浮球到达一个界限开始自动靠近上下边缘



@implementation SBFloatingBall

#pragma mark - Life Cycle

- (void)dealloc {
    LOG_AK_(@"SBFloatingBall dealloc");
    [SBFloatingBallManager shareManager].canRuntime = NO;
    [SBFloatingBallManager shareManager].superView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame inSpecifiedView:nil effectiveEdgeInsets:UIEdgeInsetsZero];
}


- (instancetype)initWithFrame:(CGRect)frame inSpecifiedView:(UIView *)specifiedView effectiveEdgeInsets:(UIEdgeInsets)effectiveEdgeInsets {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _autoCloseEdge = NO;
        _autoEdgeRetract = NO;
        _edgePolicy = SBFloatingBallEdgePolicyAllEdge;
        _effectiveEdgeInsets = effectiveEdgeInsets;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        
        [self addGestureRecognizer:tapGesture];
        [self addGestureRecognizer:panGesture];
        [self configSpecifiedView:specifiedView];
    }
    return self;
}

- (void)configSpecifiedView:(UIView *)specifiedView {
    if (specifiedView) {
        _parentView = specifiedView;
    }
    else {
        UIWindow *window = [[SBFloatingBallWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.windowLevel = CGFLOAT_MAX; //UIWindowLevelStatusBar - 1;
        window.rootViewController = [UIViewController new];
        window.rootViewController.view.backgroundColor = [UIColor clearColor];
        window.rootViewController.view.userInteractionEnabled = NO;
        [window makeKeyAndVisible];
        
        _parentView = window;
    }
    
//    _parentView.hidden = YES;
    _centerOffset = CGPointMake(_parentView.bounds.size.width * 0.6, _parentView.bounds.size.height * 0.6);
    
    // setup ball manager
    [SBFloatingBallManager shareManager].canRuntime = YES;
    [SBFloatingBallManager shareManager].superView = specifiedView;
}

#pragma mark - Private Methods

// 靠边
- (void)autoCloseEdge {
    [UIView animateWithDuration:0.5f animations:^{
        // center
        self.center = [self calculatePoisitionWithEndOffset:CGPointZero];//center;
    } completion:^(BOOL finished) {
        // 靠边之后自动缩进边缘处
        if (self.isAutoEdgeRetract) {
            [self performSelector:@selector(autoEdgeOffset) withObject:nil afterDelay:self.autoEdgeOffsetDuration];
        }
    }];
}

- (void)autoEdgeOffset {
    SBEdgeRetractConfig config = self.edgeRetractConfigHander ? self.edgeRetractConfigHander() : SBEdgeOffsetConfigMake(CGPointMake(self.bounds.size.width * 0.3, self.bounds.size.height * 0.3), 0.8);
    
    [UIView animateWithDuration:0.5f animations:^{
        self.center = [self calculatePoisitionWithEndOffset:config.edgeRetractOffset];
        self.alpha = config.edgeRetractAlpha;
    }];
}

- (CGPoint)calculatePoisitionWithEndOffset:(CGPoint)offset {
    CGFloat ballHalfW   = self.bounds.size.width * 0.5;
    CGFloat ballHalfH   = self.bounds.size.height * 0.5;
    CGFloat parentViewW = self.parentView.bounds.size.width;
    CGFloat parentViewH = self.parentView.bounds.size.height;
    CGPoint center = self.center;
    
    
    if (SBFloatingBallEdgePolicyRight == self.edgePolicy) {
        // 右
        center.x = parentViewW + offset.x - ballHalfW + self.effectiveEdgeInsets.right;
    } else if (SBFloatingBallEdgePolicyLeftRight == self.edgePolicy) {
        // 左右
        center.x = (center.x < self.parentView.bounds.size.width * 0.5) ? (ballHalfW - offset.x + self.effectiveEdgeInsets.left) : (parentViewW + offset.x - ballHalfW + self.effectiveEdgeInsets.right);
    }
    else if (SBFloatingBallEdgePolicyUpDown == self.edgePolicy) {
        center.y = (center.y < self.parentView.bounds.size.height * 0.5) ? (ballHalfH - offset.y + self.effectiveEdgeInsets.top) : (parentViewH + offset.y - ballHalfH + self.effectiveEdgeInsets.bottom);
    }
    else if (SBFloatingBallEdgePolicyAllEdge == self.edgePolicy) {
        if (center.y < minUpDownLimits) {
            center.y = ballHalfH - offset.y + self.effectiveEdgeInsets.top;
        }
        else if (center.y > parentViewH - minUpDownLimits) {
            center.y = parentViewH + offset.y - ballHalfH + self.effectiveEdgeInsets.bottom;
        }
        else {
            center.x = (center.x < self.parentView.bounds.size.width  * 0.5) ? (ballHalfW - offset.x + self.effectiveEdgeInsets.left) : (parentViewW + offset.x - ballHalfW + self.effectiveEdgeInsets.right);
        }
    }
    return center;
}

#pragma mark - Public Methods

- (void)show {
//    self.parentView.hidden = NO;
    [self.parentView addSubview:self];
}

- (void)hide {
//    self.parentView.hidden = YES;
    [self removeFromSuperview];
}



- (void)autoEdgeRetractDuration:(NSTimeInterval)duration
        edgeRetractConfigHander:(SBEdgeRetractConfig (^) (void))edgeRetractConfigHander {
    if (self.isAutoCloseEdge) {
        // 只有自动靠近边缘的时候才生效
        self.edgeRetractConfigHander = edgeRetractConfigHander;
        self.autoEdgeOffsetDuration = duration;
        self.autoEdgeRetract = YES;
    }
}

- (void)setContent:(id)content contentType:(SBFloatingBallContentType)contentType {
    BOOL notUnknowType = (SBFloatingBallContentTypeCustomView == contentType) || (SBFloatingBallContentTypeImage == contentType) || (SBFloatingBallContentTypeText == contentType);
    NSAssert(notUnknowType, @"can't set ball content with an unknow content type");
    
    [self.ballCustomView removeFromSuperview];
    if (SBFloatingBallContentTypeImage == contentType) {
        NSAssert([content isKindOfClass:[UIImage class]], @"can't set ball content with a not image content for image type");
        [self.ballLabel setHidden:YES];
        [self.ballCustomView setHidden:YES];
        [self.ballImageView setHidden:NO];
        [self.ballImageView setImage:(UIImage *)content];
    }
    else if (SBFloatingBallContentTypeText == contentType) {
        NSAssert([content isKindOfClass:[NSString class]], @"can't set ball content with a not nsstring content for text type");
        [self.ballLabel setHidden:NO];
        [self.ballCustomView setHidden:YES];
        [self.ballImageView setHidden:YES];
        [self.ballLabel setText:(NSString *)content];
    }
    else if (SBFloatingBallContentTypeCustomView == contentType) {
        NSAssert([content isKindOfClass:[UIView class]], @"can't set ball content with a not uiview content for custom view type");
        [self.ballLabel setHidden:YES];
        [self.ballCustomView setHidden:NO];
        [self.ballImageView setHidden:YES];
        
        self.ballCustomView = (UIView *)content;
        
        CGRect frame = self.ballCustomView.frame;
        frame.origin.x = (self.bounds.size.width - self.ballCustomView.bounds.size.width) * 0.5;
        frame.origin.y = (self.bounds.size.height - self.ballCustomView.bounds.size.height) * 0.5;
        self.ballCustomView.frame = frame;
        
        self.ballCustomView.userInteractionEnabled = NO;
        [self addSubview:self.ballCustomView];
    }
}

#pragma mark - GestureRecognizer

// 手势处理
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    if (UIGestureRecognizerStateBegan == panGesture.state) {
        [self setAlpha:1.0f];
        
        // cancel
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoEdgeOffset) object:nil];
    }
    else if (UIGestureRecognizerStateChanged == panGesture.state) {
        CGPoint translation = [panGesture translationInView:self];
        
        CGPoint center = self.center;
        center.x += translation.x;
        center.y += translation.y;
        self.center = center;
        
        CGFloat   leftMinX = 0.0f + self.effectiveEdgeInsets.left;
        CGFloat    topMinY = 0.0f + self.effectiveEdgeInsets.top;
        CGFloat  rightMaxX = self.parentView.bounds.size.width - self.bounds.size.width + self.effectiveEdgeInsets.right;
        CGFloat bottomMaxY = self.parentView.bounds.size.height - self.bounds.size.height + self.effectiveEdgeInsets.bottom;
        
        CGRect frame = self.frame;
        frame.origin.x = frame.origin.x > rightMaxX ? rightMaxX : frame.origin.x;
        frame.origin.x = frame.origin.x < leftMinX ? leftMinX : frame.origin.x;
        frame.origin.y = frame.origin.y > bottomMaxY ? bottomMaxY : frame.origin.y;
        frame.origin.y = frame.origin.y < topMinY ? topMinY : frame.origin.y;
        self.frame = frame;
        
        // zero
        [panGesture setTranslation:CGPointZero inView:self];
    }
    else if (UIGestureRecognizerStateEnded == panGesture.state) {
        if (self.isAutoCloseEdge) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 0.2s 之后靠边
                [self autoCloseEdge];
            });
        }
    }
}

- (void)tapGestureRecognizer:(UIPanGestureRecognizer *)tapGesture {
    __weak __typeof(self) weakSelf = self;
    if (self.clickHandler) {
        self.clickHandler(weakSelf);
    }
    
    if ([_delegate respondsToSelector:@selector(didClickFloatingBall:)]) {
        [_delegate didClickFloatingBall:self];
    }
}

#pragma mark - Setter / Getter

- (void)setAutoCloseEdge:(BOOL)autoCloseEdge {
    _autoCloseEdge = autoCloseEdge;
    
    if (autoCloseEdge) {
        [self autoCloseEdge];
    }
}

- (void)setTextTypeTextColor:(UIColor *)textTypeTextColor {
    _textTypeTextColor = textTypeTextColor;
    
    [self.ballLabel setTextColor:textTypeTextColor];
}

- (UIImageView *)ballImageView {
    if (!_ballImageView) {
        _ballImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_ballImageView];
    }
    return _ballImageView;
}

- (UILabel *)ballLabel {
    if (!_ballLabel) {
        _ballLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _ballLabel.textAlignment = NSTextAlignmentCenter;
        _ballLabel.numberOfLines = 1.0f;
        _ballLabel.minimumScaleFactor = 0.0f;
        _ballLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_ballLabel];
    }
    return _ballLabel;
}
@end
