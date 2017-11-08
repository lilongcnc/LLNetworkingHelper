//
//  LLNetAPIworking.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/6/26.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLNetAPIworking.h"
#import "LLCommonNetworking.h"
#import "AFNetworking.h"
#import <pthread.h>
#import "LLNetworkingHelperUtil.h"
#import "LLUploadNetworking.h"

typedef NS_OPTIONS(NSUInteger, LLRequestType) {
    LLGETRequest = 0,
    LLPOSTRequest
};

@interface LLNetAPIworking ()

@property (nonatomic,assign) LLRequestType myRequestType;
@property (nonatomic,strong) AFHTTPSessionManager *mySessionManager;
@property (nonatomic,strong) NSMutableArray *myAllTaskArray;

@end

@implementation LLNetAPIworking

static pthread_mutex_t _lock;
static BOOL _ll_NetworkingDebugEnabled = NO;

//LLLog(@"🐳🐳🐳🐳🐳🐳🐳 -%s- 进行自动登录...",__func__);


+ (LLNetAPIworking *)sharedInstance {
    static LLNetAPIworking *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [self new];
    });
    
    return _sharedManager;
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ Interfaces ================
//-----------------------------------------------------------------------------------------------------------
+ (LLNSURLSessionDataTask *)ll_GET:(NSString *)url
                           parameters:(id)parameters
                              success:(LLSuccessBlock)success
                              failure:(LLFailedBlock)failure
{
    LLLog(@"🐳🐳🐳🐳🐳🐳🐳 %s  %p",__FUNCTION__,[self sharedInstance].myAllTaskArray);
    
    [self sharedInstance].myRequestType = LLGETRequest;
    return [LLCommonNetworking _GET:url
                         parameters:parameters
                         afnManager:[self sharedInstance].mySessionManager
                     allSessionTask:[self sharedInstance].myAllTaskArray
                          cacheTime:-1
                      responseCache:nil
                           progress:nil
                            success:success
                            failure:failure];

}


+ (LLNSURLSessionDataTask *)ll_GET:(NSString *)url
                           parameters:(id)parameters
                            cacheTime:(NSTimeInterval)cacheTime
                        responseCache:(LLCacheBlock)responseCache
                              success:(LLSuccessBlock)success
                              failure:(LLFailedBlock)failure
{
    LLLog(@"🐳🐳🐳🐳🐳🐳🐳 %s  %p",__FUNCTION__,[self sharedInstance].myAllTaskArray);
    
    [self sharedInstance].myRequestType = LLGETRequest;
    return [LLCommonNetworking _GET:url
                         parameters:parameters
                         afnManager:[self sharedInstance].mySessionManager
                     allSessionTask:[self sharedInstance].myAllTaskArray
                          cacheTime:cacheTime
                      responseCache:responseCache
                           progress:nil
                            success:success
                            failure:failure];
}



+ (LLNSURLSessionDataTask *)ll_POST:(NSString *)url
                            parameters:(id)parameters
                               success:(LLSuccessBlock)success
                               failure:(LLFailedBlock)failure
{
    LLLog(@"🐳🐳🐳🐳🐳🐳🐳 %s  %p",__FUNCTION__,[self sharedInstance].myAllTaskArray);

    [self sharedInstance].myRequestType = LLPOSTRequest;
    return [LLCommonNetworking _POST:url
                         parameters:parameters
                         afnManager:[self sharedInstance].mySessionManager
                     allSessionTask:[self sharedInstance].myAllTaskArray
                          cacheTime:-1
                      responseCache:nil
                            progress:nil
                            success:success
                            failure:failure];
    
}


+ (LLNSURLSessionDataTask *)ll_POST:(NSString *)url
                            parameters:(id)parameters
                             cacheTime:(NSTimeInterval)cacheTime
                         responseCache:(LLCacheBlock)responseCache
                               success:(LLSuccessBlock)success
                               failure:(LLFailedBlock)failure
{
    LLLog(@"🐳🐳🐳🐳🐳🐳🐳 %s  %p",__FUNCTION__,[self sharedInstance].myAllTaskArray);
    
    [self sharedInstance].myRequestType = LLPOSTRequest;
    return [LLCommonNetworking _POST:url
                         parameters:parameters
                         afnManager:[self sharedInstance].mySessionManager
                     allSessionTask:[self sharedInstance].myAllTaskArray
                          cacheTime:cacheTime
                      responseCache:responseCache
                            progress:nil
                            success:success
                            failure:failure];
}






