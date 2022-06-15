//
//  SBControl.m
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import "SBControl.h"

@interface SBControl ()

@property (nonatomic, copy) void(^eventBlock)(SBControl *control, UIControlEvents controlEvents) ;


@end


@implementation SBControl


+ (instancetype)createWithFrame:(CGRect)frame
                     eventBlock:(void(^)(SBControl *control, UIControlEvents controlEvents))eventBlock {
    
    SBControl *control = [[self alloc] initWithFrame:frame];
    [control addTarget:control action:@selector(touchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    control.eventBlock = eventBlock;
    
    return control;
}

- (void)addEvent:(void(^)(SBControl *control, UIControlEvents controlEvents))eventBlock {
    self.eventBlock = eventBlock;
    
    NSArray<NSString *> *actions = [self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
    
    for (NSString *actionStr in actions) {
        // 如果添加过就不添加了
        if ([actionStr isEqualToString:NSStringFromSelector(@selector(touchUpInsideEvent:))]) {
            return;
        }
    }
    
    [self addTarget:self action:@selector(touchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)touchUpInsideEvent:(SBControl *)sender {
    if (self.eventBlock) {
        self.eventBlock(self, UIControlEventTouchUpInside);
    }
}



@end
