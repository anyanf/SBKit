//
//  SBMultiLevelTableViewCell.m
//  SBUIKit
//
//  Created by ankang on 2023/11/30.
//

#import "SBMultiLevelTableViewCell.h"


@interface SBMultiLevelTableViewCell ()

@property (nonatomic, strong) SBMultiLevelTableNode *node;

@property (nonatomic, strong, readwrite) UIView *sb_contentView;

@end


@implementation SBMultiLevelTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _sb_contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_sb_contentView];
    }
    return self;
}

- (void)setNode:(SBMultiLevelTableNode *)node {
    _node = node;
    
    // set indentation
    CGFloat indentationX = (node.level - 1) * self.node.levelIndent;
    [self moveNode:indentationX];
    
    // color 测试 sb_contentView 区域
//    CGFloat rgbValue = (node.level - 1) * 50;
//    self.sb_contentView.backgroundColor  = [UIColor sb_r:rgbValue g:rgbValue b:rgbValue];
}

- (void)moveNode:(CGFloat)indentationX {
    
    CGSize cellSize = self.node.cellSizeValue.CGSizeValue;
    CGFloat cellHeight = cellSize.height;
    CGFloat cellWidth  = cellSize.width;
    
    self.sb_contentView.frame = CGRectMake(self.node.horiMargin + indentationX,
                                           0,
                                           cellWidth - indentationX - self.node.horiMargin * 2,
                                           cellHeight);
}

+ (NSValue *)cellSizeWithNode:(SBMultiLevelTableNode *)node
                      maxSize:(NSValue *)maxSizeValue {
    
    if (node.cellSizeValue) {
        return node.cellSizeValue;
    }
    
    node.cellSizeValue = [NSValue valueWithCGSize:CGSizeMake(maxSizeValue.CGSizeValue.width, 44)];
    return node.cellSizeValue;
}

@end