//---------------------------------------------------------------------------------------------------
#pragma mark ================================== 上传文件 ==================================
//---------------------------------------------------------------------------------------------------
+ (LLNSURLSessionDataTask *)ll_uploadImageWithUrl:(NSString *)urlStr
                                                parameters:(NSDictionary *)parameters
                                                imageArray:(NSArray<UIImage *> *)imageArray
                                                 imageType:(ImageType)imageType
                                          jpegImageQuality:(CGFloat)jpegImageQuality
                                                      name:(NSString *)name
                                            uploadProgress:(LLProgressBlock)uProgress
                                                   success:(LLSuccessBlock)success
                                                   failure:(LLFailedBlock)failure
{
    return [LLUploadNetworking llu_uploadImageWithAFNManager:[self sharedInstance].mySessionManager
                                       allSessionTask:[self sharedInstance].myAllTaskArray
                                                  url:urlStr
                                           parameters:parameters
                                           imageArray:imageArray
                                            imageType:imageType
                                     jpegImageQuality:jpegImageQuality
                                                 name:name
                                       uploadProgress:uProgress
                                              success:success
                                              failure:failure];
}


+ (LLNSURLSessionDataTask *)ll_diyUploadImageWithUrl:(NSString *)urlStr
                                                   parameters:(NSDictionary *)parameters
                                                   imageArray:(NSArray<UIImage *> *)imageArray
                                               imageNameArray:(NSArray<NSString *> *)imageNameArray
                                                    imageType:(ImageType)imageType
                                             jpegImageQuality:(CGFloat)jpegImageQuality
                                                         name:(NSString *)name
                                                     mimeType:(NSString *)mimeType
                                               uploadProgress:(LLProgressBlock)uProgress
                                                      success:(LLSuccessBlock)success
                                                      failure:(LLFailedBlock)failure
{
    return [LLUploadNetworking llu_diyUploadImageWithAFNManager:[self sharedInstance].mySessionManager
                                          allSessionTask:[self sharedInstance].myAllTaskArray
                                                     url:urlStr
                                              parameters:parameters
                                              imageArray:imageArray
                                          imageNameArray:imageNameArray
                                               imageType:imageType
                                        jpegImageQuality:jpegImageQuality
                                                    name:name
                                                mimeType:mimeType
                                          uploadProgress:uProgress
                                                 success:success
                                                 failure:failure];
}


+ (LLNSURLSessionDataTask *)ll_uploadTEXTWithUrl:(NSString *)urlStr
                                               parameters:(NSDictionary *)parameters
                                                  textURL:(NSURL *)textURL
                                                     name:(NSString *)name
                                                 fileName:(NSString *)fileName
                                           uploadProgress:(LLProgressBlock)uProgress
                                                  success:(LLSuccessBlock)success
                                                  failure:(LLFailedBlock)failure
{
    return [LLUploadNetworking llu_uploadTEXTWithAFNManager:[self sharedInstance].mySessionManager
                                      allSessionTask:[self sharedInstance].myAllTaskArray
                                                 url:urlStr
                                          parameters:parameters
                                             textURL:textURL
                                                name:name
                                            fileName:fileName
                                      uploadProgress:uProgress
                                             success:success
                                             failure:failure];
}



+ (LLNSURLSessionDataTask *)ll_uploadVideoWithUrl:(NSString *)urlStr
                                                parameters:(NSDictionary *)parameters
                                                   videoUR:(NSURL *)videoURL
                                                      name:(NSString *)name
                                                 videoType:(VideoType)videoType
                                            uploadProgress:(LLProgressBlock)uProgress
                                                   success:(LLSuccessBlock)success
                                                   failure:(LLFailedBlock)failure
{
    return [LLUploadNetworking llu_uploadVideoWithAFNManager:[self sharedInstance].mySessionManager
                                       allSessionTask:[self sharedInstance].myAllTaskArray
                                                  url:urlStr
                                           parameters:parameters
                                              videoUR:videoURL
                                                 name:name
                                            videoType:videoType
                                       uploadProgress:uProgress
                                              success:success
                                              failure:failure];
}


+ (LLNSURLSessionDataTask *)ll_baseUploadWithUrl:(NSString *)urlStr
                                               parameters:(id)parameters
                                    multipartFileFormData:(LLMultipartFileFormDataBlock)multipartFileFormData
                                           uploadProgress:(LLProgressBlock)uProgress
                                                  success:(LLSuccessBlock)success
                                                  failure:(LLFailedBlock)failure
{
    return [LLUploadNetworking llu_baseUploadWithAFNManager:[self sharedInstance].mySessionManager
                                      allSessionTask:[self sharedInstance].myAllTaskArray
                                                 url:urlStr
                                          parameters:parameters
                               multipartFileFormData:multipartFileFormData
                                      uploadProgress:uProgress
                                             success:success
                                             failure:failure];
}




