//
//  LLUploadNetworking.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/28.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLUploadNetworking.h"
#import "AFHTTPSessionManager.h"
#import "LLRequestResult.h"


@interface LLUploadNetworking ()
@end

@implementation LLUploadNetworking

+ (LLUploadNetworking *)sharedInstance {
    static LLUploadNetworking *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [self new];
    });
    
    return _sharedManager;
}



//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ upload images ================
//-----------------------------------------------------------------------------------------------------------
// 不设置属性: 简易上传单个/多个图片
+ (LLNSURLSessionDataTask *)llu_uploadImageWithAFNManager:(AFHTTPSessionManager *)afnManager
                                                    allSessionTask:(NSMutableArray *)allSessionTask
                                                               url:(NSString *)urlStr
                                                        parameters:(NSDictionary *)parameters
                                                        imageArray:(NSArray<UIImage *> *)imageArray
                                                         imageType:(ImageType)imageType
                                                  jpegImageQuality:(CGFloat)jpegImageQuality
                                                              name:(NSString *)name
                                                    uploadProgress:(LLProgressBlock)uProgress
                                                           success:(LLSuccessBlock)success
                                                           failure:(LLFailedBlock)failure
{

    NSArray<UIImage *> *rImageArray = [imageArray copy];

    return [[self sharedInstance] _baseUploadWithAFNManager:afnManager
                                             allSessionTask:allSessionTask
                                                        url:urlStr
                                                 parameters:parameters
                                      multipartFileFormData:^(LLRequestResult * _Nonnull requestResult)
    {
        
        [rImageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData;
            if (imageType == ImageTypeJPEG)
            {
                imageData = UIImageJPEGRepresentation(obj, jpegImageQuality);
            }
            else
            {
                imageData = UIImagePNGRepresentation(obj);
            }
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *rfileName = [NSString  stringWithFormat:@"uploadImage_%zd_%@.%@", idx, dateString,ImageTypeSuffixStringMapping[imageType]];
            
            [requestResult.formData appendPartWithFileData:imageData name:name fileName:rfileName mimeType:[self _mimeTypeForImage:imageType]];
        }];
        
    } uploadProgress:uProgress success:success failure:failure];
    
}


//自定义属性，上传单个或者多个图片
+ (LLNSURLSessionDataTask *)llu_diyUploadImageWithAFNManager:(AFHTTPSessionManager *)afnManager
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
                                 failure:(LLFailedBlock)failure

{
    
    if (imageArray.count != imageNameArray.count) {  return nil;}
    
     NSArray<UIImage *> *rImageArray = [imageArray copy];
     NSArray<NSString *> *rimageNameArray = [imageNameArray copy];
    
    return [[self sharedInstance] _baseUploadWithAFNManager:afnManager
                                             allSessionTask:allSessionTask
                                                        url:urlStr
                                                 parameters:parameters
                                      multipartFileFormData:^(LLRequestResult * _Nonnull requestResult)
    {
        
        [rImageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData;
            if (imageType == ImageTypeJPEG)
            {
                imageData = UIImageJPEGRepresentation(obj, jpegImageQuality);
            }
            else
            {
                imageData = UIImagePNGRepresentation(obj);
            }
            NSLog(@"🐳🐳🐳🐳🐳🐳🐳 --- 上传第%zd张图片 name:%@, fileName:%@----------",idx, name, rimageNameArray[idx]);
            [requestResult.formData appendPartWithFileData:imageData name:name fileName:rimageNameArray[idx] mimeType:mimeType];
        }];
        
    } uploadProgress:uProgress success:success failure:failure];

}








//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ Methods that limit parameters of upload text file ================
//-----------------------------------------------------------------------------------------------------------
//不设置属性: 上传文本文件
+ (LLNSURLSessionDataTask *)llu_uploadTEXTWithAFNManager:(AFHTTPSessionManager *)afnManager
                                                   allSessionTask:(NSMutableArray *)allSessionTask
                                                              url:(NSString *)urlStr
                                                       parameters:(NSDictionary *)parameters
                                                          textURL:(NSURL *)textURL
                                                             name:(NSString *)name
                                                         fileName:(NSString *)fileName
                                                   uploadProgress:(LLProgressBlock)uProgress
                                                          success:(LLSuccessBlock)success
                                                          failure:(LLFailedBlock)failure
{

    return [[self sharedInstance] _baseUploadWithAFNManager:afnManager
                                             allSessionTask:allSessionTask
                                                        url:urlStr
                                                 parameters:parameters
                                      multipartFileFormData:^(LLRequestResult * _Nonnull requestResult)
    {
        
        NSData *videoData = [NSData dataWithContentsOfURL:textURL];
        [requestResult.formData appendPartWithFileData:videoData name:name fileName:fileName mimeType:@"text/*"];
        
    } uploadProgress:uProgress success:success failure:failure];
    
}



