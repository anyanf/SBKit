//
//  SBPresentationController.h
//  AFNetworking
//
//  Created by ankang on 2023/12/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBPresentationController : UIPresentationController

@property (nonatomic, assign) CGRect sb_presentedViewFrame;

@property (nonatomic, strong) UIColor *sb_containerViewBackgroundColor;

@end

NS_ASSUME_NONNULL_END
