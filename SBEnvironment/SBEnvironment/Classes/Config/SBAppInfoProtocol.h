//
//  SBAppInfoProtocol.h
//  SBEnvironment
//
//  Created by 安康 on 2019/10/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SBAppInfoProtocol <NSObject>

/** appstore 下载地址 */
@property(nonatomic, readonly, copy) NSString *appStoreUrlStr;

/** 主app版本号 */
@property(nonatomic, readonly, copy) NSString * appVersionStr;

/** 大版本号 */
@property(nonatomic, readonly, copy) NSString * appVersionBigStr;

/** 显示版本号 */
@property(nonatomic, readonly, copy) NSString * appVersionDisplayStr;

/** app网络请求的UserAgent */
@property(nonatomic, readonly, copy) NSString *userAgentStr;

@end

NS_ASSUME_NONNULL_END
