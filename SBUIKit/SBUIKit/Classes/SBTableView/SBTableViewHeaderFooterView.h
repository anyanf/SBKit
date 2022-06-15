//
//  SBTableViewHeaderFooterView.h
//  Pods
//
//  Created by 安康 on 2019/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBTableViewHeaderFooterView : UITableViewHeaderFooterView

- (void)setViewAndContentViewBackgroundColor:(UIColor *)backgroundColor;

- (void)handleModel:(id __nullable)model;

+ (CGFloat)viewHeightWithModel:(id __nullable)model;

@end

NS_ASSUME_NONNULL_END
