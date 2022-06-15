//
//  SBHTTPRequest.m
//
//  Created by 安康 on 2019/9/24.
//

#import "SBHTTPRequest.h"

#import "SBFoundation.h"



@interface SBHTTPRequest()

@property (nonatomic, weak) NSURLSessionDataTask *task;

@property (nonatomic, copy) NSString *URLStr;

@property (nonatomic, strong) NSDictionary *paramsDic;

@property (nonatomic, assign) BOOL isShowLoading;
@property (nonatomic, assign) BOOL isShowToast;

@property (nonatomic, strong) UIView *HUDContentView;


#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong, nullable) dispatch_queue_t httpCompletionQueue;
#else
@property (nonatomic, assign, nullable) dispatch_queue_t httpCompletionQueue;
#endif

@property (nonatomic, assign) BOOL isCheckSuccess;

@property (nonatomic, assign) BOOL isRepeats;
@property (nonatomic, assign) double repeatsTimeInterval;
@property (nonatomic, assign) BOOL isSuspendRepeat;

@property (nonatomic, strong) NSTimer *timer;


@end


@implementation SBHTTPRequest

+ (instancetype)request {
    SBHTTPRequest *request = [[self alloc] init];
    
    return request;
}

+ (void)registerConfig:(id<SBHTTPProtocol>)config {
    [[SBNetworkManager shareInstance] registerConfig:config];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _URLStr = nil;
        _paramsDic = nil;
        _isShowLoading = NO;
        _isShowToast = NO;
        _HUDContentView = nil;
        _httpCompletionQueue = dispatch_get_main_queue();
        _isCheckSuccess = YES;
        _isRepeats = NO;
        _repeatsTimeInterval = 3;
        _isSuspendRepeat = NO;
    }
    return self;
}

- (void)dealloc {
    
    [self cancel];
    LOG_AK
}

- (NSURLSessionDataTask *)getSuccess:(SBNetworkSuccessHandle)success
                             failure:(SBNetworkFailureHandle)failure {
    @weakify(self);

    [self.timer invalidate];
    self.timer = nil;
    
    if (self.isRepeats) {

        self.timer = [NSTimer sb_scheduledTimerWithTimeInterval:self.repeatsTimeInterval
                                                          block:^{
            @strongify(self);
            
            if (!self.isSuspendRepeat) {
                
                if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(canRepeatsWithURL:)]) {
                    
                    BOOL canRepeat = [SBNetworkManager.shareInstance.networkConfig canRepeatsWithURL:self.URLStr];
                    
                    // 如果请求还没结束，不开启下一次请求
                    canRepeat = canRepeat && !(self.task && self.task.state == NSURLSessionTaskStateRunning);
                    if (canRepeat) {
                        
                        [self.task cancel];
                        self.task = nil;
                        self.task = [self _getSuccess:success failure:failure];

                    }
                }
                
            }
        }
                                                        repeats:YES];
    }

    self.task = [self _getSuccess:success failure:failure];

    return self.task;

}

- (NSURLSessionDataTask *)_getSuccess:(SBNetworkSuccessHandle)success
                              failure:(SBNetworkFailureHandle)failure {
    self.URLStr = [self requestURL] ? : self.URLStr;
    
    if (!SB_STR_IS_VALID_K(self.URLStr)) {
        return nil;
    }
    
    self.paramsDic = [self requestParams] ? : self.paramsDic;
    
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(handleRequeseParam:)]) {
        self.paramsDic = [SBNetworkManager.shareInstance.networkConfig handleRequeseParam:self.paramsDic];
    }
    
    NSURLSessionDataTask *task = [[SBNetworkManager shareInstance] get:self.URLStr
                                               params:self.paramsDic
                                              success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self stopLoading];
        
        NSError *error = nil;
        [self checkResponseStatusWith:result error:&error];
        id responseObj = [self requestDidSuccess:result];

        if (error) {
            if (failure) {
                dispatch_async(self.httpCompletionQueue, ^{
                    failure(error, statusCode, task);
                });
            }
        } else if (success) {
            dispatch_async(self.httpCompletionQueue, ^{
                success(responseObj, statusCode, task);
            });
        }
        
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self stopLoading];
        [self checkResponseStatusWith:task.response error:&error];
        
        if (failure) {
            dispatch_async(self.httpCompletionQueue, ^{
                failure(error, statusCode, task);
            });
        }
    }];
    
    [self startLoading];
    
    return task;
}
    

