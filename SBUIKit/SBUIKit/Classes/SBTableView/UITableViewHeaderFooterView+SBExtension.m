//
//  UITableViewHeaderFooterView+SBExtension.m
//  SBUIKit
//
//  Created by ankang on 2023/10/25.
//

#import "UITableViewHeaderFooterView+SBExtension.h"

@implementation UITableViewHeaderFooterView (SBExtension)

- (void)setViewAndContentViewBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    self.contentView.backgroundColor = backgroundColor;
}

- (void)handleModel:(id)model {

}

+ (CGFloat)viewHeightWithModel:(id)model {
    return CGFLOAT_MIN;
}

@end
