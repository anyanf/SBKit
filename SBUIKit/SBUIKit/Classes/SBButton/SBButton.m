//
//  SBButton.m
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import "SBButton.h"


@interface SBButton ()

@property (nonatomic, copy) SBButtonEventBlock eventBlock;

@end


@implementation SBButton

+ (instancetype)createWithFrame:(CGRect)frame {
    SBButton *button = [[self alloc] initWithFrame:frame];
    return button;
}

+ (instancetype)createWithFrame:(CGRect)frame
                     eventBlock:(SBButtonEventBlock)eventBlock {
    
    SBButton *button = [[self alloc] initWithFrame:frame eventBlock:eventBlock];
        
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
                   eventBlock:(SBButtonEventBlock)eventBlock {
    self = [self initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(touchUpInsideEvent:) forControlEvents:UIControlEventTouchUpInside];
        _eventBlock = eventBlock;
    }
    return self;
}

- (void)setTitle:(NSString *)titleStr
      titleColor:(UIColor *)titleColor
        forState:(UIControlState)state {
        [self setTitle:titleStr forState:state];
        [self setTitleColor:titleColor forState:state];
}

- (void)setTitle:(NSString *)titleStr
      titleColor:(UIColor *)titleColor
           image:(UIImage *)image
    backgroundImage:(UIImage *)backgroundImage
            forState:(UIControlState)state {
    
    [self setTitle:titleStr forState:state];
    [self setTitleColor:titleColor forState:state];
    [self setImage:image forState:state];
    [self setBackgroundImage:backgroundImage forState:state];
}

- (void)touchUpInsideEvent:(SBButton *)sender {
    if (self.eventBlock) {
        self.eventBlock(self, UIControlEventTouchUpInside);
    }
}

- (void)setImageForALLState:(nullable UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateDisabled];
    [self setImage:image forState:UIControlStateSelected];

}


- (void)setBackgroundImageForALLState:(nullable UIImage *)image {
    [self setBackgroundImage:image forState:UIControlStateNormal];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
    [self setBackgroundImage:image forState:UIControlStateDisabled];
    [self setBackgroundImage:image forState:UIControlStateSelected];
}

- (void)setBorder:(CGFloat)width color:(UIColor *)color redius:(CGFloat)radius {
    self.layer.masksToBounds = YES; //允许绘制
    self.layer.cornerRadius = radius;//边框弧度
    self.layer.borderColor = color.CGColor; //边框颜色
    self.layer.borderWidth = width; //边框的宽度
}

- (void)addEvent:(SBButtonEventBlock)eventBlock {
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
