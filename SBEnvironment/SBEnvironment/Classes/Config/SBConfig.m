//
//  SBConfig.m
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//

#import "SBConfig.h"

#import "SBConfigAssert.h"

@interface SBConfig ()

@property (nonatomic, strong) NSMutableDictionary *handlersDic;


@end

@implementation SBConfig

+ (instancetype)sharedInstance {
    static SBConfig* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.handlersDic = [NSMutableDictionary dictionary];
    });
    return _sharedInstance;
}


+ (void)registerHandler:(id)handler withProtocol:(Protocol *)protocol {
    SBConfigAssert(handler && protocol, @"Fail to register the handler, please check if the parameters are nil！");
    
    SBConfig *constantInfo = [self sharedInstance];
    @synchronized(self) {
        [constantInfo.handlersDic setObject:handler
                                     forKey:NSStringFromProtocol(protocol)];
    }
    
}


+ (id)handlerForProtocol:(Protocol *)protocol {
   
    SBConfigAssert(protocol, @"protocol can't be nil");
    
    SBConfig *constantInfo = [self sharedInstance];
    id handler;
    @synchronized(self) {
        handler = [constantInfo.handlersDic objectForKey:NSStringFromProtocol(protocol)];
    }
    return handler;
}


@end
