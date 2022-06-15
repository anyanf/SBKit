//
//  SBCollectionView.h
//  SBUIKit
//
//  Created by 安康 on 2019/10/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SBCollectionView : UICollectionView

+ (instancetype)createWithFrame:(CGRect)frame
                         target:(id)target
                          style:(UICollectionViewLayout *)laytout;

+ (UICollectionViewFlowLayout *)getDefautLayout;


@end

NS_ASSUME_NONNULL_END
