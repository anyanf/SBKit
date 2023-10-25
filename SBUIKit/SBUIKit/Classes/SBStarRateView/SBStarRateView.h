//
//  SBStarRateView.h
//  SBUIKit
//
//  Created by ankang on 2020/12/29.
//

#import "UIView+SBExtension.h"

NS_ASSUME_NONNULL_BEGIN

@class SBStarRateView;
@protocol SBStarRateViewDelegate <NSObject>
- (void)starRateView:(SBStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent;
@end

@interface SBStarRateViewConfig : NSObject

/** 选中星图片 */
@property (nonatomic, strong) UIImage *starSelectedImage;
/** 默认星图片 */
@property (nonatomic, strong) UIImage *starNormalImage;
/** 星星数量，默认5 */
@property (nonatomic, assign) NSInteger numberOfStars;
/** 得分值，范围为0--1，默认为1 */
@property (nonatomic, assign) CGFloat scorePercent;
/** 是否允许动画，默认为NO */
@property (nonatomic, assign) BOOL hasAnimation;
/** 评分时是否允许不是整星，默认为NO */
@property (nonatomic, assign) BOOL allowIncompleteStar;
/** 星星间距，默认0 */
@property (nonatomic, assign) CGFloat starSpacing;
/** 每颗星的大小，如果不设置，则按图片大小适应 */
@property (nonatomic, assign) CGSize starSize;
/** 是否支持选中 */
@property (nonatomic, assign) BOOL canSelect;

@end

@interface SBStarRateView : UIView


@property (nonatomic, weak) id<SBStarRateViewDelegate>delegate;


+ (instancetype)createWithFrame:(CGRect)frame
                  configBuilder:(void (^) (SBStarRateViewConfig *config))configBuilder;

- (void)setScorePercent:(CGFloat)scroePercent;

- (instancetype)alloc __attribute__((unavailable("alloc not available")));
- (instancetype)init __attribute__((unavailable("init not available")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("init not available")));
- (instancetype)new __attribute__((unavailable("new not available")));


@end

NS_ASSUME_NONNULL_END
