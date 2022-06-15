//
//  SBAlert.h
//  
//
//  Created by 安康 on 2019/9/24.
//



#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "SBAlertHelper.h"


/*
 *************************简要说明************************
 
 Alert 使用方法
 
 [SBAlert alert].config.XXXXX.XXXXX.sbShow();
 
 ActionSheet 使用方法
 
 [SBAlert actionSheet].config.XXXXX.XXXXX.sbShow();
 
 特性:
 - 支持alert类型与actionsheet类型
 - 默认样式为Apple风格 可自定义其样式
 - 支持自定义标题与内容 可动态调整其样式
 - 支持自定义视图添加 同时可设置位置类型等 自定义视图size改变时会自动适应.
 - 支持输入框添加 自动处理键盘相关的细节
 - 支持屏幕旋转适应 同时可自定义横竖屏最大宽度和高度
 - 支持自定义action添加 可动态调整其样式
 - 支持内部添加的功能项的间距范围设置等
 - 支持圆角设置 支持阴影效果设置
 - 支持队列和优先级 多个同时显示时根据优先级顺序排队弹出 添加到队列的如被高优先级覆盖 以后还会继续显示.
 - 支持两种背景样式 1.半透明 (支持自定义透明度比例和颜色) 2.毛玻璃 (支持效果类型)
 - 支持自定义UIView动画方法
 - 支持自定义打开关闭动画样式(动画方向 渐变过渡 缩放过渡等)
 - 更多特性未来版本中将不断更新.
 
 设置方法结束后在最后请不要忘记使用.sbShow()方法来显示.
 
 最低支持iOS8及以上
 
 *****************************************************
 */

NS_ASSUME_NONNULL_BEGIN

@interface SBAlert : NSObject

/** 初始化 */

+ (nonnull SBAlertConfig *)alert;

+ (nonnull SBAlertConfig *)actionsheet;

/** 获取Alert窗口 */
+ (nonnull SBAlertWindow *)getAlertWindow;

/** 设置主窗口 */
+ (void)configMainWindow:(UIWindow *)window;

/** 继续队列显示 */
+ (void)continueQueueDisplay;

/** 清空队列 */
+ (void)clearQueue;

/**
 关闭指定标识

 @param identifier 标识
 @param completionBlock 关闭完成回调
 */
+ (void)closeWithIdentifier:(NSString *)identifier completionBlock:(void (^ _Nullable)(void))completionBlock;

/**
 关闭指定标识

 @param identifier 标识
 @param force 是否强制关闭
 @param completionBlock 关闭完成回调
 */
+ (void)closeWithIdentifier:(NSString *)identifier force:(BOOL)force completionBlock:(void (^ _Nullable)(void))completionBlock;

/**
 关闭当前

 @param completionBlock 关闭完成回调
 */
+ (void)closeWithCompletionBlock:(void (^ _Nullable)(void))completionBlock;

@end

@interface SBAlertConfigModel : NSObject

/** ✨通用设置 */

/** 设置 标题 -> 格式: .sbTitle(@@"") */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToString sbTitle;

/** 设置 内容 -> 格式: .sbContent(@@"") */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToString sbContent;

