//
//  SBBottomSheetPanHandler.h
//  SBUIKit
//
//  Created by 安康 on 2019/10/6.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/** 底部抽屉效果手势处理器 */
@interface SBBottomSheetPanHandler : NSObject

/** 最小的Y值 */
@property (nonatomic, assign, readonly) CGFloat minY;
/** 中间的Y值 */
@property (nonatomic, assign, readonly) CGFloat midY;
/** 最大的Y值 */
@property (nonatomic, assign, readonly) CGFloat maxY;
/** 额外的高度 */
@property (nonatomic, assign)  CGFloat extraHeight;
/** 手势变化的位置回调 */
@property (nonatomic, copy) void (^offsetChangeBlock)(CGFloat afterY, CGFloat offsetY, CGFloat handleHeight, BOOL direction);
/** 手势结束的回调 */
@property (nonatomic, copy) void (^offsetCompleteBlock)(void);
/** 是否触发手势 */
@property (nonatomic, copy) BOOL (^shouldResponseGesture)(void);


/**
 * 创建handle
 *
 * @param  gestureView    响应手势的view
 * @param  handleView    显示handle位置的view

 * @return handle
 */
- (instancetype)initWithGestureView:(UIView *)gestureView
                         handleView:(UIView *)handleView
                               minY:(CGFloat)minY
                               midY:(CGFloat)midY
                               maxY:(CGFloat)maxY;

@end

NS_ASSUME_NONNULL_END
