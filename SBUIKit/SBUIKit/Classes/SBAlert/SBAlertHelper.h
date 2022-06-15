//
//  SBAlertHelper.h
//  Pods
//
//  Created by 安康 on 2019/9/24.
//

#ifndef SBAlertHelper_h
#define SBAlertHelper_h


FOUNDATION_EXPORT double SBAlertVersionNumber;
FOUNDATION_EXPORT const unsigned char SBAlertVersionString[];

@class SBAlert , SBAlertConfig , SBAlertConfigModel , SBAlertWindow , SBAction , SBItem , SBCustomView;

typedef NS_ENUM(NSInteger, SBScreenOrientationType) {
    /** 屏幕方向类型 横屏 */
    SBScreenOrientationTypeHorizontal,
    /** 屏幕方向类型 竖屏 */
    SBScreenOrientationTypeVertical
};


typedef NS_ENUM(NSInteger, SBAlertType) {
    
    SBAlertTypeAlert,
    
    SBAlertTypeActionSheet
};


typedef NS_ENUM(NSInteger, SBActionType) {
    /** 默认 */
    SBActionTypeDefault,
    /** 取消 */
    SBActionTypeCancel,
    /** 销毁 */
    SBActionTypeDestructive
};


typedef NS_OPTIONS(NSInteger, SBActionBorderPosition) {
    /** Action边框位置 上 */
    SBActionBorderPositionTop      = 1 << 0,
    /** Action边框位置 下 */
    SBActionBorderPositionBottom   = 1 << 1,
    /** Action边框位置 左 */
    SBActionBorderPositionLeft     = 1 << 2,
    /** Action边框位置 右 */
    SBActionBorderPositionRight    = 1 << 3
};


typedef NS_ENUM(NSInteger, SBItemType) {
    /** 标题 */
    SBItemTypeTitle,
    /** 内容 */
    SBItemTypeContent,
    /** 输入框 */
    SBItemTypeTextField,
    /** 自定义视图 */
    SBItemTypeCustomView,
};


typedef NS_ENUM(NSInteger, SBCustomViewPositionType) {
    /** 居中 */
    SBCustomViewPositionTypeCenter,
    /** 靠左 */
    SBCustomViewPositionTypeLeft,
    /** 靠右 */
    SBCustomViewPositionTypeRight
};

typedef NS_OPTIONS(NSInteger, SBAnimationStyle) {
    /** 动画样式方向 默认 */
    SBAnimationStyleOrientationNone    = 1 << 0,
    /** 动画样式方向 上 */
    SBAnimationStyleOrientationTop     = 1 << 1,
    /** 动画样式方向 下 */
    SBAnimationStyleOrientationBottom  = 1 << 2,
    /** 动画样式方向 左 */
    SBAnimationStyleOrientationLeft    = 1 << 3,
    /** 动画样式方向 右 */
    SBAnimationStyleOrientationRight   = 1 << 4,
    
    /** 动画样式 淡入淡出 */
    SBAnimationStyleFade               = 1 << 12,
    
    /** 动画样式 缩放 放大 */
    SBAnimationStyleZoomEnlarge        = 1 << 24,
    /** 动画样式 缩放 缩小 */
    SBAnimationStyleZoomShrink         = 2 << 24,
};

NS_ASSUME_NONNULL_BEGIN
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlock)(void);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToBool)(BOOL is);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToInteger)(NSInteger number);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToFloat)(CGFloat number);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToString)(NSString *str);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToView)(UIView *view);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToColor)(UIColor *color);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToSize)(CGSize size);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToPoint)(CGPoint point);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToEdgeInsets)(UIEdgeInsets insets);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToAnimationStyle)(SBAnimationStyle style);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToBlurEffectStyle)(UIBlurEffectStyle style);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToInterfaceOrientationMask)(UIInterfaceOrientationMask);
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToFloatBlock)(CGFloat(^)(SBScreenOrientationType type));
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToAction)(void(^)(SBAction *action));
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToCustomView)(void(^)(SBCustomView *custom));
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToStringAndBlock)(NSString *str, void (^ _Nullable)(void));
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToConfigLabel)(void(^ _Nullable)(UILabel *label));
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToConfigTextField)(void(^ _Nullable)(UITextField *textField));
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToItem)(void(^)(SBItem *item));
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToBlock)(void(^block)(void));
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToBlockReturnBool)(BOOL(^block)(void));
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToBlockIntegerReturnBool)(BOOL(^block)(NSInteger index));
typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToBlockAndBlock)(void(^)(void (^animatingBlock)(void) , void (^animatedBlock)(void)));

typedef SBAlertConfigModel * _Nonnull (^SBAlertConfigBlockToStatusBarStyle)(UIStatusBarStyle style);
NS_ASSUME_NONNULL_END



#endif /* SBAlertHelper_h */
