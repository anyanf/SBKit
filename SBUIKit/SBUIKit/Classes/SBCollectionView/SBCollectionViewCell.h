//
//  SBCollectionViewCell.h
//  SBUIKit
//
//  Created by 安康 on 2019/10/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBCollectionViewCell : UICollectionViewCell

- (void)setCellAndContentViewBackgroundColor:(UIColor *)backgroundColor;

- (void)handleModel:(id)model;


+ (CGSize)sizeWithModel:(id __nullable)model;


@end

NS_ASSUME_NONNULL_END
