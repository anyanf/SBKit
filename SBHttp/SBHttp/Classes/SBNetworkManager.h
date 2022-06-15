//
//  SBNetworkManager.h
//
//  Created by 安康 on 2019/9/24.
//


#import <Foundation/Foundation.h>

#import "AFNetworking.h"

#import "SBHTTPProtocol.h"

typedef void (^SBDownloadSuccessHandle) (NSString * filePath, NSInteger statusCode);
typedef void (^SBNetworkSuccessHandle) (id result, NSInteger statusCode, NSURLSessionDataTask *task);
typedef void (^SBNetworkFailureHandle) (NSError *error, NSInteger statusCode, NSURLSessionDataTask *task);
typedef void (^SBProgress) (NSProgress *progress);

typedef void (^SBNetworkManagerConnectedChangeBlock)(NSString * prompt);


typedef NS_ENUM(NSInteger, SBResponseSerialization) {
    SBJSONResponseSerialization,
    SBHTTPResponseSerialization
};

typedef NS_ENUM(NSInteger, SBRequestSerialization) {
    SBHTTPRequestSerialization,
    SBJSONRequestSerialization
};

typedef NS_ENUM(NSInteger, SBImageType) {
    SBImageTypeJPEG,
    SBImageTypePNG,
    SBImageTypeGIF,
    SBImageTypeTIFF,
    SBImageTypeUNKNOWN
};

@class SBNetworkManager;


@interface SBNetworkManager : NSObject

/**
 block
 */
@property (nonatomic, copy) SBNetworkManagerConnectedChangeBlock didConnectedBlock;
@property (nonatomic, copy) SBNetworkManagerConnectedChangeBlock didDisConnectedBlock;

/**
 baseURL
 */

@property (nonatomic, strong) NSString *baseURL;

/**
 timeoutInterval   30 default
 */
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;


/**
 sets the common parameter of the HTTP client. if value is `nil`, removes the existing value which associated to the field.
 @param value - the value of the parameter
 @param field - the parameter, or `nil`
 */
- (void)setValue:(id)value forParameterField:(NSString *)field;
/**
 sets the common headerField of the HTTP client. if value is `nil`, removes the existing value which associated to the field.
 @param value - the value of the HTTP header
 @param field - the HTTP header, or `nil`
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;


/**
 request serialization
 */
@property (nonatomic, assign) SBRequestSerialization requestSerialization;

/**
 response serialization
*/
@property (nonatomic, assign) SBResponseSerialization responseSerialization;

/**
 Create manager
 
 @return manager
 */
+ (instancetype)shareInstance;

/** 配置config */
- (void)registerConfig:(id<SBHTTPProtocol>)config;

- (id<SBHTTPProtocol>)networkConfig;

/**
 Start monitor network
 */
- (void)startMonitorNetworkTypeWithDidConnectedBlock:(SBNetworkManagerConnectedChangeBlock)didConnectedBlock
                                didDisConnectedBlock:(SBNetworkManagerConnectedChangeBlock)didDisConnectedBlock;

/**
 Judge is wifi ?
 
 @return isWifi
 */
- (BOOL)isWIFI;

// network indicator state
- (void)openNetworkActivityIndicator:(BOOL)open;

// cancel request
- (void)cancelAllRequest;

- (void)cancelRequestWithURL:(NSString *)url;

// get
- (NSURLSessionDataTask *)get:(NSString *)url
                       params:(id)params
                      success:(SBNetworkSuccessHandle)success
                      failure:(SBNetworkFailureHandle)failure;
// post
- (NSURLSessionDataTask *)post:(NSString *)url
                        params:(id)params
                       success:(SBNetworkSuccessHandle)success
                       failure:(SBNetworkFailureHandle)failure;

- (NSURLSessionDataTask *)put:(NSString *)url
                       params:(id)params
                      success:(SBNetworkSuccessHandle)success
                      failure:(SBNetworkFailureHandle)failure;

- (NSURLSessionDataTask *)delete:(NSString *)url
                          params:(id)params
                         success:(SBNetworkSuccessHandle)success
                         failure:(SBNetworkFailureHandle)failure;
// upload with images
- (NSURLSessionDataTask *)upload:(NSString *)url
                          params:(id)params
                            name:(NSString *)name
                          images:(NSArray<UIImage *> *)images
                      imageScale:(CGFloat)imageScale
                       imageType:(SBImageType)imageType
                        progress:(SBProgress)progress
                         success:(SBNetworkSuccessHandle)success
                         failure:(SBNetworkFailureHandle)failure;
// upload with image datas
- (NSURLSessionDataTask *)upload:(NSString *)url
                          params:(id)params
                            name:(NSString *)name
                      imageDatas:(NSArray<NSData *> *)imageDatas
                        progress:(SBProgress)progress
                         success:(SBNetworkSuccessHandle)success
                         failure:(SBNetworkFailureHandle)failure;

// upload with video url
- (NSURLSessionDataTask *)upload:(NSString *)url
                          params:(id)params
                            name:(NSString *)name
                        fileName:(NSString *)fileName
                        videoURL:(NSString *)videoURL
                        progress:(SBProgress)progress
                         success:(SBNetworkSuccessHandle)success
                         failure:(SBNetworkFailureHandle)failure;

// download
- (NSURLSessionDownloadTask *)download:(NSString *)url
                               fileDir:(NSString *)fileDir
                              progress:(SBProgress)progress
                               success:(SBDownloadSuccessHandle)success
                               failure:(SBNetworkFailureHandle)failure;
@end


