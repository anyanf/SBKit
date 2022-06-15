//
//  SBConfigAssert.m
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//

#import "SBConfigAssert.h"

@implementation SBConfigAssert

void SBAssertInternal(NSString *func, NSString *file, int lineNum, NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [[NSAssertionHandler currentHandler] handleFailureInFunction:func file:file lineNumber:lineNum description:format, message];
}


@end
