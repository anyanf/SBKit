//
//  SBRouter.m
//  Masonry
//
//  Created by 安康 on 2019/9/11.
//

#import "SBRouter.h"

#import "JLRoutes.h"
#import "JLRRouteDefinition.h"

#import "SBFoundation.h"


static NSString *const SBGlobalRouteKey = @"SBGlobalRouteKey";
static NSString *const SBGlobalRouteHost = @"SBGlobalRouteHost";


NSString *const SBRouterParamsVCKey = @"SBRouterParamsVCKey";

@interface SBRouteDefinition : JLRRouteDefinition

@end


@implementation SBRouter


+ (void)registerRoute:(NSString *)routePattern handler:(BOOL (^)(NSDictionary<NSString *,id> *))handlerBlock {
    NSAssert([routePattern rangeOfString:@"://"].location == NSNotFound, @"不需要host");
    SBRouteDefinition *definition = [[SBRouteDefinition alloc] initWithPattern:routePattern priority:0 handlerBlock:handlerBlock];
    [[JLRoutes routesForScheme:SBGlobalRouteKey] addRoute:definition];
}

+ (BOOL)openRouteURL:(NSString *)url withParameters:(NSDictionary<NSString *,id> *)parameters {
    return [self openRouteURL:url withParameters:parameters viewController:nil];
}

+ (BOOL)openRouteURL:(NSString *)url withParameters:(NSDictionary<NSString *,id> *)parameters viewController:(UIViewController *)vc {
    NSURL *u = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", SBGlobalRouteHost, url]];
    if (vc && [vc isKindOfClass:[UIViewController class]]) {
        NSMutableDictionary *tmpMDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
        [tmpMDict setObject:vc forKey:SBRouterParamsVCKey];
        parameters = [tmpMDict copy];
    }
    return [[JLRoutes routesForScheme:SBGlobalRouteKey] routeURL:u withParameters:parameters];
}

+ (BOOL)sb_openRouteURL:(NSString *)url
         viewController:(UIViewController *)vc
  withParametersBuilder:(void(^)(NSMutableDictionary<NSString *,id> * parameters))builder {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (builder) {
        builder(parameters);
    }
    
    return [self openRouteURL:url withParameters:parameters viewController:vc];
}

+ (UIViewController *)getParamstVC:(NSDictionary<NSString *,id> *)parameters {
    
    if (SB_DIC_IS_VALID_K(parameters)) {
        return [parameters sb_objectForKey:SBRouterParamsVCKey];
    } else {
        return nil;
    }
}

@end


@implementation SBRouteDefinition

- (void)didBecomeRegisteredForScheme:(NSString *)scheme {
    
}

@end
