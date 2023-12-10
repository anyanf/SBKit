//
//  SBPresentationController.m
//  AFNetworking
//
//  Created by ankang on 2023/12/8.
//

#import "SBPresentationController.h"

@interface SBPresentationController () <UIGestureRecognizerDelegate>

@end

@implementation SBPresentationController


- (CGRect)frameOfPresentedViewInContainerView {
    
    if (CGRectEqualToRect(self.sb_presentedViewFrame, CGRectZero)) {
        return self.containerView.bounds;
    }
    
    return self.sb_presentedViewFrame;
}

- (void)containerViewWillLayoutSubviews {
    
    UIColor *containerViewBackgroundColor = self.sb_containerViewBackgroundColor;
    if (!containerViewBackgroundColor) {
        containerViewBackgroundColor = [UIColor.grayColor colorWithAlphaComponent:0.3];
    }
    
    self.containerView.backgroundColor = containerViewBackgroundColor;
    self.presentedView.frame = self.frameOfPresentedViewInContainerView;
    
    BOOL hasAddTap = NO;
    for (UIGestureRecognizer *gesture in self.containerView.gestureRecognizers) {
        if ([gesture isKindOfClass:UITapGestureRecognizer.class]) {
            hasAddTap = YES;
            break;
        }
    }
    if (!hasAddTap) {
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewDidTap)];
        tapGesture.delegate = self; // 设置代理
        [self.containerView addGestureRecognizer:tapGesture];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (!self.presentedView) {
        return YES;
    }
    
    CGPoint location = [touch locationInView:self.presentedView];
    
    // 如果点击位置不在子视图上，则执行手势
    return ![self.presentedView pointInside:location withEvent:nil];
}

- (void)containerViewDidTap {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
