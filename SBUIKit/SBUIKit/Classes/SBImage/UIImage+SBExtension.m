//
//  UIImage+SBExtension.m
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//

#import "UIImage+SBExtension.h"

#import "NSString+SBCalculate.h"

@implementation UIImage (SBExtension)

- (UIImage *)sb_scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO,[UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)sb_getImageToRect:(CGRect)rect {
    CGFloat scale = self.scale;
    rect = CGRectMake(rect.origin.x*scale,
                      rect.origin.y*scale,
                      rect.size.width*scale,
                      rect.size.height*scale);

    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallRect = CGRectMake(rect.origin.x,
                                  rect.origin.y,
                                  CGImageGetWidth(subImageRef),
                                  CGImageGetHeight(subImageRef));
    // 开启图形上下文
    UIGraphicsBeginImageContext(smallRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallRect, subImageRef);
    UIImage * image = [UIImage imageWithCGImage:subImageRef];
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
    
    return image;

}

+ (UIImage *)sb_imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


- (UIImage *)sb_imageWithCornerRadius:(CGFloat)radius {
    CGRect rect = (CGRect){0.f, 0.f, self.size};
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage * _Nonnull)sb_customImageCompressForSize:(CGSize)size {

    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        //选择，按照宽的比例缩放
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = floor( width * scaleFactor );
        scaledHeight = floor( height * scaleFactor );
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
    CGRect thumbnailRect = CGRectZero;
    //    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    //    NSLog(@"newImage.size--:%@",NSStringFromCGSize(newImage.size));
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)sb_imageByCropToRect:(CGRect)rect {
    rect.origin.x *= self.scale;
    rect.origin.y *= self.scale;
    rect.size.width *= self.scale;
    rect.size.height *= self.scale;
    if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}


// 更改原始图片的颜色
- (UIImage *)imageWithColor:(UIColor *)color {

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)sb_assetImageName:(NSString *)assetImageName
             userInterfaceStyle:(NSInteger)userInterfaceStyle  {
    UIImage *image = [UIImage imageNamed:@"image"];
    if (@available(iOS 13.0, *)) {
#if __has_include(<UIKit/UIScene.h>)
        UITraitCollection *trait;
//        UIUserInterfaceStyle currentUserInterfaceStyle = [UITraitCollection currentTraitCollection].userInterfaceStyle;
//        if (currentUserInterfaceStyle == UIUserInterfaceStyleUnspecified) {
//            currentUserInterfaceStyle == userInterfaceStyle;
//        }
        trait = [UITraitCollection traitCollectionWithUserInterfaceStyle:userInterfaceStyle];
        image = [image.imageAsset imageWithTraitCollection:trait];
        //TODO: 如果Xcode10加入的asset，没有加入图片，那么image是nil，还是默认是light的值？我期望是获取的light的值，要不然xcode11编译后很多图片都不会显示啊！！！！！
        return image;
#else
#endif
    }
    return image;
}

+ (UIImage *)sb_lightOrDarkModeImageWithLightImage:(UIImage *)lightImage
                                     darkImage:(UIImage *)darkImage  {
    return [self sb_lightOrDarkModeImageWithOwner:nil lightImage:lightImage darkImage:darkImage];
}

+ (UIImage *)sb_lightOrDarkModeImageWithOwner:(id<UITraitEnvironment>)owner
                 lightImageName:(NSString *)lightImageName
                  darkImageName:(NSString *)darkImageName {
    UIImage *lightImage = [UIImage imageNamed:lightImageName];
    UIImage *darkImage= [UIImage imageNamed:darkImageName];
    UIImage *lightOrDarkImage = [UIImage sb_lightOrDarkModeImageWithOwner:owner lightImage:lightImage darkImage:darkImage];
    return lightOrDarkImage;
}

+ (UIImage *)sb_lightOrDarkModeImageWithOwner:(id<UITraitEnvironment>)owner
                                    lightImage:(UIImage *)lightImage
                                     darkImage:(UIImage *)darkImage {
    BOOL isDarkImage = NO;
    if (@available(iOS 13.0, *)) {
#if __has_include(<UIKit/UIScene.h>)
        //TODO: self 有自定义traitCollection，那么 [UITraitCollection currentTraitCollection]获取到的是当前系统的，还是当前self的？我期望是self的，不然的话，那就太坑了。每次都要判断self和系统两个做取舍，那太坑了！！！！！
        UITraitCollection *traitCollection = owner.traitCollection ?: [UITraitCollection currentTraitCollection];
        UIUserInterfaceStyle userInterfaceStyle = traitCollection.userInterfaceStyle;
        isDarkImage = (userInterfaceStyle == UIUserInterfaceStyleDark);
#else
#endif
    }
    UIImage *image = (isDarkImage ? darkImage : lightImage);
    return image;
}