- (NSURLSessionDataTask *)postSuccess:(SBNetworkSuccessHandle)success
                              failure:(SBNetworkFailureHandle)failure {
    
    @weakify(self);
    
    [self.timer invalidate];
    self.timer = nil;
    
    if (self.isRepeats) {
        
        self.timer = [NSTimer sb_scheduledTimerWithTimeInterval:self.repeatsTimeInterval
                                                          block:^{
            @strongify(self);
            
            if (!self.isSuspendRepeat) {
                
                if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(canRepeatsWithURL:)]) {
                    
                    BOOL canRepeat = [SBNetworkManager.shareInstance.networkConfig canRepeatsWithURL:self.URLStr];
                    
                    // 如果请求还没结束，不开启下一次请求
                    canRepeat = canRepeat && !(self.task && self.task.state == NSURLSessionTaskStateRunning);
                    
                    if (canRepeat) {
                        [self.task cancel];
                        self.task = nil;
                        self.task = [self _postSuccess:success failure:failure];

                    }
                }
            }
        }
                                                        repeats:YES];
    }
    
    self.task = [self _postSuccess:success failure:failure];
    
    return self.task;
}

- (NSURLSessionDataTask *)_postSuccess:(SBNetworkSuccessHandle)success
                               failure:(SBNetworkFailureHandle)failure {
    self.URLStr = [self requestURL] ? : self.URLStr;
    
    if (!SB_STR_IS_VALID_K(self.URLStr)) {
        return nil;
    }
    
    self.paramsDic = [self requestParams] ? : self.paramsDic;
    
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(handleRequeseParam:)]) {
        self.paramsDic = [SBNetworkManager.shareInstance.networkConfig handleRequeseParam:self.paramsDic];
    }
    
    NSURLSessionDataTask *task = [[SBNetworkManager shareInstance] post:self.URLStr
                                                                 params:self.paramsDic
                                                                success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self stopLoading];
        
        NSError *error = nil;
        [self checkResponseStatusWith:result error:&error];
        id responseObj = [self requestDidSuccess:result];

        if (error) {
            if (failure) {
                dispatch_async(self.httpCompletionQueue, ^{
                    failure(error, statusCode, task);
                });
            }
        } else if (success) {
            dispatch_async(self.httpCompletionQueue, ^{
                success(responseObj, statusCode, task);
            });
        }
        
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self stopLoading];
        [self checkResponseStatusWith:task.response error:&error];
        
        if (failure) {
            dispatch_async(self.httpCompletionQueue, ^{
                failure(error, statusCode, task);
            });
        }
    }];
    
    [self startLoading];
    return task;
}

- (NSURLSessionDataTask *)putSuccess:(SBNetworkSuccessHandle)success
                             failure:(SBNetworkFailureHandle)failure {
    
    self.URLStr = [self requestURL] ? : self.URLStr;
    
    if (!SB_STR_IS_VALID_K(self.URLStr)) {
        return nil;
    }
    
    self.paramsDic = [self requestParams] ? : self.paramsDic;
    
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(handleRequeseParam:)]) {
        self.paramsDic = [SBNetworkManager.shareInstance.networkConfig handleRequeseParam:self.paramsDic];
    }
    
    self.task = [[SBNetworkManager shareInstance] put:self.URLStr
                                               params:self.paramsDic
                                              success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self stopLoading];
        
        NSError *error = nil;
        [self checkResponseStatusWith:result error:&error];
        id responseObj = [self requestDidSuccess:result];

        
        if (success) {
            dispatch_async(self.httpCompletionQueue, ^{
                success(responseObj, statusCode, task);
            });
        }
        
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self stopLoading];
        [self checkResponseStatusWith:task.response error:&error];
        
        if (failure) {
            dispatch_async(self.httpCompletionQueue, ^{
                failure(error, statusCode, task);
            });
        }
    }];
    
    [self startLoading];
    
    return self.task;
}

