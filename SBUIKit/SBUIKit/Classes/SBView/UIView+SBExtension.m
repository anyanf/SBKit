//
//  UIView+SBExtension.m
//  Masonry
//
//  Created by 安康 on 2019/9/24.
//

#import "UIView+SBExtension.h"


@implementation UIView (SBExtension)


- (void)setSb_x:(CGFloat)sb_x {
    CGRect frame = self.frame;
    frame.origin.x = sb_x;
    self.frame = frame;
}

- (CGFloat)sb_x {
    return self.frame.origin.x;
}

- (void)setSb_y:(CGFloat)sb_y {
    CGRect frame = self.frame;
    frame.origin.y = sb_y;
    self.frame = frame;
}

- (CGFloat)sb_y {
    return self.frame.origin.y;
}

- (void)setSb_w:(CGFloat)sb_w {
    CGRect frame = self.frame;
    frame.size.width = sb_w;
    self.frame = frame;
}

- (CGFloat)sb_w {
    return self.frame.size.width;
}

- (void)setSb_h:(CGFloat)sb_h {
    CGRect frame = self.frame;
    frame.size.height = sb_h;
    self.frame = frame;
}

- (CGFloat)sb_h {
    return self.frame.size.height;
}

- (void)setSb_size:(CGSize)sb_size {
    CGRect frame = self.frame;
    frame.size = sb_size;
    self.frame = frame;
}

- (CGSize)sb_size {
    return self.frame.size;
}

- (void)setSb_origin:(CGPoint)sb_origin {
    CGRect frame = self.frame;
    frame.origin = sb_origin;
    self.frame = frame;
}

- (CGPoint)sb_origin {
    return self.frame.origin;
}

- (CGFloat)sb_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setSb_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)sb_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setSb_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)sb_centerX {
    return self.center.x;
}

- (void)setSb_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)sb_centerY {
    return self.center.y;
}

- (void)setSb_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}




- (CGFloat)safeBottomInset {
    
    // 只有iOS11以上才有全面屏
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}


@end
