//
//  SBTabBar.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBTabBar : UITabBar

/*!
 * 让 `TabImageView` 垂直居中时，所需要的默认偏移量。
 * @attention 该值将在设置 top 和 bottom 时被同时使用，具体的操作等价于如下行为：
 * `viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(tabImageViewDefaultOffset, 0, -tabImageViewDefaultOffset, 0);`
 */
@property (nonatomic, assign, readonly) CGFloat tabImageViewDefaultOffset;

@property (nonatomic, copy) NSString *context;

@end

NS_ASSUME_NONNULL_END
