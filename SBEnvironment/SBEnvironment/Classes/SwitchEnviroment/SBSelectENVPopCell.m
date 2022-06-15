//
//  SBSelectENVPopCell.m
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//

#import "SBSelectENVPopCell.h"

@implementation SBSelectENVPopModel

- (NSString *)title {
    switch (self.env) {
        case SB_Enviroment_UnInit:
            return @"未初始化";
            break;
        case SB_Enviroment_Product:
            return @"生产环境";
            break;
        case SB_Enviroment_PRE:
            return @"预生产环境";
            break;
        case SB_Enviroment_UAT:
            return @"测试环境";
            break;
    }
}


@end

@interface SBSelectENVPopCell ()

@property(nonatomic,strong) UILabel *titleLbl;

@end

@implementation SBSelectENVPopCell


- (instancetype ) initWithStyle:(UITableViewCellStyle)style
                reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createMainViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createMainViews {
    self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(42, 0, self.frame.size.width - 42 - 15, [SBSelectENVPopCell cellHeight])];
    self.titleLbl.textColor = [UIColor sb_colorWithRGB:0x333333];
    self.titleLbl.font = [UIFont boldSystemFontOfSize:16.f];
    self.titleLbl.numberOfLines = 0;
    [self.contentView addSubview:self.titleLbl];
}

- (void)setModelData:(SBSelectENVPopModel *)modelData {
    _modelData = modelData;
        
    if (modelData.isSelect) {
        self.contentView.backgroundColor = UIColor.systemGrayColor;
    } else {
        self.contentView.backgroundColor = UIColor.whiteColor;
    }
    
    self.titleLbl.text = modelData.title;
}

+ (CGFloat)cellHeight {
    return 75;
}


@end
