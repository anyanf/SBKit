//
//  SBSelectENVPopView.h
//
//  Created by 安康 on 2019/10/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBSelectENVPopView : UIView

/** 切换换的事件 */
@property(nonatomic, strong) void(^changeENVBlock)(void);

@end

NS_ASSUME_NONNULL_END
