//
//  SBCollectionViewCell.m
//  SBUIKit
//
//  Created by 安康 on 2019/10/7.
//

#import "SBCollectionViewCell.h"

@implementation SBCollectionViewCell

- (void)setCellAndContentViewBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    self.contentView.backgroundColor = backgroundColor;
}

- (void)handleModel:(id)model {

}

+ (CGSize)sizeWithModel:(id)model {
    return CGSizeZero;
}


@end