// upload with images
- (NSURLSessionDataTask *)uploadImages:(NSArray<UIImage *> *)images
                                  name:(NSString *)name
                            imageScale:(CGFloat)imageScale
                             imageType:(SBImageType)imageType
                              progress:(SBProgress)progress
                               success:(SBNetworkSuccessHandle)success
                               failure:(SBNetworkFailureHandle)failure {
    
    self.URLStr = [self requestURL] ? : self.URLStr;
    
    if (!SB_STR_IS_VALID_K(self.URLStr)) {
        return nil;
    }
    
    self.paramsDic = [self requestParams] ? : self.paramsDic;
    
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(handleRequeseParam:)]) {
        self.paramsDic = [SBNetworkManager.shareInstance.networkConfig handleRequeseParam:self.paramsDic];
    }
    
    self.task = [[SBNetworkManager shareInstance] upload:self.URLStr
                                                  params:self.paramsDic
                                                    name:name
                                                  images:images
                                              imageScale:imageScale
                                               imageType:imageType
                                                progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self stopLoading];

        NSError *error = nil;
        [self checkResponseStatusWith:result error:&error];
        id responseObj = [self requestDidSuccess:result];

        if (error) {
            if (failure) {
                dispatch_async(self.httpCompletionQueue, ^{
                    failure(error, statusCode, task);
                });
            }
        } else if (success) {
            dispatch_async(self.httpCompletionQueue, ^{
                success(responseObj, statusCode, task);
            });
        }
        

    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [self stopLoading];

        [self checkResponseStatusWith:task.response error:&error];
        
        if (failure) {
            dispatch_async(self.httpCompletionQueue, ^{
                failure(error, statusCode, task);
            });
        }
    }];
        
    [self startLoading];
    return self.task;
}

//upload with image datas
- (NSURLSessionDataTask *)uploadImageDatas:(NSArray<NSData *> *)imageDatas
                                      name:(NSString *)name
                                  progress:(SBProgress)progress
                                   success:(SBNetworkSuccessHandle)success
                                   failure:(SBNetworkFailureHandle)failure {
    
    self.URLStr = [self requestURL] ? : self.URLStr;
    
    if (!SB_STR_IS_VALID_K(self.URLStr)) {
        return nil;
    }
    
    self.paramsDic = [self requestParams] ? : self.paramsDic;
    
    self.task = [[SBNetworkManager shareInstance] upload:self.URLStr
                                                  params:self.paramsDic
                                                    name:name
                                              imageDatas:imageDatas
                                                progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        if (success) {
            dispatch_async(self.httpCompletionQueue, ^{
                success(result, statusCode, task);
            });
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        if (failure) {
            dispatch_async(self.httpCompletionQueue, ^{
                failure(error, statusCode, task);
            });
        }
    }];
        
    return self.task;
    
}

//upload with video url
- (NSURLSessionDataTask *)uploadVideoURL:(NSString *)videoURL
                                    name:(NSString *)name
                                fileName:(NSString *)fileName
                                progress:(SBProgress)progress
                                 success:(SBNetworkSuccessHandle)success
                                 failure:(SBNetworkFailureHandle)failure {
    self.URLStr = [self requestURL] ? : self.URLStr;
    
    if (!SB_STR_IS_VALID_K(self.URLStr)) {
        return nil;
    }
    
    self.paramsDic = [self requestParams] ? : self.paramsDic;
    
    self.task = [[SBNetworkManager shareInstance] upload:self.URLStr
                                                  params:self.paramsDic
                                                    name:name
                                                fileName:fileName
                                                videoURL:videoURL
                                                progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        if (success) {
            dispatch_async(self.httpCompletionQueue, ^{
                success(result, statusCode, task);
            });
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        if (failure) {
            dispatch_async(self.httpCompletionQueue, ^{
                failure(error, statusCode, task);
            });
        }
    }];
        
    return self.task;
}

