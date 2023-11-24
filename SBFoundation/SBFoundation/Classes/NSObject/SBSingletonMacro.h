//
//  SBSingletonMacro.h
//  Pods
//
//  Created by ankang on 2023/11/24.
//

#ifndef SBSingletonMacro_h
#define SBSingletonMacro_h


// .h文件的实现
#define SB_SINGLETON_H(methodName) + (instancetype)shared##methodName;

// .m文件的实现
#if __has_feature(objc_arc) // 是ARC
#define SB_SINGLETON_M(methodName) \
static id _instace = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
if (_instace == nil) { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
} \
return _instace; \
} \
\
- (id)init \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super init]; \
}); \
return _instace; \
} \
\
+ (instancetype)shared##methodName \
{ \
return [[self alloc] init]; \
} \
- (id)copyWithZone:(struct _NSZone *)zone \
{ \
return _instace; \
} \
\
- (id)mutableCopyWithZone:(struct _NSZone *)zone \
{ \
return _instace; \
}

#else // 不是ARC

#define SB_SINGLETON_M(methodName) \
static id _instace = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
if (_instace == nil) { \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
} \
return _instace; \
} \
\
- (id)init \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super init]; \
}); \
return _instace; \
} \
\
+ (instancetype)shared##methodName \
{ \
return [[self alloc] init]; \
} \
\
- (oneway void)release \
{ \
\
} \
\
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return 1; \
} \
- (id)copyWithZone:(struct _NSZone *)zone \
{ \
    return _instace; \
} \
 \
- (id)mutableCopyWithZone:(struct _NSZone *)zone \
{ \
    return _instace; \
}

#endif



#endif /* SBSingletonMacro_h */
