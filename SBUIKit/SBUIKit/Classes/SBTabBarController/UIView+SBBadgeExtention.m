//
//  UIView+SBBadgeExtention.m
//  Masonry
//
//  Created by 安康 on 2019/9/27.
//

#import "UIView+SBBadgeExtention.h"

#import <objc/runtime.h>

#import "CAAnimation+SBBadgeExtention.h"


#define kSBBadgeDefaultFont                ([UIFont boldSystemFontOfSize:9])

#define kSBBadgeDefaultMaximumBadgeNumber                     99
#define kSBBadgeDefaultMargin                (8.0)


static const CGFloat kSBBadgeDefaultRedDotRadius = 4.f;

@implementation UIView (SBBadgeExtention)

#pragma mark -- public methods
/**
 *  show badge with red dot style and SBBadgeAnimationTypeNone by default.
 */
- (void)sb_showBadge {
    [self sb_showBadgeValue:@"" animationType:SBBadgeAnimationTypeNone];
}

- (void)sb_showBadgeValue:(NSString *)value animationType:(SBBadgeAnimationType)animationType {
    [[[self sb_badge] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.sb_badgeAnimationType = animationType;
    [self sb_showBadgeWithValue:value];

    if (animationType != SBBadgeAnimationTypeNone) {
        [self sb_beginAnimation];
    }
}

- (void)sb_showBadgeValue:(NSString *)value {
    [self sb_showBadgeValue:value animationType:SBBadgeAnimationTypeNone];
}

#pragma mark -- private methods
- (void)sb_showBadgeWithValue:(NSString *)value {
    if (!value) {
        return;
    }
    NSCharacterSet *numberSet = [NSCharacterSet decimalDigitCharacterSet];
    NSString *trimmedString = [value stringByTrimmingCharactersInSet:numberSet];
    BOOL isNumber = NO;
    if ((trimmedString.length == 0) && (value.length > 0)) {
        isNumber = YES;
    }
    if (isNumber) {
        [self sb_showNumberBadgeWithValue:[value integerValue]];
        return;
    }

    if ([value isEqualToString:@""]) {
        [self sb_showRedDotBadge];
        return;
    }
    if ([value isEqualToString:@"new"] || [value isEqualToString:@"NEW"] ) {
        [self sb_showNewBadge:value];
        return;
    }
    [self sb_showTextBadge:value];
}

/**
 *  clear badge
 */
- (void)sb_clearBadge {
    self.sb_badge.hidden = YES;
}

- (BOOL)sb_isShowBadge {
    return (self.sb_badge && !self.sb_badge.hidden );
}

/**
 *  make bage(if existing) not hiden
 */
- (void)sb_resumeBadge {
    if (self.sb_isPauseBadge) {
        self.sb_badge.hidden = NO;
    }
}

- (BOOL)sb_isPauseBadge {
    return (self.sb_badge && self.sb_badge.hidden == YES);
}

#pragma mark -- private methods

- (void)sb_addMargin {
    CGRect frame = self.sb_badge.frame;
    frame.size.width += self.sb_badgeMargin;
    frame.size.height += self.sb_badgeMargin;
    if(CGRectGetWidth(frame) < CGRectGetHeight(frame)) {
        frame.size.width = CGRectGetHeight(frame);
    }
    self.sb_badge.frame = frame;
}

- (void)sb_showRedDotBadge {
    [self sb_badgeInit];
    //if badge has been displayed and, in addition, is was not red dot style, we must update UI.
    if (self.sb_badge.tag != SBBadgeStyleRedDot) {
        self.sb_badge.text = @"";
        self.sb_badge.tag = SBBadgeStyleRedDot;
        [self sb_resetRedDotBadgeFrame];
        self.sb_badge.layer.cornerRadius = CGRectGetWidth(self.sb_badge.frame) / 2;
    }
    self.sb_badge.hidden = NO;
}

- (void)sb_showNewBadge:(NSString *)value {
    CGSize size = [value sizeWithAttributes:
                   @{NSFontAttributeName:
                         self.sb_badgeFont}];
    float labelHeight = ceilf(size.height)+ self.sb_badgeMargin;
    [self sb_setBadgeCornerRadius:labelHeight/3];
    [self sb_showTextBadge:value];
}

- (void)sb_showTextBadge:(NSString *)value {
    if (value == 0 || !value ||value.length == 0) {
        self.sb_badge.hidden = YES;
        return;
    }
    [self sb_badgeInit];
    self.sb_badge.tag = SBBadgeStyleOther;
    self.sb_badge.text = value;
    self.sb_badge.font = self.sb_badgeFont;
    [self sb_adjustLabelWidth:self.sb_badge];
    [self sb_addMargin];
    self.sb_badge.center = CGPointMake(CGRectGetWidth(self.frame) + 2 + self.sb_badgeCenterOffset.x, self.sb_badgeCenterOffset.y);
    //FIXME:  to delete
    self.sb_badge.layer.cornerRadius = (self.sb_badgeCornerRadius !=0 ) ? self.sb_badgeCornerRadius : CGRectGetHeight(self.sb_badge.frame) / 2;
    self.sb_badge.hidden = NO;
}
    
- (void)sb_showNumberBadgeWithValue:(NSInteger)value {
    if (value <= 0) {
        self.sb_badge.hidden = YES;
        return;
    }
    [self sb_badgeInit];
    self.sb_badge.hidden = (value == 0);
    self.sb_badge.tag = SBBadgeStyleNumber;
    NSString *text = (value > self.sb_badgeMaximumBadgeNumber ?
                      [NSString stringWithFormat:@"%@+", @(self.sb_badgeMaximumBadgeNumber)] :
                      [NSString stringWithFormat:@"%@", @(value)]);
    [self sb_showTextBadge:text];
}

//lazy loading
- (void)sb_badgeInit {
    if (self.sb_badgeBackgroundColor == nil) {
        self.sb_badgeBackgroundColor = [UIColor redColor];
    }
    if (self.sb_badgeTextColor == nil) {
        self.sb_badgeTextColor = [UIColor whiteColor];
    }
    
    if (!self.sb_badge) {
        self.sb_badge = [[UILabel alloc] init];
        [self sb_resetRedDotBadgeFrame];
        self.sb_badge.textAlignment = NSTextAlignmentCenter;
        self.sb_badge.backgroundColor = self.sb_badgeBackgroundColor;
        self.sb_badge.textColor = self.sb_badgeTextColor;
        self.sb_badge.text = @"";
        self.sb_badge.layer.cornerRadius = CGRectGetWidth(self.sb_badge.frame) / 2;
        self.sb_badge.layer.masksToBounds = YES;//very important
        self.sb_badge.hidden = YES;
        self.sb_badge.layer.zPosition = MAXFLOAT;
        [self addSubview:self.sb_badge];
        [self bringSubviewToFront:self.sb_badge];
    }
}

- (void)sb_resetRedDotBadgeFrame {
    CGFloat redotWidth = kSBBadgeDefaultRedDotRadius *2;
    if (self.sb_badgeRadius) {
        redotWidth = self.sb_badgeRadius * 2;
    }
    CGRect frame = CGRectMake(CGRectGetWidth(self.frame), -redotWidth, redotWidth, redotWidth);
    self.sb_badge.frame = frame;
    self.sb_badge.center = CGPointMake(CGRectGetWidth(self.frame) + 2 + self.sb_badgeCenterOffset.x, self.sb_badgeCenterOffset.y);
}

#pragma mark --  other private methods
- (void)sb_adjustLabelWidth:(UILabel *)label {
    CGSize labelsize = [self sb_getLabelSize:label];
    CGRect frame = label.frame;
    frame.size = CGSizeMake(ceilf(labelsize.width), ceilf(labelsize.height));
    [label setFrame:frame];
}

- (CGSize)sb_getLabelSize:(UILabel *)label {
    [label setNumberOfLines:0];
    NSString *s = label.text;
    UIFont *font = label.font;
    CGSize size = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) ,CGFLOAT_MAX);
    CGSize labelsize;
    
    if (![s respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    } else {
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        labelsize = [s boundingRectWithSize:size
                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                 attributes:@{ NSFontAttributeName:font, NSParagraphStyleAttributeName : style}
                                    context:nil].size;
    }
    return labelsize;
}

#pragma mark -- animation

//if u want to add badge animation type, follow steps bellow:
//1. go to definition of SBBadgeAnimationType and add new type
//2. go to category of CAAnimation+SBBadgeExtention to add new animation interface
//3. call that new interface here
- (void)sb_beginAnimation {
    switch(self.sb_badgeAnimationType) {
        case SBBadgeAnimationTypeBreathe:
            [self.sb_badge.layer addAnimation:[CAAnimation sb_opacityForever_Animation:1.4]
                                    forKey:SBBadgeBreatheAnimationKey];
            break;
        case SBBadgeAnimationTypeShake:
            [self.sb_badge.layer addAnimation:[CAAnimation sb_shake_AnimationRepeatTimes:CGFLOAT_MAX
                                                                          durTimes:1
                                                                            forObj:self.sb_badge.layer]
                                    forKey:SBBadgeShakeAnimationKey];
            break;
        case SBBadgeAnimationTypeScale:
            [self.sb_badge.layer addAnimation:[CAAnimation sb_scaleFrom:1.4
                                                          toScale:0.6
                                                         durTimes:1
                                                              rep:MAXFLOAT]
                                    forKey:SBBadgeScaleAnimationKey];
            break;
        case SBBadgeAnimationTypeBounce:
            [self.sb_badge.layer addAnimation:[CAAnimation sb_bounce_AnimationRepeatTimes:CGFLOAT_MAX
                                                                          durTimes:1
                                                                            forObj:self.sb_badge.layer]
                                    forKey:SBBadgeBounceAnimationKey];
            break;
        case SBBadgeAnimationTypeNone:
        default:
            break;
    }
}


- (void)sb_removeAnimation {
    if (self.sb_badge) {
        [self.sb_badge.layer removeAllAnimations];
    }
}

#pragma mark -- setter/getter

- (UILabel *)sb_badge {
    return objc_getAssociatedObject(self, @selector(sb_badge));
}

- (void)sb_setBadge:(UILabel *)label {
    objc_setAssociatedObject(self, @selector(sb_badge), label, OBJC_ASSOCIATION_RETAIN);
}

- (UIFont *)sb_badgeFont {
    id font = objc_getAssociatedObject(self, @selector(sb_badgeFont));
    return font ?: kSBBadgeDefaultFont;
}

- (void)sb_setBadgeFont:(UIFont *)badgeFont {
    objc_setAssociatedObject(self, @selector(sb_badgeFont), badgeFont, OBJC_ASSOCIATION_RETAIN);
    if (!self.sb_badge) {
        [self sb_badgeInit];
    }
    self.sb_badge.font = badgeFont;
}

- (UIColor *)sb_badgeBackgroundColor {
    return objc_getAssociatedObject(self, @selector(sb_badgeBackgroundColor));
}

- (void)sb_setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    objc_setAssociatedObject(self, @selector(sb_badgeBackgroundColor), badgeBackgroundColor, OBJC_ASSOCIATION_RETAIN);
    if (!self.sb_badge) {
        [self sb_badgeInit];
    }
    self.sb_badge.backgroundColor = badgeBackgroundColor;
}

