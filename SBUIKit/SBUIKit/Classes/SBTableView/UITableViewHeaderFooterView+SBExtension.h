//
//  UITableViewHeaderFooterView+SBExtension.h
//  SBUIKit
//
//  Created by ankang on 2023/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewHeaderFooterView (SBExtension)

- (void)setViewAndContentViewBackgroundColor:(UIColor *)backgroundColor;


- (void)handleModel:(id __nullable)model;

+ (CGFloat)viewHeightWithModel:(id __nullable)model;


@end

NS_ASSUME_NONNULL_END
