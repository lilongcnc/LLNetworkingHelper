//
//  LLNetAPIworking.h
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/6/26.
//  Copyright © 2017年 李龙. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "LLNetworkingHelperDefine.h"
#import "LLRequestResult.h"

//
///** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
//typedef void (^PPHttpProgress)(NSProgress *progress);
//


@interface LLNetAPIworking : NSObject


@property (class,nonatomic,assign) BOOL ll_NetworkingDebugEnabled;

/**
 *  GET请求,无缓存
 */
+ (__kindof LLNSURLSessionDataTask *)ll_GET:(NSString *)url
                        parameters:(id)parameters
                           success:(LLSuccessBlock)success
                           failure:(LLFailedBlock)failure;

/**
 *  GET请求,带缓存
 */
+ (__kindof LLNSURLSessionDataTask *)ll_GET:(NSString *)url
                        parameters:(id)parameters
                         cacheTime:(NSTimeInterval)cacheTime
                     responseCache:(LLCacheBlock)responseCache
                           success:(LLSuccessBlock)success
                           failure:(LLFailedBlock)failure;


/**
 *  GET请求,带缓存
 */
+ (__kindof LLNSURLSessionDataTask *)ll_POST:(NSString *)url
                            parameters:(id)parameters
                               success:(LLSuccessBlock)success
                               failure:(LLFailedBlock)failure;


+ (__kindof LLNSURLSessionDataTask *)ll_POST:(NSString *)url
                         parameters:(id)parameters
                          cacheTime:(NSTimeInterval)cacheTime
                      responseCache:(LLCacheBlock)responseCache
                            success:(LLSuccessBlock)success
                            failure:(LLFailedBlock)failure;




+ (void)setRequestTimeout:(NSTimeInterval)interval;



+ (void)cancelAllRequest;

+ (void)cancelRequestByURL:(NSString *)url withParam:(NSDictionary *)param;








+ (__kindof LLNSURLSessionDataTask *)ll_uploadImageWithUrl:(NSString *)urlStr
                                                parameters:(NSDictionary *)parameters
                                                imageArray:(NSArray<UIImage *> *)imageArray
                                                 imageType:(ImageType)imageType
                                          jpegImageQuality:(CGFloat)jpegImageQuality
                                                      name:(NSString *)name
                                            uploadProgress:(LLProgressBlock)uProgress
                                                   success:(LLSuccessBlock)success
                                                   failure:(LLFailedBlock)failure;

+ (__kindof LLNSURLSessionDataTask *)ll_diyUploadImageWithUrl:(NSString *)urlStr
                                                   parameters:(NSDictionary *)parameters
                                                   imageArray:(NSArray<UIImage *> *)imageArray
                                               imageNameArray:(NSArray<NSString *> *)imageNameArray
                                                    imageType:(ImageType)imageType
                                             jpegImageQuality:(CGFloat)jpegImageQuality
                                                         name:(NSString *)name
                                                     mimeType:(NSString *)mimeType
                                               uploadProgress:(LLProgressBlock)uProgress
                                                      success:(LLSuccessBlock)success
                                                      failure:(LLFailedBlock)failure;

+ (__kindof LLNSURLSessionDataTask *)ll_uploadTEXTWithUrl:(NSString *)urlStr
                                               parameters:(NSDictionary *)parameters
                                                  textURL:(NSURL *)textURL
                                                     name:(NSString *)name
                                                 fileName:(NSString *)fileName
                                           uploadProgress:(LLProgressBlock)uProgress
                                                  success:(LLSuccessBlock)success
                                                  failure:(LLFailedBlock)failure;

+ (__kindof LLNSURLSessionDataTask *)ll_uploadVideoWithUrl:(NSString *)urlStr
                                                parameters:(NSDictionary *)parameters
                                                   videoUR:(NSURL *)videoURL
                                                      name:(NSString *)name
                                                 videoType:(VideoType)videoType
                                            uploadProgress:(LLProgressBlock)uProgress
                                                   success:(LLSuccessBlock)success
                                                   failure:(LLFailedBlock)failure;

+ (__kindof LLNSURLSessionDataTask *)ll_baseUploadWithUrl:(NSString *)urlStr
                                               parameters:(id)parameters
                                    multipartFileFormData:(LLMultipartFileFormDataBlock)multipartFileFormData
                                           uploadProgress:(LLProgressBlock)uProgress
                                                  success:(LLSuccessBlock)success
                                                  failure:(LLFailedBlock)failure;




/**
 *  上传文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param name       文件对应服务器上的字段
 *  @param filePath   文件本地的沙盒路径
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
//+ (__kindof LLNSURLSessionDataTask *)uploadFileWithURL:(NSString *)URL
//                                      parameters:(id)parameters
//                                            name:(NSString *)name
//                                        filePath:(NSString *)filePath
//                                        progress:(PPHttpProgress)progress
//                                         success:(LLSuccessBlock)success
//                                         failure:(LLFailedBlock)failure;


@end
