//
//  SBSwitchEnviroment+Function.h
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//


#import "SBSwitchEnviroment.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBSwitchEnviroment (Function)

/** 显示切换环境界面 */
+ (UIView *)setupFloatBallView:(UIView *)superView changeENVBlock:(void(^)(void))changeENVBlock;


@end

NS_ASSUME_NONNULL_END