/** 设置 自定义视图 -> 格式: .sbCustomView(UIView) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToView sbCustomView;

/** 设置 动作 -> 格式: .sbAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToStringAndBlock sbAction;

/** 设置 取消动作 -> 格式: .sbCancelAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToStringAndBlock sbCancelAction;

/** 设置 取消动作 -> 格式: .sbDestructiveAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToStringAndBlock sbDestructiveAction;

/** 设置 添加标题 -> 格式: .sbConfigTitle(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToConfigLabel sbAddTitle;

/** 设置 添加内容 -> 格式: .sbConfigContent(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToConfigLabel sbAddContent;

/** 设置 添加自定义视图 -> 格式: .sbAddCustomView(^(SBCustomView *){ //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToCustomView sbAddCustomView;

/** 设置 添加一项 -> 格式: .sbAddItem(^(SBItem *){ //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToItem sbAddItem;

/** 设置 添加动作 -> 格式: .sbAddAction(^(SBAction *){ //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToAction sbAddAction;

/** 设置 头部内的间距 -> 格式: .sbHeaderInsets(UIEdgeInsetsMake(20, 20, 20, 20)) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToEdgeInsets sbHeaderInsets;

/** 设置 上一项的间距 (在它之前添加的项的间距) -> 格式: .sbItemInsets(UIEdgeInsetsMake(5, 0, 5, 0)) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToEdgeInsets sbItemInsets;

/** 设置 最大宽度 -> 格式: .sbMaxWidth(280.0f) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbMaxWidth;

/** 设置 最大高度 -> 格式: .sbMaxHeight(400.0f) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbMaxHeight;

/** 设置 设置最大宽度 -> 格式: .sbConfigMaxWidth(CGFloat(^)(^CGFloat(SBScreenOrientationType type) { return 280.0f; }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloatBlock sbConfigMaxWidth;

/** 设置 设置最大高度 -> 格式: .sbConfigMaxHeight(CGFloat(^)(^CGFloat(SBScreenOrientationType type) { return 600.0f; }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloatBlock sbConfigMaxHeight;

/** 设置 圆角半径 -> 格式: .sbCornerRadius(13.0f) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbCornerRadius;

/** 设置 开启动画时长 -> 格式: .sbOpenAnimationDuration(0.3f) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbOpenAnimationDuration;

/** 设置 关闭动画时长 -> 格式: .sbCloseAnimationDuration(0.2f) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbCloseAnimationDuration;

/** 设置 颜色 -> 格式: .sbHeaderColor(UIColor) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToColor sbHeaderColor;

/** 设置 背景颜色 -> 格式: .sbBackGroundColor(UIColor) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToColor sbBackGroundColor;

/** 设置 半透明背景样式及透明度 [默认] -> 格式: .sbBackgroundStyleTranslucent(0.45f) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbBackgroundStyleTranslucent;

/** 设置 模糊背景样式及类型 -> 格式: .sbBackgroundStyleBlur(UIBlurEffectStyleDark) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToBlurEffectStyle sbBackgroundStyleBlur;

/** 设置 点击头部关闭 -> 格式: .sbClickHeaderClose(YES) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToBool sbClickHeaderClose;

/** 设置 点击背景关闭 -> 格式: .sbClickBackgroundClose(YES) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToBool sbClickBackgroundClose;

/** 设置 阴影偏移 -> 格式: .sbShadowOffset(CGSizeMake(0.0f, 2.0f)) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToSize sbShadowOffset;

/** 设置 阴影不透明度 -> 格式: .sbShadowOpacity(0.3f) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbShadowOpacity;

/** 设置 阴影半径 -> 格式: .sbShadowRadius(5.0f) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbShadowRadius;

/** 设置 阴影颜色 -> 格式: .sbShadowOpacity(UIColor) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToColor sbShadowColor;

/** 设置 标识 -> 格式: .sbIdentifier(@@"ident") */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToString sbIdentifier;

/** 设置 是否加入到队列 -> 格式: .sbQueue(YES) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToBool sbQueue;

/** 设置 优先级 -> 格式: .sbPriority(1000) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToInteger sbPriority;

/** 设置 是否继续队列显示 -> 格式: .sbContinueQueue(YES) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToBool sbContinueQueueDisplay;

/** 设置 window等级 -> 格式: .sbWindowLevel(UIWindowLevel) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbWindowLevel;

/** 设置 是否支持自动旋转 -> 格式: .sbShouldAutorotate(YES) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToBool sbShouldAutorotate;

/** 设置 是否支持显示方向 -> 格式: .sbShouldAutorotate(UIInterfaceOrientationMaskAll) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToInterfaceOrientationMask sbSupportedInterfaceOrientations;

/** 设置 打开动画配置 -> 格式: .sbOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToBlockAndBlock sbOpenAnimationConfig;

/** 设置 关闭动画配置 -> 格式: .sbCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToBlockAndBlock sbCloseAnimationConfig;

/** 设置 打开动画样式 -> 格式: .sbOpenAnimationStyle() */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToAnimationStyle sbOpenAnimationStyle;

/** 设置 关闭动画样式 -> 格式: .sbCloseAnimationStyle() */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToAnimationStyle sbCloseAnimationStyle;

/** 设置 状态栏样式 -> 格式: .sbStatusBarStyle(UIStatusBarStyleDefault) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToStatusBarStyle sbStatusBarStyle;


/** 显示  -> 格式: .sbShow() */
@property (nonatomic , copy , readonly ) SBAlertConfigBlock sbShow;

/** ✨alert 专用设置 */

/** 设置 添加输入框 -> 格式: .sbAddTextField(^(UITextField *){ //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToConfigTextField sbAddTextField;

/** 设置 中心点偏移 -> 格式: .sbCenterOffset(CGPointMake(0, 0)) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToPoint sbAlertCenterOffset;
    
/** 设置 是否闪避键盘 -> 格式: .sbAvoidKeyboard(YES) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToBool sbAvoidKeyboard;

/** ✨actionSheet 专用设置 */

