//
//  SBRouter.h
//  Masonry
//
//  Created by 安康 on 2019/9/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/** 从参数中获取导航控制器 */ 
extern NSString *const SBRouterParamsVCKey;

#define SBRouterRegisterBegin() + (void)load {
#define SBRouterRegisterEnd() }

@interface SBRouter : NSObject


/**
 接口注册方法
 通过 url 的方式，调用 handler 中的逻辑
 提供接口方注册，在handle中实现被调用的实现逻辑

 @param routePattern 规则：/类名/自定义名称
 eg.: /OrderDetails/openvc
 
 @param handlerBlock 处理open调用的逻辑
 */
+ (void)registerRoute:(NSString *)routePattern handler:(BOOL (^)(NSDictionary<NSString *, id> * parameters))handlerBlock;

+ (BOOL)sb_openRouteURL:(NSString *)url
         viewController:(UIViewController *)vc
  withParametersBuilder:(void(^)(NSMutableDictionary<NSString *,id> * parameters))builder;

+ (BOOL)openRouteURL:(NSString *)url withParameters:(nullable NSDictionary<NSString *, id> *)parameters;
+ (BOOL)openRouteURL:(NSString *)url withParameters:(nullable NSDictionary<NSString *, id> *)parameters viewController:(nullable UIViewController *)vc;

/** 获取openRouteURL传过来的vc */
+ (UIViewController *)getParamstVC:(NSDictionary<NSString *,id> *)parameters;

@end

NS_ASSUME_NONNULL_END
