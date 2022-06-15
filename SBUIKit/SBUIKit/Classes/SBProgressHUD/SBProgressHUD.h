//
//  SBProgressHUD.h
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBProgressHUD : MBProgressHUD

+ (void)showTextHUDAddedTo:(nonnull UIView *)view text:(NSString *)text;

+ (void)showTextHUDAddedTo:(nonnull UIView *)view text:(NSString *)text afterDelay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
