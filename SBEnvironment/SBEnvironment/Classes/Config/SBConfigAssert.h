//
//  SBConfigAssert.h
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

void SBAssertInternal(NSString *func, NSString *file, int lineNum, NSString *format, ...);

#if DEBUG
#define SBConfigAssert(condition, ...) \
do{\
if(!(condition)){\
SBAssertInternal(@(__func__), @(__FILE__), __LINE__, __VA_ARGS__);\
}\
}while(0)
#else
#define SBConfigAssert(condition, ...)
#endif


@interface SBConfigAssert : NSObject

@end

NS_ASSUME_NONNULL_END
