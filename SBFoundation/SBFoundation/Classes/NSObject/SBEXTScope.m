//
//  EXTScope.m
//  extobjc
//
//  Created by Justin Spahr-Summers on 2011-05-04.
//  Copyright (C) 2012 Justin Spahr-Summers.
//  Released under the MIT license.
//

#import "SBEXTScope.h"

void sb_ext_executeCleanupBlock (__strong ext_cleanupBlock_t *block) {
    (*block)();
}

