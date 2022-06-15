//
//  SBSwitchEnviroment.h
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


///根据环境返回对应的url
#define SB_Enviroment_URL_K(product,pre,uat)                         \
NSString *strHost = product;                                         \
SB_Enviroment_Mode enviroment = [SBSwitchEnviroment enviromentType]; \
if ( enviroment == SB_Enviroment_PRE ) {                             \
    strHost = pre;                                                   \
} else if( enviroment == SB_Enviroment_UAT ) {                       \
    strHost = uat;                                                   \
}                                                                    \
return strHost;                                                      \


/** 环境key */
extern NSString *const SBEnvironmentSwitchKey;

/** 环境的类型 */
typedef NS_ENUM(NSInteger, SB_Enviroment_Mode) {
    // 未初始化
    SB_Enviroment_UnInit,
    // 生产环境
    SB_Enviroment_Product,
    // 预生产
    SB_Enviroment_PRE,
    // 测试
    SB_Enviroment_UAT
};

@protocol SBEnviromentProtocol <NSObject>

- (id)makeENV:(SB_Enviroment_Mode)envMode;

@end


@interface SBSwitchEnviroment : NSObject

@property(class, nonatomic, readonly,assign) SB_Enviroment_Mode enviromentType;

@property(class, nonatomic, readonly, strong) id envModel;


+ (void)registENV:(id<SBEnviromentProtocol>)maker;

@end

NS_ASSUME_NONNULL_END
