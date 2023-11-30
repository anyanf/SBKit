//
//  SBMultiLevelTableViewCell.h
//  SBUIKit
//
//  Created by ankang on 2023/11/30.
//

#import <UIKit/UIKit.h>

#import "SBMultiLevelTableNode.h"


NS_ASSUME_NONNULL_BEGIN

@interface SBMultiLevelTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIView *sb_contentView;

- (void)setNode:(SBMultiLevelTableNode *)node;

+ (NSValue *)cellSizeWithNode:(SBMultiLevelTableNode *)node
                      maxSize:(NSValue *)maxSizeValue;

@end

NS_ASSUME_NONNULL_END
