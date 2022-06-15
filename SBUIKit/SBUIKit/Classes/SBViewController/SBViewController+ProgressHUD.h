//
//  SBViewController+ProgressHUD.h
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import "SBViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBViewController (ProgressHUD)

- (void)showProgressHUD;

- (void)showTextProgressHUD:(NSString *)text;

- (void)hideProgressHUD;

@end

NS_ASSUME_NONNULL_END
