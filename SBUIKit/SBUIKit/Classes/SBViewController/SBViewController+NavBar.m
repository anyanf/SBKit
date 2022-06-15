//
//  SBViewController+NavBar.m
//  Masonry
//
//  Created by 安康 on 2019/9/10.
//

#import "SBViewController+NavBar.h"

#import "SBViewController+PrivateHeader.h"

#import "SBFoundation.h"

#import "SBLabel.h"
#import "SBControl.h"

#import "UIImage+SBExtension.h"


@implementation SBViewController (NavBar)



- (void)setNavBarTitle:(id)title {
    
    if (SB_STR_CLASS_K(title)) {
        self.navigationItem.title = title;
    } else if ([title isKindOfClass:[UIView class]]) {
        self.navigationItem.titleView = title;
    }
}

- (void)setNavBarBackItemWithclickBlock:(void(^)(void))clickBlock {
    
    [self setNavBarBackItemWithclickBlock:clickBlock isAutoPop:YES];
    
}

- (void)setNavBarBackItemWithclickBlock:(void(^)(void))clickBlock isAutoPop:(BOOL)isAutoPop {
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:SB_UIKit_IMG_K(@"nav_back")];
   
    // 扩大一下响应范围
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    imgV.frame = CGRectMake(0,
                            (view.frame.size.height - imgV.frame.size.height)/2,
                            imgV.frame.size.width,
                            imgV.frame.size.height);
    [view addSubview:imgV];
    
    __weak typeof(self) weakSelf = self;

    [self setNavBarLeftItemWithCustomView:view clickBlock:^{
        if (isAutoPop) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        if (clickBlock) {
            clickBlock();
        }
    }];
}

- (void)setNavBarLeftItemWithCustomView:(UIView *)customView clickBlock:(void(^)(void))clickBlock {
    
    self.navigationItem.hidesBackButton = YES;
    
    customView = [self handleCustomView:customView];
    // 防止customview自动改宽度
    UIView *view = [[UIView alloc] initWithFrame:customView.bounds];
    customView.center = view.center;
    [view addSubview:customView];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    SBControl *control = [SBControl createWithFrame:leftItem.customView.bounds
                                         eventBlock:^(SBControl * _Nonnull control, UIControlEvents controlEvents) {
        if (clickBlock) {
            clickBlock();
        }
    }];
    
    leftItem.customView.userInteractionEnabled = YES;
    [leftItem.customView addSubview:control];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
}


- (void)setNavBarRightItemWithCustomView:(UIView *)customView clickBlock:(void(^)(void))clickBlock {
    
    customView = [self handleCustomView:customView];
    
    // 防止customview自动改宽度
    UIView *view = [[UIView alloc] initWithFrame:customView.bounds];
    customView.center = view.center;
    [view addSubview:customView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];

    SBControl *control = [SBControl createWithFrame:rightItem.customView.bounds
                                         eventBlock:^(SBControl * _Nonnull control, UIControlEvents controlEvents) {
        if (clickBlock) {
            clickBlock();
        }
    }];
    
    rightItem.customView.userInteractionEnabled = YES;
    [rightItem.customView addSubview:control];
    
    [self.navigationItem setRightBarButtonItem:rightItem];
}


- (UIView *)handleCustomView:(UIView *)customView {
    
    if ([customView isKindOfClass:UIImageView.class]) {
        UIImageView *imageView = (UIImageView *)customView;
        imageView.image = [imageView.image sb_scaleToSize:imageView.frame.size];
        return imageView;
    }
    
    return customView;
}

- (UIImage *)sb_captureNavBar {
    UIImage *contentImage = nil;
    UIGraphicsBeginImageContextWithOptions(self.navigationController.navigationBar.frame.size, NO, 0.0);
    {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.navigationController.navigationBar.layer renderInContext:context];
        contentImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    

    //截取所需区域
    CGRect captureRect = CGRectMake(0,
                                    0,
                                    self.navigationController.navigationBar.frame.size.width,
                                    self.navigationController.navigationBar.frame.size.height);
    CGFloat scale = [UIScreen mainScreen].scale;
    captureRect = CGRectMake(captureRect.origin.x*scale,
                             captureRect.origin.y*scale,
                             captureRect.size.width*scale,
                             captureRect.size.height*scale);
    CGImageRef sourceImageRef = [contentImage CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, captureRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    return newImage;
}


@end