- (UIColor *)sb_badgeTextColor {
    return objc_getAssociatedObject(self, @selector(sb_badgeTextColor));
}

- (void)sb_setBadgeTextColor:(UIColor *)badgeTextColor {
    objc_setAssociatedObject(self, @selector(sb_badgeTextColor), badgeTextColor, OBJC_ASSOCIATION_RETAIN);
    if (!self.sb_badge) {
        [self sb_badgeInit];
    }
    self.sb_badge.textColor = badgeTextColor;
}

- (SBBadgeAnimationType)sb_badgeAnimationType {
    id obj = objc_getAssociatedObject(self, @selector(sb_badgeAnimationType));
    if(obj != nil && [obj isKindOfClass:[NSNumber class]]) {
        return [obj integerValue];
    }
        return SBBadgeAnimationTypeNone;
}

- (void)sb_setBadgeAnimationType:(SBBadgeAnimationType)animationType {
    NSNumber *numObj = @(animationType);
    objc_setAssociatedObject(self, @selector(sb_badgeAnimationType), numObj, OBJC_ASSOCIATION_RETAIN);
    if (!self.sb_badge) {
        [self sb_badgeInit];
    }
    [self sb_removeAnimation];
    [self sb_beginAnimation];
}

- (CGRect)sb_badgeFrame {
    id obj = objc_getAssociatedObject(self, @selector(sb_badgeFrame));
    if (obj != nil && [obj isKindOfClass:[NSDictionary class]] && [obj count] == 4) {
        CGFloat x = [obj[@"x"] floatValue];
        CGFloat y = [obj[@"y"] floatValue];
        CGFloat width = [obj[@"width"] floatValue];
        CGFloat height = [obj[@"height"] floatValue];
        return  CGRectMake(x, y, width, height);
    }
        return CGRectZero;
}

