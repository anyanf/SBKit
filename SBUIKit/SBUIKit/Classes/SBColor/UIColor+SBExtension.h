//
//  UIColor+SBExt.h
//  Masonry
//
//  Created by 安康 on 2019/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface UIColor (SBExtension)


/*!
 扩展，直接用0xFFFFFFFF表示颜色，带透明度方式
 @param argb 0xFFFFFFFF
 @return UIColor
 */
+ (UIColor *)sb_colorWithARGB:(NSUInteger)argb;


/*!
 扩展，直接用0xFFFFFF表示颜色，alpha=1.0f
 @param rgb 0xFFFFFF
 @return UIColor
 */
+ (UIColor *)sb_colorWithRGB:(NSUInteger)rgb;


/*!
 用0xFFFFFF表示颜色
 @param rgb 0xFFFFFFFF
 @param alpha 0-1
 @return UIColor
 */
+ (UIColor *)sb_colorWithRGB:(NSUInteger)rgb alpha:(CGFloat)alpha;

/** rgb不需要传小数，0-255即可 */
+ (UIColor *)sb_r:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue;

/** rgb不需要传小数，0-255即可，透明度需要传小数 */
+ (UIColor *)sb_r:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue alpha:(CGFloat)alpha;


/** 通过16进制RBG值获得相应的颜色值，如：0xAABBCC、#AABBCCAA,可以带alpha */
+ (UIColor *)sb_colorWithAlphaHexString:(NSString *)RGBStr;


/** 通过16进制RBG值获得相应的颜色值，如：0xAABBCC、#AABBCC */
+ (UIColor *)sb_colorWithHexString:(NSString *)RGBStr;


/** 随机颜色 */
+ (UIColor*)sb_randomColor;

@end

NS_ASSUME_NONNULL_END
