//
//  UITableViewCell+SBExtension.h
//  SBUIKit
//
//  Created by ankang on 2023/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (SBExtension)

- (void)setCellAndContentViewBackgroundColor:(UIColor *)backgroundColor;

- (void)handleModel:(id)model;

+ (CGFloat)cellHeightWithModel:(id __nullable)model;

@end

NS_ASSUME_NONNULL_END
