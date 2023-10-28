//
//  UIControl+SBExtension.m
//  SBUIKit
//
//  Created by AnKang on 2023/10/28.
//

#import "UIControl+SBExtension.h"

#import <objc/runtime.h>

@implementation UIControl (SBExtension)


- (UIEdgeInsets)hitEdgeInsets {
    NSValue *hitEdgeInsetsValue = objc_getAssociatedObject(self, @selector(hitEdgeInsets));
    return [hitEdgeInsetsValue UIEdgeInsetsValue];
}

- (void)setHitEdgeInsets:(UIEdgeInsets)hitEdgeInsets {
    NSValue *hitEdgeInsetsValue = [NSValue valueWithUIEdgeInsets:hitEdgeInsets];
    objc_setAssociatedObject(self, @selector(hitEdgeInsets), hitEdgeInsetsValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SBControlEventBlock)touchUpInsideEvent {
    SBControlEventBlock touchUpInsideEvent = objc_getAssociatedObject(self, @selector(touchUpInsideEvent));
    return touchUpInsideEvent;
}

- (void)setTouchUpInsideEvent:(SBControlEventBlock)touchUpInsideEvent {
    objc_setAssociatedObject(self, @selector(touchUpInsideEvent), touchUpInsideEvent, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)addTouchUpInsideEvent:(SBControlEventBlock)touchUpInsideEvent {
    self.touchUpInsideEvent = touchUpInsideEvent;
    
    NSArray<NSString *> *actions = [self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
    
    for (NSString *actionStr in actions) {
        // 如果添加过就不添加了
        if ([actionStr isEqualToString:NSStringFromSelector(@selector(touchUpInsideEvent:))]) {
            return;
        }
    }
    
    [self addTarget:self action:@selector(touchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchUpInsideEvent:(UIControl *)sender {
    if (self.touchUpInsideEvent) {
        self.touchUpInsideEvent(self, UIControlEventTouchUpInside);
    }
}


#pragma mark - override super method
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    //如果 button 边界值无变化  失效 隐藏 或者透明 直接返回
    if (UIEdgeInsetsEqualToEdgeInsets(self.hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden || self.alpha == 0 ) {
        return [super pointInside:point withEvent:event];
    } else {
        CGRect relativeFrame = self.bounds;
        CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitEdgeInsets);
        return CGRectContainsPoint(hitFrame, point);
    }
}

@end