//download
- (NSURLSessionDownloadTask *)download:(NSString *)url
                               fileDir:(NSString *)fileDir
                              progress:(SBProgress)progress
                               success:(SBDownloadSuccessHandle)success
                               failure:(SBNetworkFailureHandle)failure {
    self.URLStr = [self requestURL] ? : self.URLStr;
    self.URLStr = url ? : self.URLStr;
    
    if (!SB_STR_IS_VALID_K(self.URLStr)) {
        return nil;
    }
    
    NSURLSessionDownloadTask *task = [[SBNetworkManager shareInstance] download:url
                                                                        fileDir:fileDir
                                                                       progress:^(NSProgress *downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
        
    } success:^(NSString *filePath, NSInteger statusCode) {
        if (success) {
            dispatch_async(self.httpCompletionQueue, ^{
                success(filePath, statusCode);
            });
        }
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        if (failure) {
            dispatch_async(self.httpCompletionQueue, ^{
                failure(error, statusCode, task);
            });
        }
    }];
    
    return task;
}

/** 暂停轮询 */
- (void)suspendRepeat {
    self.isSuspendRepeat = YES;
}
/** 继续轮询 */
- (void)resumeRepeats {
    self.isSuspendRepeat = NO;
}

- (void)cancel {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    
    if (self.task) {
        [self.task cancel];
        self.task = nil;
    }
}

+ (void)cancelAllRequest {
    [[SBNetworkManager shareInstance] cancelAllRequest];
}

#pragma mark - ***** 结果处理 *****

- (NSString *)HTTP_NETWORK_UNAVAILABLE {
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(httpNetworkUnavailableErrorMsg)]) {
        return [SBNetworkManager.shareInstance.networkConfig httpNetworkUnavailableErrorMsg];
    } else {
        return @"网络请求失败,请检查你的网络";
    }
}

- (NSString *)HTTP_SERVER_ERROR {
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(httpServerErrorMsg)]) {
        return [SBNetworkManager.shareInstance.networkConfig httpServerErrorMsg];
    } else {
        return @"网络请求失败,请检查你的网络";
    }
}

- (NSString *)HTTP_TIMEOUT_ERROR {
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(httpTimeoutErrorMsg)]) {
        return [SBNetworkManager.shareInstance.networkConfig httpTimeoutErrorMsg];
    } else {
        return @"访问超时";
    }
}

- (NSString *)HTTP_CANCELLED_ERROR {
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(httpCancelledErrorMsg)]) {
        return [SBNetworkManager.shareInstance.networkConfig httpCancelledErrorMsg];
    } else {
        return @"服务器请求已取消";
    }
}

- (NSString *)HTTP_URL_AND_PARAMS_ERROR {
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(httpURLAndParamsErrorMsg)]) {
        return [SBNetworkManager.shareInstance.networkConfig httpURLAndParamsErrorMsg];
    } else {
        return @"请求参数异常";
    }
}

- (void)checkResponseStatusWith:(id)response error:(NSError **)error {
    
    if (*error) {
        
        NSString *msgerr = [self HTTP_NETWORK_UNAVAILABLE];
        if (SB_DIC_IS_VALID_K(response)) {
            NSString *err = [response objectForKey:@"msg"];
            msgerr = SB_STR_IS_VALID_K(err) ? err : [self HTTP_NETWORK_UNAVAILABLE];
            *error = [NSError errorWithDomain:msgerr code:NSURLErrorUnknown userInfo:nil];
        }
        
        NSError *err = *error;
        if (err.code == NSURLErrorCancelled) {
            err = [NSError errorWithDomain:[self HTTP_CANCELLED_ERROR] code:NSURLErrorCancelled userInfo:nil];
            *error = err;

            [self toastWith:err.domain];
        } else if (err.code == NSURLErrorTimedOut) {
            err = [NSError errorWithDomain:[self HTTP_TIMEOUT_ERROR] code:NSURLErrorTimedOut userInfo:nil];
            *error = err;

            [self toastWith:err.domain];
        } else {
            
//            err = [NSError errorWithDomain:msgerr code:NSURLErrorUnknown userInfo:nil];
//            *error = err;
//
//            [self toastWith:err.domain];
            [self toastWith:(*error).domain];
        }
        
        return;
    }
    
    if (_isCheckSuccess) {
        if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(checkResponse:error:)]) {
            if (![SBNetworkManager.shareInstance.networkConfig checkResponse:response error:error]) {
                NSString *msg = (*error).domain;
                [self toastWith:SB_STR_IS_VALID_K(msg)?msg:[self HTTP_NETWORK_UNAVAILABLE]];
            }
        }

    }
    
}

