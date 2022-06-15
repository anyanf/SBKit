//
//  SBTableViewCell.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBTableViewCell : UITableViewCell

/** 是否显示右箭头,这个属性要优先设置，因为会影响contentview的frame */
@property (nonatomic, assign, getter=isShowRightArrow) BOOL showRightArrow;

- (void)setCellAndContentViewBackgroundColor:(UIColor *)backgroundColor;

- (void)handleModel:(id)model;

+ (CGFloat)cellHeightWithModel:(id __nullable)model;

@end

NS_ASSUME_NONNULL_END
