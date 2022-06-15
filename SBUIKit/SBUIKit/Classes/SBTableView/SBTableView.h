//
//  SBTableView.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SBTableView;

@protocol SBTableViewDelegate <NSObject>

- (void)tableView:(SBTableView *)tableView didLongPressRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface SBTableView : UITableView

@property (nonatomic, weak) id<SBTableViewDelegate> sb_delegate;

+ (instancetype)createWithFrame:(CGRect)frame
                         target:(id)target
                          style:(UITableViewStyle)style;

@end

NS_ASSUME_NONNULL_END