+ (UIImage *)sb_getImageWithBoudleName:(NSString *)boudleName imgName:(NSString *)imgName {

    NSBundle *bundle = [NSBundle staticLibBundleWithModuleName:boudleName];

    UIImage *image = [UIImage imageNamed:imgName
                                inBundle:bundle
           compatibleWithTraitCollection:nil];
    
//    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//    NSURL *url = [bundle URLForResource:boudleName withExtension:@"bundle"];
//    NSBundle *targetBundle = [NSBundle bundleWithURL:url];
//    UIImage *image = [UIImage imageNamed:imgName
//                                inBundle:targetBundle
//           compatibleWithTraitCollection:nil];
    return image;
}

#pragma mark 合并图片（竖着合并，以第一张图片的宽度为主）
+ (UIImage *)sb_combine:(UIImage *)oneImage otherImage:(UIImage *)otherImage {
    //计算画布大小
    CGFloat width = oneImage.size.width;
    CGFloat otherImageHeight = otherImage.size.height*width/otherImage.size.width;
    CGFloat height = oneImage.size.height + otherImageHeight - 3;//-2防止画布过大白边出现;
    otherImage = [otherImage sb_scaleToSize:CGSizeMake(width,
                                                       otherImageHeight)];
    
    CGSize resultSize = CGSizeMake(width, height);
    //UIGraphicsBeginImageContextWithOptions(resultSize, NO,[UIScreen mainScreen].scale);
    CGFloat scale = [UIScreen mainScreen].scale > 2 ? 2:[UIScreen mainScreen].scale;//iPhone8 plus太大，内存不够，暂定写死2
    UIGraphicsBeginImageContextWithOptions(resultSize, NO, scale);

    //放第一个图片
    CGRect oneRect = CGRectMake(0, 0, resultSize.width, oneImage.size.height);
    [oneImage drawInRect:oneRect];
    
    //放第二个图片
    CGRect otherRect = CGRectMake(0, oneRect.size.height-1, resultSize.width, otherImage.size.height);
    [otherImage drawInRect:otherRect];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

/**
 拉伸两端，保留中间
 
 @param image 需要拉伸的图片
 @param desSize 目标大小
 @param stretchLeftBorder 拉伸图片距离左边的距离
 @param top inset.top
 @param bottom inset.bottom
 @return 拉伸收缩后的图片
 */
UIImage *sb_stretch_both_sides_image(UIImage *image, CGSize desSize, CGFloat stretchLeftBorder, CGFloat top, CGFloat bottom) {
    if (!image) {
        return nil;
    }
    if (desSize.width == 0) {
        return nil;
    }
    CGSize imageSize = image.size;
    
    if (fabs(desSize.width - imageSize.width) <= 4) {
        return image;
    }
    
    imageSize.width = floor(imageSize.width);
    desSize.width   = floor(desSize.width);
    
    BOOL desSizeThan = desSize.width > imageSize.width;
    
    //各需要拉伸的宽度
    CGFloat needWidth = 0;
    needWidth = (desSize.width - imageSize.width) /2.0;
    
    //先拉取左边
    CGFloat left = stretchLeftBorder;
    CGFloat right = desSizeThan? (imageSize.width - left -1): (imageSize.width - fabs(needWidth) -left);
    
    
    //画图， 生成拉伸的左边后的图片
    CGFloat tempStrecthWith = 0;
    tempStrecthWith = imageSize.width + needWidth;
    
    //生成拉伸后的图片-》左
    CGFloat height = imageSize.height;
    UIImage *strectedImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, left, 0, right)];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempStrecthWith, height), NO, image.scale);
    [strectedImage drawInRect:CGRectMake(0, 0, tempStrecthWith, height)];
    strectedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //拉伸右边
    right = stretchLeftBorder;
    left  = desSizeThan? (strectedImage.size.width - right - 1): (strectedImage.size.width - right - fabs(needWidth));
    
    //生成拉伸后的图片-》右
    tempStrecthWith = desSize.width;
    strectedImage = [strectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, left, 0, right)];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempStrecthWith, height), NO, image.scale);
    [strectedImage drawInRect:CGRectMake(0, 0, tempStrecthWith, height)];
    strectedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [strectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(top, 0, bottom, 0)];
}


@end
