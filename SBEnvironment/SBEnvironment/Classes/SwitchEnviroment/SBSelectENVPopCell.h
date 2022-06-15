//
//  SBSelectENVPopCell.h
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//

#import <UIKit/UIKit.h>

#import "SBSwitchEnviroment.h"

NS_ASSUME_NONNULL_BEGIN

@interface SBSelectENVPopModel : NSObject

@property (nonatomic, assign) SB_Enviroment_Mode env;
@property(nonatomic, assign) BOOL isSelect;

@property(nonatomic, strong) NSString *title;


@end


@interface SBSelectENVPopCell : UITableViewCell

@property(nonatomic, strong) SBSelectENVPopModel *modelData;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
