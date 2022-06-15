//
//  SBImageView.m
//  Pods
//
//  Created by 安康 on 2019/10/5.
//

#import "SBImageView.h"

@interface SBImageView ()

@property (nonatomic, strong) UITapGestureRecognizer *ges;

@property (nonatomic, copy) void(^eventBlock)(UIPanGestureRecognizer *gestureRecognizer) ;

@end

@implementation SBImageView

+ (instancetype)createWithFrame:(CGRect)frame {
    SBImageView *imgv = [[self alloc] initWithFrame:frame];
    return imgv;
}

+ (instancetype)createWithFrame:(CGRect)frame image:(UIImage *)img {
    SBImageView *imgv = [[self alloc] initWithFrame:frame];
    imgv.image = img;
    return imgv;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setCommonAttribute];
    }
    return self;
}

- (void)addEvent:(void(^)(UIPanGestureRecognizer *gestureRecognizer))eventBlock {
    
    self.eventBlock = eventBlock;

    // 打开UI交互
    self.userInteractionEnabled = YES;

    // 设置手势
    if (!self.ges) {
        self.ges = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(clicked:)];
        [self addGestureRecognizer:self.ges];
    }
}

- (void)clicked:(UIPanGestureRecognizer *)gestureRecognizer {
    if (self.eventBlock) {
        self.eventBlock(gestureRecognizer);
    }
}

// 设置公共属性
- (void)setCommonAttribute {
    self.clipsToBounds = YES;
}

- (void)drawRoundImageToImageView
{
//    //设置图片上下文的大小
//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 1.0);
//
//    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width]addClip];
//
//    [self drawRect:self.bounds];
//
//    self.image = UIGraphicsGetImageFromCurrentImageContext();
//
//    UIGraphicsEndImageContext();
    
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.masksToBounds = YES;
}


@end
