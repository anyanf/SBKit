//
//  UITabBarItem+SBTabBarControllerExtention.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import "UITabBarItem+SBTabBarControllerExtention.h"


@implementation UITabBarItem (SBTabBarControllerExtention)

- (UIControl *)sb_tabButton {
    UIControl *control = [self valueForKeyPath:@"_view"];
    return control;
}

@end
