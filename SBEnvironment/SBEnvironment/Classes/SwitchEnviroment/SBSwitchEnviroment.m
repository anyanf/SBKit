//
//  SBSwitchEnviroment.m
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//

#import "SBSwitchEnviroment.h"

// 环境key
NSString *const SBEnvironmentSwitchKey = @"environment_switch_key";


static SB_Enviroment_Mode _enviromentType = SB_Enviroment_UnInit;

static id _envModel = nil;



@implementation SBSwitchEnviroment


+ (SB_Enviroment_Mode)enviromentType {
    if (SB_Enviroment_UnInit == _enviromentType) {
        _enviromentType = SB_Enviroment_Product;
#ifdef DEBUG
        // 检查之前是否保存过
        NSNumber *env = [[NSUserDefaults standardUserDefaults] objectForKey:SBEnvironmentSwitchKey];
        if (!env) {
            
            // 未保存过，默认取值：UAT环境
            env = @(SB_Enviroment_Product);
            
            // 进行保存
            [[NSUserDefaults standardUserDefaults ] setValue:env forKey:SBEnvironmentSwitchKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _enviromentType = env.integerValue;
#endif
    }
    return _enviromentType;
}

+ (void)registENV:(id<SBEnviromentProtocol>)maker {
    _envModel = [maker makeENV:[self enviromentType]];
}

+ (id)envModel {
    return _envModel;}



@end
