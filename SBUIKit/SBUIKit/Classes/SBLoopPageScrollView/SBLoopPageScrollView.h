//
//  SBLoopPageScrollView.h
//  SBUIKit
//
//  Created by 安康 on 2020/5/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



typedef NS_ENUM (NSUInteger, SBLoopPageScrollAlignment)
{
    SBLoopPageScrollAlignment_Center  = 0,
    SBLoopPageScrollAlignment_Left,
    SBLoopPageScrollAlignment_right
};

typedef NS_ENUM (NSUInteger, SBLoopPageScrollDirection)
{
    /// 水平方向滚动
    SBLoopPageScrollDirection_Horizontal  = 0,
    /// 垂直方向滚动
    SBLoopPageScrollDirection_Vertical
};


@interface SBLoopPageScrollView : UIView

/// 是否支持自动滚动，默认yes
@property (nonatomic,assign)BOOL isCanAutoScroll;

/// 是否支持手动滚动，默认yes
@property (nonatomic,assign)BOOL isCanScroll;

/// pageControl 页面对齐方式，分左对齐、右对齐、居中，默认为居中
@property (nonatomic, assign) SBLoopPageScrollAlignment pageControlAlgnment;

/// 轮播数据源，支持图片url及view
@property (nonatomic, strong) NSArray *maryData;

/// 轮播view点击事件
@property (nonatomic, copy) void(^viewClickBlock)(NSInteger intIndex);

/// 图背景色 默认白色
@property (nonatomic, strong) UIColor *colorBackGround;

/**
 @param scrollDirection 滚动方向
 */
- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(SBLoopPageScrollDirection)scrollDirection;

/**
 *  删除定时器
 */
- (void)removeTimer;

@end

NS_ASSUME_NONNULL_END
