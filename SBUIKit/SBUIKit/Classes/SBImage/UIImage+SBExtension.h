//
//  UIImage+SBExtension.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import <UIKit/UIKit.h>

#define SB_UIKit_IMG_K(name) [UIImage sb_getImageWithBoudleName:@"SBUIKit" imgName:name]


NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SBExtension)

/** 获取指定size的图片 */
- (UIImage *)sb_scaleToSize:(CGSize)size;

/** 获取图片指定frame的图片 */
- (UIImage  *)sb_getImageToRect:(CGRect)rect;
/** 获取指定颜色和大小的图片 */
+ (UIImage *)sb_imageWithColor:(UIColor *)color size:(CGSize)size;

/** 给图片添加圆角 */
- (UIImage *)sb_imageWithCornerRadius:(CGFloat)radius;

/** 等比缩放图片 */
- (UIImage * _Nonnull)sb_customImageCompressForSize:(CGSize)size;

/** 更改原始图片的颜色 */
- (UIImage *)imageWithColor:(UIColor *)color;

/** 获取Frameworks下指定Boundle中的图片*/
+ (UIImage *)sb_getImageWithBoudleName:(NSString *)boudleName imgName:(NSString *)imgName;

/** 合并图片（竖着合并，以第一张图片的宽度为主） */
+ (UIImage *)sb_combine:(UIImage *)oneImage otherImage:(UIImage *)otherImage;

/**
 拉伸两端，保留中间
 
 @param image 需要拉伸的图片
 @param desSize 目标大小
 @param stretchLeftBorder 拉伸图片距离左边的距离
 @param top inset.top
 @param bottom inset.bottom
 @return 拉伸收缩后的图片
 */
UIImage *sb_stretch_both_sides_image(UIImage *image, CGSize desSize, CGFloat stretchLeftBorder, CGFloat top, CGFloat bottom);


@end

NS_ASSUME_NONNULL_END
