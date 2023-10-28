//
//  SBWarningView.h
//  SBUIKit
//
//  Created by 安康 on 2020/2/6.
//


#import "UIButton+SBExtension.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SBWarningViewItem_Type) {
    SBWarningViewItem_Type_None,
    SBWarningViewItem_Type_Title,
    SBWarningViewItem_Type_Desc,
    SBWarningViewItem_Type_Btn,
    SBWarningViewItem_Type_Img
};

@interface SBWarningViewItem : NSObject

@property (nonatomic, assign) SBWarningViewItem_Type type;

@property (nonatomic, assign) CGSize size;

// title desc btn 需要
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;

// btn 需要
@property (nonatomic, strong) SBControlEventBlock btnEventBlock;

// SBWarningViewItem_Type_Img 需要
@property (nonatomic, strong) UIImage *img;


@end

@interface SBWarningView : UIView

- (void)config:(NSArray<SBWarningViewItem *> *)items;

@end

NS_ASSUME_NONNULL_END
