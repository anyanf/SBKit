//
//  SBProgressHUD.m
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import "SBProgressHUD.h"

@implementation SBProgressHUD

+ (void)showTextHUDAddedTo:(nonnull UIView *)view text:(NSString *)text {
    [self showTextHUDAddedTo:view text:text afterDelay:1.5];
}

+ (void)showTextHUDAddedTo:(nonnull UIView *)view text:(NSString *)text afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.contentColor = [UIColor whiteColor];
    //hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:25/255.0 blue:50/255.0 alpha:1];
    
    [hud hideAnimated:YES afterDelay:delay];
}

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    SBProgressHUD *hud = [super showHUDAddedTo:view animated:animated];
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:25/255.0 blue:50/255.0 alpha:1];

    return hud;
}

@end
