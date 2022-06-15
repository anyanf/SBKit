//
//  SBHTTPRequest.h
//
//  Created by 安康 on 2019/9/24.
//

#import <Foundation/Foundation.h>

#import "SBNetworkManager.h"

NS_ASSUME_NONNULL_BEGIN



@interface SBHTTPRequest : NSObject

- (SBHTTPRequest * (^)(NSString           *url))             url;
- (SBHTTPRequest * (^)(NSDictionary       *params))          params;
- (SBHTTPRequest * (^)(void))                                showLoading;
- (SBHTTPRequest * (^)(void))                                showToast;
- (SBHTTPRequest * (^)(UIView             *view))            InView;
- (SBHTTPRequest * (^)(dispatch_queue_t   queue))            completionQueue;
- (SBHTTPRequest * (^)(BOOL               checkSuccess))     checkSuccess;
/** 是否轮询，如果需要轮询，这个request必须不能被销毁，需要有对象持有 */
- (SBHTTPRequest * (^)(BOOL               repeats))          repeats;
- (SBHTTPRequest * (^)(double             interval))         interval;

+ (instancetype)request;

- (NSURLSessionDataTask *)getSuccess:(SBNetworkSuccessHandle)success
                             failure:(SBNetworkFailureHandle)failure;

- (NSURLSessionDataTask *)postSuccess:(SBNetworkSuccessHandle)success
                              failure:(SBNetworkFailureHandle)failure;

- (NSURLSessionDataTask *)uploadImages:(NSArray<UIImage *> *)images
                                  name:(NSString *)name
                            imageScale:(CGFloat)imageScale
                             imageType:(SBImageType)imageType
                              progress:(SBProgress)progress
                               success:(SBNetworkSuccessHandle)success
                               failure:(SBNetworkFailureHandle)failure;
/** 暂停轮询 */
- (void)suspendRepeat;
/** 继续轮询 */
- (void)resumeRepeats;

/** 取消请求 */
- (void)cancel;

// cancel request
+ (void)cancelAllRequest;

#pragma mark - ***** 继承重写，可选 *****

- (NSString *)requestURL;
- (NSDictionary *)requestParams;
- (nullable id)requestDidSuccess:(nullable id)responseObj;

#pragma mark - 配置请求公参头，不需要配次都调用
/** 配置config */
+ (void)registerConfig:(id<SBHTTPProtocol>)config;

@end

NS_ASSUME_NONNULL_END
