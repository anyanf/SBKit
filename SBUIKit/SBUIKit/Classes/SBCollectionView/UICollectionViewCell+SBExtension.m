//
//  UICollectionViewCell+SBExtension.m
//  SBUIKit
//
//  Created by ankang on 2023/11/8.
//

#import "UICollectionViewCell+SBExtension.h"

@implementation UICollectionViewCell (SBExtension)

- (void)setCellAndContentViewBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    self.contentView.backgroundColor = backgroundColor;
}

@end
