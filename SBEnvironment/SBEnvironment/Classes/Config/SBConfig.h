//
//  SBConfig.h
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBConfig : NSObject

+ (instancetype)sharedInstance;

+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol;

+ (id)handlerForProtocol:(Protocol *)protocol;

@end

NS_ASSUME_NONNULL_END
