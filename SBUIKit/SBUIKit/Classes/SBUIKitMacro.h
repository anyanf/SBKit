//
//  SBUIKitMacro.h
//  SBUIKit
//
//  Created by 安康 on 2019/9/28.
//

#import "UIApplication+SBExtension.h"


#ifndef SBUIKitMacro_h
#define SBUIKitMacro_h


// MARK: 设备

// >=
#define SB_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO_K(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
// >
#define SB_SYSTEM_VERSION_GREATER_THAN_K(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
// ==
#define SB_SYSTEM_VERSION_EQUAL_TO_K(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)



// MARK: 屏幕

// 屏幕大小
#define SB_SCREEN_SIZE_K [[UIScreen mainScreen] bounds].size

// 屏幕宽高
#define SB_SCREEN_W_K [[UIScreen mainScreen] bounds].size.width
#define SB_SCREEN_H_K [[UIScreen mainScreen] bounds].size.height

// 是否是小屏幕
#define SB_SCREEN_IS_SMALL_K (SB_SCREEN_W_K <= 320)

// 导航和tabbar之间的高度
#define SB_SCREEN_NO_NAV_TAB_H_K (SB_SCREEN_H_K - SB_SAFE_NAV_TOP_INSET - SB_SAFE_TAB_BOTTOM_INSET)

// 导航条到屏幕底部的高度
#define SB_SCREEN_NO_NAV_H_K (SB_SCREEN_H_K - SB_SAFE_NAV_TOP_INSET)
// 导航条到屏幕底部安全区域的高度，刘海屏底部会留出间距
#define SB_SAFE_SCREEN_NO_NAV_H_K (SB_SCREEN_H_K - SB_SAFE_NAV_TOP_INSET - SB_SAFE_BOTTOM_INSET)
// 从状态栏到底部安全区域的高度，刘海屏底部会留出间距
#define SB_SAFE_SCREEN_H_K (SB_SCREEN_H_K - SB_SAFE_TOP_INSET - SB_SAFE_BOTTOM_INSET)
// 从状态栏到tabbar的安全高度
#define SB_SAFE_SCREEN_NO_TAB_H_K (SB_SCREEN_H_K - SB_SAFE_TOP_INSET - SB_SAFE_TAB_BOTTOM_INSET)

// 顶部安全间距
#define SB_SAFE_TOP_INSET UIApplication.sb_statusBarHeight
// 导航条间距（包括安全区）
#define SB_SAFE_NAV_TOP_INSET UIApplication.sb_navigationFullHeight
// 底部安全间距
#define SB_SAFE_BOTTOM_INSET UIApplication.sb_safeDistanceBottom
// tabbar间距（包括安全区）
#define SB_SAFE_TAB_BOTTOM_INSET UIApplication.sb_tabBarFullHeight


// 判断刘海屏
#define SB_IS_NOTCH_SCREEN_K ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})

#endif /* SBUIKitMacro_h */
