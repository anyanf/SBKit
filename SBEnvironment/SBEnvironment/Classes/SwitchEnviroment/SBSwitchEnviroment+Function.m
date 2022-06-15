//
//  SBSwitchEnviroment+Function.m
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//

#import "SBSwitchEnviroment+Function.h"

#import "SBSelectENVFloatView.h"

#import "SBSelectENVPopView.h"


@implementation SBSwitchEnviroment (Function)

+ (UIView *)setupFloatBallView:(UIView *)superView changeENVBlock:(void(^)(void))changeENVBlock {
#ifdef DEBUG
    
    SBSelectENVFloatView *viewBall = [[SBSelectENVFloatView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    viewBall.center = CGPointMake(SB_SCREEN_W_K - 22, SB_SCREEN_H_K /4.0 * 3);
    viewBall.ballClickedBlock = ^{
        SBSelectENVPopView *view= [[SBSelectENVPopView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:view];
        if (changeENVBlock) {
            view.changeENVBlock = changeENVBlock;
        }
    };
    if (superView) {
        [superView addSubview:viewBall];
        [superView bringSubviewToFront:viewBall];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:viewBall];
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:viewBall];
    }
    return viewBall;
#else
    return nil;
#endif
}


@end