/** 设置 ActionSheet的背景视图颜色 -> 格式: .sbActionSheetBackgroundColor(UIColor) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToColor sbActionSheetBackgroundColor;

/** 设置 取消动作的间隔宽度 -> 格式: .sbActionSheetCancelActionSpaceWidth(10.0f) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbActionSheetCancelActionSpaceWidth;

/** 设置 取消动作的间隔颜色 -> 格式: .sbActionSheetCancelActionSpaceColor(UIColor) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToColor sbActionSheetCancelActionSpaceColor;

/** 设置 ActionSheet距离屏幕底部的间距 -> 格式: .sbActionSheetBottomMargin(10.0f) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToFloat sbActionSheetBottomMargin;

/** 设置 是否可以关闭 -> 格式: .sbShouldClose(^{ return YES; }) */
@property (nonatomic, copy, readonly ) SBAlertConfigBlockToBlockReturnBool sbShouldClose;

/** 设置 是否可以关闭(Action 点击) -> 格式: .sbShouldActionClickClose(^(NSInteger index){ return YES; }) */
@property (nonatomic, copy, readonly ) SBAlertConfigBlockToBlockIntegerReturnBool sbShouldActionClickClose;

/** 设置 当前关闭回调 -> 格式: .sbCloseComplete(^{ //code.. }) */
@property (nonatomic , copy , readonly ) SBAlertConfigBlockToBlock sbCloseComplete;

@end


@interface SBItem : NSObject

/** item类型 */
@property (nonatomic , assign ) SBItemType type;

/** item间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** item设置视图Block */
@property (nonatomic , copy ) void (^block)(id view);

- (void)update;

@end

@interface SBAction : NSObject

/** action类型 */
@property (nonatomic , assign ) SBActionType type;

/** action标题 */
@property (nonatomic , strong ) NSString *title;

/** action高亮标题 */
@property (nonatomic , strong ) NSString *highlight;

/** action标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedTitle;

/** action高亮标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedHighlight;

/** action字体 */
@property (nonatomic , strong ) UIFont *font;

/** action标题颜色 */
@property (nonatomic , strong ) UIColor *titleColor;

/** action高亮标题颜色 */
@property (nonatomic , strong ) UIColor *highlightColor;

/** action背景颜色 (与 backgroundImage 相同) */
@property (nonatomic , strong ) UIColor *backgroundColor;

/** action高亮背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundHighlightColor;

/** action背景图片 (与 backgroundColor 相同) */
@property (nonatomic , strong ) UIImage *backgroundImage;

/** action高亮背景图片 */
@property (nonatomic , strong ) UIImage *backgroundHighlightImage;

/** action图片 */
@property (nonatomic , strong ) UIImage *image;

/** action高亮图片 */
@property (nonatomic , strong ) UIImage *highlightImage;

/** action间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** action图片的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets imageEdgeInsets;

/** action标题的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets titleEdgeInsets;

/** action圆角曲率 */
@property (nonatomic , assign ) CGFloat cornerRadius;

/** action高度 */
@property (nonatomic , assign ) CGFloat height;

/** action边框宽度 */
@property (nonatomic , assign ) CGFloat borderWidth;

/** action边框颜色 */
@property (nonatomic , strong ) UIColor *borderColor;

/** action边框位置 */
@property (nonatomic , assign ) SBActionBorderPosition borderPosition;

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic , assign ) BOOL isClickNotClose;

/** action点击事件回调Block */
@property (nonatomic , copy ) void (^ _Nullable clickBlock)(void);

- (void)update;

@end

@interface SBCustomView : NSObject

/** 自定义视图对象 */
@property (nonatomic , strong, nullable ) UIView *view;

/** 自定义视图位置类型 (默认为居中) */
@property (nonatomic , assign ) SBCustomViewPositionType positionType;

/** 是否自动适应宽度 (不支持 AutoLayout 布局的视图)*/
@property (nonatomic , assign ) BOOL isAutoWidth;

@end

@interface SBAlertConfig : NSObject

@property (nonatomic , strong, nonnull ) SBAlertConfigModel *config;

@property (nonatomic , assign ) SBAlertType type;

@end


@interface SBAlertWindow : UIWindow @end

@interface SBBaseViewController : UIViewController @end

@interface SBAlertViewController : SBBaseViewController @end

@interface SBActionSheetViewController : SBBaseViewController @end

NS_ASSUME_NONNULL_END
