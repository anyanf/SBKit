//
//  UITableViewCell+SBExtension.m
//  SBUIKit
//
//  Created by ankang on 2023/10/25.
//

#import "UITableViewCell+SBExtension.h"

@implementation UITableViewCell (SBExtension)

- (void)setCellAndContentViewBackgroundColor:(UIColor *)backgroundColor {
    self.backgroundColor = backgroundColor;
    self.contentView.backgroundColor = backgroundColor;
}

- (void)handleModel:(id)model {

}

+ (CGFloat)cellHeightWithModel:(id)model {
    return CGFLOAT_MIN;
}


@end
