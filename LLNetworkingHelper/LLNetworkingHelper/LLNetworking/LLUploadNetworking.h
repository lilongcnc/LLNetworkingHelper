//
//  LLUploadNetworking.h
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/28.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLNetworkingHelperDefine.h"
@class AFHTTPSessionManager;

//typedef NS_OPTIONS(NSUInteger, NetworkingUploadType) {
//  NetworkingUploadTypeImage = 0,  //上传图片
//  NetworkingUploadTypeVideo,      //上传视频
//  NetworkingUploadTypeText        //上传文本
//};


@interface LLUploadNetworking : NSObject

+ (__kindof LLNSURLSessionDataTask *)llu_uploadImageWithAFNManager:(AFHTTPSessionManager *)afnManager
                       allSessionTask:(NSMutableArray *)allSessionTask
                                  url:(NSString *)urlStr
                           parameters:(NSDictionary *)parameters
                           imageArray:(NSArray<UIImage *> *)imageArray
                            imageType:(ImageType)imageType
                     jpegImageQuality:(CGFloat)jpegImageQuality
                                 name:(NSString *)name
                       uploadProgress:(LLProgressBlock)uProgress
                              success:(LLSuccessBlock)success
                              failure:(LLFailedBlock)failure;

+ (__kindof LLNSURLSessionDataTask *)llu_diyUploadImageWithAFNManager:(AFHTTPSessionManager *)afnManager
                          allSessionTask:(NSMutableArray *)allSessionTask
                                     url:(NSString *)urlStr
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

+ (__kindof LLNSURLSessionDataTask *)llu_uploadTEXTWithAFNManager:(AFHTTPSessionManager *)afnManager
                      allSessionTask:(NSMutableArray *)allSessionTask
                                 url:(NSString *)urlStr
                          parameters:(NSDictionary *)parameters
                             textURL:(NSURL *)textURL
                                name:(NSString *)name
                            fileName:(NSString *)fileName
                      uploadProgress:(LLProgressBlock)uProgress
                             success:(LLSuccessBlock)success
                             failure:(LLFailedBlock)failure;

+ (__kindof LLNSURLSessionDataTask *)llu_uploadVideoWithAFNManager:(AFHTTPSessionManager *)afnManager
                       allSessionTask:(NSMutableArray *)allSessionTask
                                  url:(NSString *)urlStr
                           parameters:(NSDictionary *)parameters
                              videoUR:(NSURL *)videoURL
                                 name:(NSString *)name
                            videoType:(VideoType)videoType
                       uploadProgress:(LLProgressBlock)uProgress
                              success:(LLSuccessBlock)success
                              failure:(LLFailedBlock)failure;

+ (__kindof LLNSURLSessionDataTask *)llu_baseUploadWithAFNManager:(AFHTTPSessionManager *)afnManager
                      allSessionTask:(NSMutableArray *)allSessionTask
                                 url:(NSString *)urlStr
                          parameters:(id)parameters
               multipartFileFormData:(LLMultipartFileFormDataBlock)multipartFileFormData
                      uploadProgress:(LLProgressBlock)uProgress
                             success:(LLSuccessBlock)success
                             failure:(LLFailedBlock)failure;

@end
