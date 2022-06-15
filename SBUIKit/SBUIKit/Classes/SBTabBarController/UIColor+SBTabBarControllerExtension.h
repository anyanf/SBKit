//
//  UIColor+SBTabBarControllerExtension.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/27.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SBTabBarControllerExtension)


@property (class, nonatomic, readonly) UIColor *sb_systemRedColor;
@property (class, nonatomic, readonly) UIColor *sb_systemGreenColor;
@property (class, nonatomic, readonly) UIColor *sb_systemBlueColor;
@property (class, nonatomic, readonly) UIColor *sb_systemOrangeColor;
@property (class, nonatomic, readonly) UIColor *sb_systemYellowColor;
@property (class, nonatomic, readonly) UIColor *sb_systemPinkColor;
@property (class, nonatomic, readonly) UIColor *sb_systemPurpleColor;
@property (class, nonatomic, readonly) UIColor *sb_systemTealColor;
@property (class, nonatomic, readonly) UIColor *sb_systemIndigoColor;


/* Shades of gray. systemGray is the base gray color.
 */
@property (class, nonatomic, readonly) UIColor *sb_systemGrayColor;
@property (class, nonatomic, readonly) UIColor *sb_systemGray2Color;
@property (class, nonatomic, readonly) UIColor *sb_systemGray3Color;
@property (class, nonatomic, readonly) UIColor *sb_systemGray4Color;
@property (class, nonatomic, readonly) UIColor *sb_systemGray5Color;
@property (class, nonatomic, readonly) UIColor *sb_systemGray6Color;

#pragma mark Foreground colors

/* Foreground colors for static text and related elements.
 */
@property (class, nonatomic, readonly) UIColor *sb_labelColor;
@property (class, nonatomic, readonly) UIColor *sb_secondaryLabelColor;
@property (class, nonatomic, readonly) UIColor *sb_tertiaryLabelColor ;
@property (class, nonatomic, readonly) UIColor *sb_quaternaryLabelColor;

/* Foreground color for standard system links.
 */
@property (class, nonatomic, readonly) UIColor *sb_linkColor;

/* Foreground color for placeholder text in controls or text fields or text views.
 */
@property (class, nonatomic, readonly) UIColor *sb_placeholderTextColor;

/* Foreground colors for separators (thin border or divider lines).
 * `separatorColor` may be partially transparent, so it can go on top of any content.
 * `opaqueSeparatorColor` is intended to look similar, but is guaranteed to be opaque, so it will
 * completely cover anything behind it. Depending on the situation, you may need one or the other.
 */
@property (class, nonatomic, readonly) UIColor *sb_separatorColor;
@property (class, nonatomic, readonly) UIColor *sb_opaqueSeparatorColor;

#pragma mark Background colors

/* We provide two design systems (also known as "stacks") for structuring an iOS app's backgrounds.
 *
 * Each stack has three "levels" of background colors. The first color is intended to be the
 * main background, farthest back. Secondary and tertiary colors are layered on top
 * of the main background, when appropriate.
 *
 * Inside of a discrete piece of UI, choose a stack, then use colors from that stack.
 * We do not recommend mixing and matching background colors between stacks.
 * The foreground colors above are designed to work in both stacks.
 *
 * 1. systemBackground
 *    Use this stack for views with standard table views, and designs which have a white
 *    primary background in light mode.
 */
@property (class, nonatomic, readonly) UIColor *sb_systemBackgroundColor;
@property (class, nonatomic, readonly) UIColor *sb_secondarySystemBackgroundColor;
@property (class, nonatomic, readonly) UIColor *sb_tertiarySystemBackgroundColor;

/* 2. systemGroupedBackground
 *    Use this stack for views with grouped content, such as grouped tables and
 *    platter-based designs. These are like grouped table views, but you may use these
 *    colors in places where a table view wouldn't make sense.
 */
@property (class, nonatomic, readonly) UIColor *sb_systemGroupedBackgroundColor;
@property (class, nonatomic, readonly) UIColor *sb_secondarySystemGroupedBackgroundColor;
@property (class, nonatomic, readonly) UIColor *sb_tertiarySystemGroupedBackgroundColor;

#pragma mark Fill colors

/* Fill colors for UI elements.
 * These are meant to be used over the background colors, since their alpha component is less than 1.
 *
 * systemFillColor is appropriate for filling thin and small shapes.
 * Example: The track of a slider.
 */
@property (class, nonatomic, readonly) UIColor *sb_systemFillColor;

/* secondarySystemFillColor is appropriate for filling medium-size shapes.
 * Example: The background of a switch.
 */
@property (class, nonatomic, readonly) UIColor *sb_secondarySystemFillColor;

/* tertiarySystemFillColor is appropriate for filling large shapes.
 * Examples: Input fields, search bars, buttons.
 */
@property (class, nonatomic, readonly) UIColor *sb_tertiarySystemFillColor;

/* quaternarySystemFillColor is appropriate for filling large areas containing complex content.
 * Example: Expanded table cells.
 */
@property (class, nonatomic, readonly) UIColor *sb_quaternarySystemFillColor;

#pragma mark Other colors

/* lightTextColor is always light, and darkTextColor is always dark, regardless of the current UIUserInterfaceStyle.
 * When possible, we recommend using `labelColor` and its variants, instead.
 */
@property(class, nonatomic, readonly) UIColor *sb_lightTextColor;    // for a dark background

@property(class, nonatomic, readonly) UIColor *sb_darkTextColor;     // for a light background

@end


NS_ASSUME_NONNULL_END
