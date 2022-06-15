//
//  SBSelectENVFloatView.m
//  SBEnvironment
//
//  Created by 安康 on 2019/10/4.
//

#import "SBSelectENVFloatView.h"

@interface SBSelectENVFloatView ()


@property (nonatomic, strong) SBLabel *label;


@end

@implementation SBSelectENVFloatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColor.systemGrayColor;
        
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        
        // 初始化
        _label = [SBLabel createWithFrame:self.frame
                                     text:@"切换环境"
                                textColor:UIColor.systemGreenColor
                                     font:[UIFont boldSystemFontOfSize:18]
                            textAlignment:NSTextAlignmentCenter];
        _label.numberOfLines = 2;
        _label.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(clicked:)];
        [_label addGestureRecognizer:ges];
        
        [self addSubview:_label];
        
        // 拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(panAction:)];
        [_label addGestureRecognizer:pan];
    }
    return self;
}


#pragma 小球点击事件

- (void)clicked:(id)sender {
    if (self.ballClickedBlock) {
        self.ballClickedBlock();
    }
}

#pragma mark  拖拽手势方法

- (void)panAction:(UIPanGestureRecognizer *)gestureRecognizer {
    //  获取通过的点
    CGPoint p = [gestureRecognizer translationInView:self];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        // 开始滑动
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        // 坐标改变中
        if (self.frame.origin.x + p.x <= 0 ||
            self.frame.origin.x + p.x >= SB_SCREEN_W_K - self.frame.size.width) {
            if (self.frame.origin.y + p.y <= SB_SAFE_NAV_TOP_INSET ||
                self.frame.origin.y + p.y >= SB_SCREEN_H_K - SB_SAFE_TAB_BOTTOM_INSET - self.frame.size.height) {
                [self setTransform:CGAffineTransformTranslate([self transform], 0, 0)];
            } else {
                [self setTransform:CGAffineTransformTranslate([self transform], 0, p.y)];
                [gestureRecognizer setTranslation:CGPointZero inView:self];
            }
        } else if (self.frame.origin.y + p.y <= SB_SAFE_NAV_TOP_INSET ||
                   self.frame.origin.y + p.y >= SB_SCREEN_H_K - SB_SAFE_TAB_BOTTOM_INSET - self.frame.size.height) {
            if (self.frame.origin.x + p.x <= 0 ||
                self.frame.origin.x + p.x >= SB_SCREEN_W_K - self.frame.size.width) {
                [self setTransform:CGAffineTransformTranslate([self transform], 0, 0)];
            } else {
                [self setTransform:CGAffineTransformTranslate([self transform], p.x, 0)];
                [gestureRecognizer setTranslation:CGPointZero inView:self];
            }
        } else {
            [self setTransform:CGAffineTransformTranslate([self transform], p.x, p.y)];
            [gestureRecognizer setTranslation:CGPointZero inView:self];
        }
        
    } else  {
        // 手离开屏幕
        if (self.frame.origin.x >= SB_SCREEN_W_K / 2.0 - self.frame.size.width / 2) {
            [UIView animateWithDuration:.3f animations:^{
                self.frame = CGRectMake(SB_SCREEN_W_K - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            }];
        } else {
            [UIView animateWithDuration:.3f animations:^{
                self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
            }];
        }
    }
}



@end