//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ Methods that limit parameters of upload Videos ================
//-----------------------------------------------------------------------------------------------------------
// 不设置属性: 简上传视频文件
+ (LLNSURLSessionDataTask *)llu_uploadVideoWithAFNManager:(AFHTTPSessionManager *)afnManager
                                                    allSessionTask:(NSMutableArray *)allSessionTask
                                                               url:(NSString *)urlStr
                                                        parameters:(NSDictionary *)parameters
                                                           videoUR:(NSURL *)videoURL
                                                              name:(NSString *)name
                                                         videoType:(VideoType)videoType
                                                    uploadProgress:(LLProgressBlock)uProgress
                                                           success:(LLSuccessBlock)success
                                                           failure:(LLFailedBlock)failure
{
    
    return [[self sharedInstance] _baseUploadWithAFNManager:afnManager
                                             allSessionTask:allSessionTask
                                                        url:urlStr
                                                 parameters:parameters
                                      multipartFileFormData:^(LLRequestResult * _Nonnull requestResult)
    {
    
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        //多图上传时, 文件名字一定不要重名,保持一个图片一个名字,这里默认使用 [upload_yyyyMMddHHmmss.png/jpg] 形式
        //设置图片名字
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *rfileName = [NSString  stringWithFormat:@"uploadVideo_%@.%@", dateString,VideoTypeSuffixStringMapping[videoType]];
        
        [requestResult.formData appendPartWithFileData:videoData name:name fileName:rfileName mimeType:[self _mimeTypeForVideo:videoType]];
        
        
    } uploadProgress:uProgress success:success failure:failure];
    
}



//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ original methods of AFN ================
//-----------------------------------------------------------------------------------------------------------
+ (LLNSURLSessionDataTask *)llu_baseUploadWithAFNManager:(AFHTTPSessionManager *)afnManager
                      allSessionTask:(NSMutableArray *)allSessionTask
                                 url:(NSString *)urlStr
                          parameters:(id)parameters
               multipartFileFormData:(LLMultipartFileFormDataBlock)multipartFileFormData
                      uploadProgress:(LLProgressBlock)uProgress
                             success:(LLSuccessBlock)success
                             failure:(LLFailedBlock)failure
{
   return [[self sharedInstance] _baseUploadWithAFNManager:afnManager
                                            allSessionTask:allSessionTask
                                                 url:urlStr
                                          parameters:parameters
                               multipartFileFormData:multipartFileFormData
                                      uploadProgress:uProgress
                                             success:success
                                             failure:failure];
    
}




//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ base methods ================
//-----------------------------------------------------------------------------------------------------------
- (LLNSURLSessionDataTask *)_baseUploadWithAFNManager:(AFHTTPSessionManager *)afnManager
                                       allSessionTask:(NSMutableArray *)allSessionTask
                                                  url:(NSString *)urlStr
                                           parameters:(id)parameters
                                multipartFileFormData:(LLMultipartFileFormDataBlock)multipartFileFormDataBase
                                       uploadProgress:(LLProgressBlock)uProgressBase
                                              success:(LLSuccessBlock)successBase
                                              failure:(LLFailedBlock)failureBase
{
    
    LLRequestResult *requestResult = [LLRequestResult new];
    
    LLNSURLSessionDataTask *sessionTask
    = (LLNSURLSessionDataTask *)
    [afnManager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        requestResult.formData = formData;
        LLBLOCK_EXEC(multipartFileFormDataBase,requestResult);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        requestResult.uploadProgress = uploadProgress;
        LLBLOCK_EXEC(uProgressBase,requestResult);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        requestResult.successTtask = (LLNSURLSessionDataTask *)task;
        requestResult.responseObject = responseObject;
        LLBLOCK_EXEC(successBase,requestResult);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        requestResult.error = error;
        requestResult.errorTask = (LLNSURLSessionDataTask *)task;
        LLBLOCK_EXEC(failureBase,requestResult);
        
    }];
    
    !sessionTask ? : [allSessionTask addObject:sessionTask];
    
    return sessionTask;
}


//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ private methods ================
//-----------------------------------------------------------------------------------------------------------
static NSString  * const  ImageTypeSuffixStringMapping[] = {
    [ImageTypeJPEG] = @"jpg",
    [ImageTypePNG] = @"png",
};

static NSString  * const  VideoTypeSuffixStringMapping[] = {
    [VideoTypeMOV] = @"mov",
    [VideoTypeMP4] = @"mp4",
};

+ (NSString *)_mimeTypeForImage:(ImageType)imageType
{
    if (imageType == ImageTypeJPEG)
    {
        return @"image/jpeg";
    }
    else
    {
        return @"image/png";
    }
}


+ (NSString *)_mimeTypeForVideo:(VideoType)videoType
{
    if (videoType == VideoTypeMOV)
    {
        return @"image/mov";
    }
    else
    {
        return @"image/mp4";
    }
}

@end
