//
//  UIColor+SBExt.m
//  Masonry
//
//  Created by 安康 on 2019/8/24.
//

#import "UIColor+SBExtension.h"

#import "SBViewController.h"

#import "SBFoundation.h"


@implementation UIColor (SBExtension)



+ (UIColor *)sb_colorWithARGB:(NSUInteger)argb {
    CGFloat alpha = (argb > 0xFFFFFF) ? (((argb>>24)&0xFF)/255.0f) : 1.0f;
    return [UIColor sb_colorWithRGB:argb alpha:alpha];
    
}


+ (UIColor *)sb_colorWithRGB:(NSUInteger)rgb {
    return [UIColor sb_colorWithRGB:rgb alpha:1.0f];
}


+ (UIColor *)sb_colorWithRGB:(NSUInteger)rgb alpha:(CGFloat)alpha {
    NSUInteger red = (rgb>>16)&0xFF;
    NSUInteger green = (rgb>>8)&0xFF;
    NSUInteger blue = rgb&0xFF;
    return [UIColor sb_r:red
                       g:green
                       b:blue
                   alpha:alpha];    
}


+ (UIColor *)sb_r:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue {
    
    return [UIColor sb_r:red
                       g:green
                       b:blue
                   alpha:1];
}


+ (UIColor *)sb_r:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:red/255.0
                           green:green/255.0
                            blue:blue/255.0
                           alpha:alpha];
    
}



// 通过16进制RBG值获得相应的颜色值，如：0xAABBCC、#AABBCCAA,可以带alpha
+ (UIColor *)sb_colorWithAlphaHexString:(NSString *)RGBStr {
    // 去掉空格，并全改为大写形式，便于下面的计算
    NSString *strColor = [[RGBStr sb_spaceTrimAll] uppercaseString];
    
    // 字符串必须大于6位，否则默认返回黑色
    if ([strColor length] < 6) {
        return [UIColor blackColor];
    }
    
    //  strip 0X if it appears
    if ([strColor hasPrefix:@"0X"]) {
        strColor = [strColor substringFromIndex:2];
    } else if ([strColor hasPrefix:@"#"]) {
        strColor = [strColor substringFromIndex:1];
    }
    
    if ([strColor length] < 6) {
        return [UIColor blackColor];
    }
    
    // 分别获取R、G、B的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [strColor substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [strColor substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [strColor substringWithRange:range];
    
    // Scan values
    unsigned int cuintR;
    unsigned int cuintG;
    unsigned int cuintB;
    unsigned int cuintA = 255;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&cuintR];
    [[NSScanner scannerWithString:gString] scanHexInt:&cuintG];
    [[NSScanner scannerWithString:bString] scanHexInt:&cuintB];
    
    if (strColor.length == 8) {
        range.location = 6;
        NSString *strAlpha = [strColor substringWithRange:range];
        [[NSScanner scannerWithString:strAlpha] scanHexInt:&cuintA];
    }
    
    return [UIColor colorWithRed:((float) cuintR / 255.0f)
                           green:((float) cuintG / 255.0f)
                            blue:((float) cuintB / 255.0f)
                           alpha:((float) cuintA / 255.0f)];
}



// 通过16进制RBG值获得相应的颜色值，如：0xAABBCC、#AABBCC
+ (UIColor *)sb_colorWithHexString:(NSString *)RGBStr {
    
    // 去掉空格，并全改为大写形式，便于下面的计算
    NSString *strColor = [[RGBStr sb_spaceTrimAll] uppercaseString];
    
    // 字符串必须大于6位，否则默认返回黑色
    if ([strColor length] < 6) {
        return [UIColor blackColor];
    }
    
    //  strip 0X if it appears
    if ([strColor hasPrefix:@"0X"]) {
        strColor = [strColor substringFromIndex:2];
    } else if ([strColor hasPrefix:@"#"]) {
        strColor = [strColor substringFromIndex:1];
    }
    
    // 剩下的位数一定是6位，否则默认返回黑色
    if ([strColor length] != 6) {
        return [UIColor blackColor];
    }
    
    // 分别获取R、G、B的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [strColor substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [strColor substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [strColor substringWithRange:range];
    
    /// Scan values
    unsigned int cuintR;
    unsigned int cuintG;
    unsigned int cuintB;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&cuintR];
    [[NSScanner scannerWithString:gString] scanHexInt:&cuintG];
    [[NSScanner scannerWithString:bString] scanHexInt:&cuintB];
    
    return [UIColor colorWithRed:((float) cuintR / 255.0f)
                           green:((float) cuintG / 255.0f)
                            blue:((float) cuintB / 255.0f)
                           alpha:1.0f];
}


+ (UIColor*)sb_randomColor {
    return [UIColor sb_r:random() % 256 g:random() % 256 b:random() % 256];
}
    
    

@end
