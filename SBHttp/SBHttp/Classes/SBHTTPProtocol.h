//
//  SBHTTPProtocol.h
//  Masonry
//
//  Created by 安康 on 2019/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SBHTTPProtocol <NSObject>

@required


/**
 配置 Header
 */
- (NSDictionary<NSString*, id> *)getRequestHeaders;

/**
 检验请求响应结果，如果为NO，说明失败。
 */
- (BOOL)checkResponse:(NSDictionary *)responseObject error:(NSError **)error;

/**
 处理请求参数
*/
- (NSDictionary *)handleRequeseParam:(NSDictionary *)paramDic;


@optional

/**
 是否登录状态
 */
- (BOOL)isLogined;

- (void)startLoadingInView:(UIView *)loadingInView;

- (void)stopLoadingInView:(UIView *)loadingInView;

- (void)toastWith:(NSString *)msg inView:(UIView *)loadingInView;

- (BOOL)canRepeatsWithURL:(NSString *)URL;


- (NSString *)httpNetworkUnavailableErrorMsg;

- (NSString *)httpServerErrorMsg;

- (NSString *)httpTimeoutErrorMsg;

- (NSString *)httpCancelledErrorMsg;

- (NSString *)httpURLAndParamsErrorMsg;

@optional

/** 保存cookie到keychain中的key */
@property(nonatomic, readonly, copy) NSString* cookieKeyStr;

/** 保存cookie到keychain中的indetify */
@property(nonatomic, readonly, copy) NSString* identifyStr;

/** 保存cookie到keychain中的group */
@property(nonatomic, readonly, copy) NSString* groupStr;

/** 是否将cookie保存到group key chain中 */
@property(nonatomic, readonly, assign) BOOL isSaveCookieToGroupKeyChain;


@end


NS_ASSUME_NONNULL_END
