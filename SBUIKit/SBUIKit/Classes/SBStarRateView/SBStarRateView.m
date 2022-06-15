//
//  SBStarRateView.m
//  SBUIKit
//
//  Created by ankang on 2020/12/29.
//

#import "SBStarRateView.h"

#define ANIMATION_TIME_INTERVAL 0.2

@implementation SBStarRateViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _numberOfStars = 5;
        _scorePercent = 1;
        _hasAnimation = NO;
        _allowIncompleteStar = NO;
        _starSpacing = 0;
        _canSelect = NO;
    }
    return self;
}

@end

@interface SBStarRateView ()

@property (nonatomic, strong) SBStarRateViewConfig *config;

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;

@end

@implementation SBStarRateView

+ (instancetype)createWithFrame:(CGRect)frame
                  configBuilder:(void (^) (SBStarRateViewConfig *config))configBuilder {
    SBStarRateView *view = [super createWithFrame:frame];
    SBStarRateViewConfig *config = [SBStarRateViewConfig new];
    if (configBuilder) {
        configBuilder(config);
    }
    view.config = config;
    return view;
}


#pragma mark - Private Methods

- (void)setConfig:(SBStarRateViewConfig *)config {

    _config = config;

    self.foregroundStarView = [self createStarViewWithImage:config.starSelectedImage];
    self.backgroundStarView = [self createStarViewWithImage:config.starNormalImage];
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
    if (config.canSelect) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    
    [self setScorePercent:config.scorePercent];
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    
    CGFloat offset = tapPoint.x;
    // 取得最终分数的整数部分
    CGFloat realStarScore = floorf(offset / (self.config.starSize.width + self.config.starSpacing));
    if (self.config.allowIncompleteStar) {
        // 取得最终分数的余数部分，舍去间距部分
        CGFloat realStarScoreRemainder = (NSInteger)offset % (NSInteger)(self.config.starSize.width + self.config.starSpacing);
        realStarScoreRemainder = MIN(1.0, realStarScoreRemainder / self.config.starSize.width);
        realStarScore += realStarScoreRemainder;
    }
    [self setScorePercent:realStarScore / self.config.numberOfStars];
}

- (UIView *)createStarViewWithImage:(UIImage *)image {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    if (CGSizeEqualToSize(self.config.starSize, CGSizeZero)) {
        self.config.starSize = self.config.starNormalImage.size;
    }
    for (NSInteger i = 0; i < self.config.numberOfStars; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i * (self.config.starSpacing + self.config.starSize.width),
                                     0, self.config.starSize.width,
                                     self.config.starSize.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    __weak SBStarRateView *weakSelf = self;
    CGFloat animationTimeInterval = self.config.hasAnimation ? ANIMATION_TIME_INTERVAL : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        // 宽度 = 分数的整数部分 * (星星宽度 + 间距) + 小数部分 * 星星宽度
        CGFloat realStarScore = weakSelf.config.scorePercent * weakSelf.config.numberOfStars;
        NSInteger scoreInt = (NSInteger)realStarScore;
        CGFloat width = scoreInt * (weakSelf.config.starSize.width + weakSelf.config.starSpacing);
        width += (realStarScore - scoreInt) * weakSelf.config.starSize.width;
        
        weakSelf.foregroundStarView.frame = CGRectMake(0, 0, width, weakSelf.bounds.size.height);
    }];
}

#pragma mark - Get and Set Methods

- (void)setScorePercent:(CGFloat)scroePercent {
    if (self.config.scorePercent == scroePercent) {
        return;
    }
    
    if (scroePercent < 0) {
        self.config.scorePercent = 0;
    } else if (scroePercent > 1) {
        self.config.scorePercent = 1;
    } else {
        self.config.scorePercent = scroePercent;
    }
    
    if ([self.delegate respondsToSelector:@selector(starRateView:scroePercentDidChange:)]) {
        [self.delegate starRateView:self scroePercentDidChange:self.config.scorePercent];
    }
    
    [self setNeedsLayout];
}


@end