- (void)sb_setBadgeFrame:(CGRect)badgeFrame {
    NSDictionary *frameInfo = @{@"x" : @(badgeFrame.origin.x), @"y" : @(badgeFrame.origin.y),
                                @"width" : @(badgeFrame.size.width), @"height" : @(badgeFrame.size.height)};
    objc_setAssociatedObject(self, @selector(sb_badgeFrame), frameInfo, OBJC_ASSOCIATION_RETAIN);
    if (!self.sb_badge) {
        [self sb_badgeInit];
    }
    self.sb_badge.frame = badgeFrame;
}


- (CGFloat)sb_badgeCornerRadius {
    NSNumber *badgeCornerRadiusObject = objc_getAssociatedObject(self, @selector(sb_badgeCornerRadius));
    return [badgeCornerRadiusObject floatValue];
}

- (void)sb_setBadgeCornerRadius:(CGFloat)badgeCornerRadius {
    NSNumber *badgeCornerRadiusObject = @(badgeCornerRadius);
    objc_setAssociatedObject(self, @selector(sb_badgeCornerRadius), badgeCornerRadiusObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)sb_badgeCenterOffset {
    id obj = objc_getAssociatedObject(self, @selector(sb_badgeCenterOffset));
    if (obj != nil && [obj isKindOfClass:[NSDictionary class]] && [obj count] == 2) {
        CGFloat x = [obj[@"x"] floatValue];
        CGFloat y = [obj[@"y"] floatValue];
        return CGPointMake(x, y);
    }
        return CGPointZero;
}

- (void)sb_setBadgeCenterOffset:(CGPoint)badgeCenterOff {
    NSDictionary *cenerInfo = @{@"x" : @(badgeCenterOff.x), @"y" : @(badgeCenterOff.y)};
    objc_setAssociatedObject(self, @selector(sb_badgeCenterOffset), cenerInfo, OBJC_ASSOCIATION_RETAIN);
    if (!self.sb_badge) {
        [self sb_badgeInit];
    }
    self.sb_badge.center = CGPointMake(CGRectGetWidth(self.frame) + 2 + badgeCenterOff.x, badgeCenterOff.y);
}

//badgeRadiusKey

- (void)sb_setBadgeRadius:(CGFloat)badgeRadius {
    objc_setAssociatedObject(self, @selector(sb_badgeRadius), [NSNumber numberWithFloat:badgeRadius], OBJC_ASSOCIATION_RETAIN);
    if (!self.sb_badge) {
        [self sb_badgeInit];
    }
}

- (CGFloat)sb_badgeRadius {
    return [objc_getAssociatedObject(self, @selector(sb_badgeRadius)) floatValue];
}

- (void)sb_setBadgeMargin:(CGFloat)badgeMargin {
    objc_setAssociatedObject(self, @selector(sb_badgeMargin), [NSNumber numberWithFloat:badgeMargin], OBJC_ASSOCIATION_RETAIN);
    if (!self.sb_badge) {
        [self sb_badgeInit];
    }
}

- (CGFloat)sb_badgeMargin {
    id margin = objc_getAssociatedObject(self, @selector(sb_badgeMargin));
    return margin == nil ? kSBBadgeDefaultMargin : [margin floatValue];
}

- (NSInteger)sb_badgeMaximumBadgeNumber {
    id obj = objc_getAssociatedObject(self, @selector(sb_badgeMaximumBadgeNumber));
    if(obj != nil && [obj isKindOfClass:[NSNumber class]]) {
        return [obj integerValue];
    }
        return kSBBadgeDefaultMaximumBadgeNumber;
}

- (void)sb_setBadgeMaximumBadgeNumber:(NSInteger)badgeMaximumBadgeNumber {
    NSNumber *numObj = @(badgeMaximumBadgeNumber);
    objc_setAssociatedObject(self, @selector(sb_badgeMaximumBadgeNumber), numObj, OBJC_ASSOCIATION_RETAIN);
    if (!self.sb_badge) {
        [self sb_badgeInit];
    }
}

- (BOOL)sb_isInvisiable {
    UIView *obj = self;
    CGFloat width = obj.frame.size.width;
    CGFloat height = obj.frame.size.height;
    BOOL isSizeZero = (width == 0 || height == 0);
    BOOL isInvisible = (obj.hidden == YES) || (obj.alpha <= 0.01f)  || (!obj.superview) || isSizeZero;
    return isInvisible;
}

- (BOOL)sb_canNotResponseEvent {
    return self.sb_isInvisiable || (self.userInteractionEnabled == NO);
}

@end
