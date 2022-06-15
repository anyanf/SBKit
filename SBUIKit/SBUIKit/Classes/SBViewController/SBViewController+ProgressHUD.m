//
//  SBViewController+ProgressHUD.m
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import "SBViewController+ProgressHUD.h"

#import "SBProgressHUD.h"

@implementation SBViewController (ProgressHUD)

- (void)showProgressHUD {
    [SBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)showTextProgressHUD:(NSString *)text {
    [SBProgressHUD showTextHUDAddedTo:self.view text:text];
}


- (void)hideProgressHUD {
    [SBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