#pragma mark -  Loading || Toast

- (void)startLoading {
    
    if (self.isShowLoading == NO) {
        return;
    }
    
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(startLoadingInView:)]) {
        [SBNetworkManager.shareInstance.networkConfig startLoadingInView:self.HUDContentView];
    }
}

- (void)stopLoading {
    if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(startLoadingInView:)]) {
        [SBNetworkManager.shareInstance.networkConfig stopLoadingInView:self.HUDContentView];
    }
}

- (void)toastWith:(NSString *)msg {
    
    if (self.isShowToast == NO) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([SBNetworkManager.shareInstance.networkConfig respondsToSelector:@selector(toastWith:inView:)]) {
            [SBNetworkManager.shareInstance.networkConfig toastWith:msg inView:self.HUDContentView];
        }
    });
}


#pragma mark - 传参便捷方法

- (SBHTTPRequest * (^)(NSString *url))url {
    __weak typeof(self) weakSelf = self;
    return ^SBHTTPRequest * (NSString *url) {
        weakSelf.URLStr = [url copy];
        return weakSelf;
    };
}

- (SBHTTPRequest * (^)(NSDictionary *params))params {
    __weak typeof(self) weakSelf = self;
    return ^SBHTTPRequest * (NSDictionary *params) {
        weakSelf.paramsDic = params;
        return weakSelf;
    };
}

- (SBHTTPRequest * (^)(void))showLoading {
    __weak typeof(self) weakSelf = self;
    return ^SBHTTPRequest *(void){
        weakSelf.isShowLoading = YES;
        return weakSelf;
    };
}

- (SBHTTPRequest * (^)(void))showToast {
    __weak typeof(self) weakSelf = self;
    return ^SBHTTPRequest *{
        weakSelf.isShowToast = YES;
        return weakSelf;
    };
}


- (SBHTTPRequest * (^)(UIView *view))InView {
    __weak typeof(self) weakSelf = self;
    return ^SBHTTPRequest * (UIView *view) {
        weakSelf.HUDContentView = view;
        return weakSelf;
    };
}


- (SBHTTPRequest * (^)(BOOL isCheckSuccess))checkSuccess {
    __weak typeof(self) weakSelf = self;
    return ^SBHTTPRequest * (BOOL isIgnoreSuccessCheck) {
        weakSelf.isCheckSuccess = isIgnoreSuccessCheck;
        return weakSelf;
    };
}


- (SBHTTPRequest * (^)(dispatch_queue_t queue))completionQueue {
    __weak typeof(self) weakSelf = self;
    return ^SBHTTPRequest * (dispatch_queue_t queue) {
        weakSelf.httpCompletionQueue = queue;
        return weakSelf;
    };
}

- (SBHTTPRequest * _Nonnull (^)(BOOL))repeats {
    __weak typeof(self) weakSelf = self;
    return ^SBHTTPRequest * (BOOL repeats) {
        weakSelf.isRepeats = repeats;
        weakSelf.isSuspendRepeat = NO;
        return weakSelf;
    };
}

- (SBHTTPRequest * _Nonnull (^)(double))interval {
    __weak typeof(self) weakSelf = self;
    return ^SBHTTPRequest * (double interval) {
        weakSelf.repeatsTimeInterval = interval;
        return weakSelf;
    };
}

#pragma mark - ***** 继承重写，可选 *****

- (NSString *)requestURL { return nil; }
- (NSDictionary *)requestParams { return nil; }
- (nullable id)requestDidSuccess:(nullable id)responseObj { return responseObj; }


@end