//---------------------------------------------------------------------------------------------------
#pragma mark ================================== 下载文件 ==================================
//---------------------------------------------------------------------------------------------------






//---------------------------------------------------------------------------------------------------
#pragma mark ================================== 额外配置接口 ==================================
//---------------------------------------------------------------------------------------------------
+ (void)setRequestTimeout:(NSTimeInterval)interval
{
    [self sharedInstance].mySessionManager.requestSerializer.timeoutInterval = interval;
}



+ (void)cancelAllRequest
{
    pthread_mutex_lock(&_lock);
    [[self sharedInstance].myAllTaskArray enumerateObjectsUsingBlock:^(LLNSURLSessionDataTask  *_Nonnull sTask, NSUInteger idx, BOOL * _Nonnull stop) {
        LLLog(@"🐳🐳🐳🐳🐳🐳🐳 取消全部请求-> %@",sTask.currentRequest.URL);
        [sTask cancel];
    }];
    [[self sharedInstance].myAllTaskArray removeAllObjects];
    pthread_mutex_unlock(&_lock);
}


+ (void)cancelRequestByURL:(NSString *)url withParam:(NSDictionary *)param
{
    /**
     *  tip
     * 因为cancelRequestByURL:withParam:的匹配链接是标准格式,所以不支持该格式: 前半段url已经带"?"和部分请求参数, 后半段param中补全后半段请求参数
     * 比如 urlStr=http://www.lilong.cc? parsm=@{@"xxx":@"pw"} 在cancelRequestByURL:withParam:方法中会变成 http://www.lilong.cc?name=zhangsan?pw=xxx(多了个问号)
     */
    pthread_mutex_lock(&_lock);
//    LLLog(@"🐶🐶🐶🐶🐶🐶🐶->%s--->%@",__FUNCTION__,[self sharedInstance].myAllTaskArray);
//    LLLog(@"🐳🐳🐳🐳🐳🐳🐳 🐶🐶🐶🐶🐶---1>%@",[LLNetWorkingUtil getRequestURLWithURL:url parameters:param]);
    NSString *compareStr;
    if([self sharedInstance].myRequestType == LLPOSTRequest)
    {
        compareStr = url;
    }
    else
    {
        compareStr = [LLNetworkingHelperUtil getRequestURLWithURL:url parameters:param];
    }
    
    
    [[self sharedInstance].myAllTaskArray enumerateObjectsUsingBlock:^(LLNSURLSessionDataTask  *_Nonnull sTask, NSUInteger idx, BOOL * _Nonnull stop) {
//    LLLog(@"🐳🐳🐳🐳🐳🐳🐳 🐶🐶🐶🐶🐶---2>%@",sTask.currentRequest.URL.absoluteString);
        if([sTask.currentRequest.URL.absoluteString isEqualToString:compareStr])
        {
            LLLog(@"🐳🐳🐳🐳🐳🐳🐳 🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶🐶->请求被取消");
            [sTask cancel];
            [[self sharedInstance].myAllTaskArray removeObject:sTask];
            *stop = YES;
        }
        
    }];
    pthread_mutex_unlock(&_lock);

}




//设置是否调试打印输出
+(void)setLl_NetworkingDebugEnabled:(BOOL)ll_NetworkingDebugEnabled
{
    if (_ll_NetworkingDebugEnabled != ll_NetworkingDebugEnabled) {
        _ll_NetworkingDebugEnabled = ll_NetworkingDebugEnabled;
    }
}
+(BOOL)ll_NetworkingDebugEnabled
{
    return _ll_NetworkingDebugEnabled;
}



// 进行请求
#pragma mark - 初始化AFHTTPSessionManager相关属性


//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ private methods ================
//-----------------------------------------------------------------------------------------------------------
- (AFHTTPSessionManager *)mySessionManager
{
    if (!_mySessionManager) {
        _mySessionManager = [AFHTTPSessionManager manager];
        _mySessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _mySessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"video/*", nil];
        _mySessionManager.requestSerializer.timeoutInterval = 60; //默认超时时间60s
    }
    return _mySessionManager;
}


- (NSMutableArray *)myAllTaskArray
{
    if (!_myAllTaskArray) {
        _myAllTaskArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _myAllTaskArray;
}





//+ (void)initialize {
//    [self sharedInstance].mySessionManager = [AFHTTPSessionManager manager];
//    // 设置请求的超时时间
//    [self sharedInstance].mySessionManager.requestSerializer.timeoutInterval = 30.f;
//    // 设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
//    [self sharedInstance].mySessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [self sharedInstance].mySessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
//    // 打开状态栏的等待菊花
////    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
//}





@end
