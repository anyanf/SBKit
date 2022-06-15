//
//  SBSelectENVFloatView.h
//  SBEnvironment
//
//  Created by 安康 on 2019/10/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBSelectENVFloatView : UIView

/** 小球点击事件 */
@property (nonatomic, copy) void(^ballClickedBlock)(void);

@end

NS_ASSUME_NONNULL_END
