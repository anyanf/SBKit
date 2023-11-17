//
//  SBViewProtocol.h
//  SBUIKit
//
//  Created by AnKang on 2023/10/28.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SBViewProtocol <NSObject>

+ (CGFloat)sb_viewHeight;

+ (CGFloat)sb_viewHeightWithMaxSize:(CGSize)maxSize;

+ (CGFloat)sb_viewHeightWithModel:(id _Nullable)model;

+ (CGFloat)sb_viewHeightWithModel:(id _Nullable)model andMaxSize:(CGSize)maxSize;

+ (CGSize)sb_viewSize;

+ (CGSize)sb_viewSizeWithMaxSize:(CGSize)maxSize;

+ (CGSize)sb_viewSizeWithModel:(id _Nullable)model;

+ (CGSize)sb_viewSizeWithModel:(id _Nullable)model andMaxSize:(CGSize)maxSize;

- (void)sb_handleModel:(id _Nullable)model;

@end

NS_ASSUME_NONNULL_END
