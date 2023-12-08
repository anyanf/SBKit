//
//  SBPresentationController.m
//  AFNetworking
//
//  Created by ankang on 2023/12/8.
//

#import "SBPresentationController.h"

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
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewDidTap)];
        [self.containerView addGestureRecognizer:tap];
    }    
}


- (void)containerViewDidTap {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
