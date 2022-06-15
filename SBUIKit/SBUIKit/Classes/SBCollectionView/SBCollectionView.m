//
//  SBCollectionView.m
//  SBUIKit
//
//  Created by 安康 on 2019/10/7.
//

#import "SBCollectionView.h"

@implementation SBCollectionView

+ (instancetype)createWithFrame:(CGRect)frame
                         target:(id)target
                          style:(UICollectionViewLayout *)laytout {
    SBCollectionView *clc = [[self alloc] initWithFrame:frame collectionViewLayout:laytout];
    clc.delegate = target;
    clc.dataSource = target;
    return clc;
}

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {

        [self setCommonAttribute];
        [self setCustomAttribute];
        
    }
    return self;
}

+ (UICollectionViewFlowLayout *)getDefautLayout {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //cell间距
    layout.minimumInteritemSpacing = 0.0f;
    //cell行距
    layout.minimumLineSpacing = 0.0f;
    return layout;
}


// 设置公共属性
- (void)setCommonAttribute {
    if (@available(iOS 11.0, *)) {
        if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
}

// 设置自定义属性
- (void)setCustomAttribute {
    self.backgroundColor = [UIColor whiteColor]; // 设置背景颜色
    
    
    self.showsHorizontalScrollIndicator = NO; // 不显示 水平 滑条
    self.showsVerticalScrollIndicator = NO;   // 不显示 垂直 滑条
    
    self.clipsToBounds = YES;
}


@end
