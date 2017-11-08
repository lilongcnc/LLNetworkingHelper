//
//  LLCommonNetworking.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/28.
//  Copyright © 2017年 李龙. All rights reserved.
//



/*
 *********************************************************************************
 *
 *  缓存存在时的策略是, success返回缓存数据, 目的是避免调用地方更新view的代码重复在responseCache添加，并且不再发起请求.
 *
 *********************************************************************************
 */


#import "LLCommonNetworking.h"
#import "AFHTTPSessionManager.h"
#import "LLNetworkingHelperUtil.h"
#import "LLResponseCacheUtil.h"
#import "LLRequestResult.h"


@implementation LLCommonNetworking


+ (LLNSURLSessionDataTask *)_GET:(NSString *)url
                               parameters:(id)parameters
                               afnManager:(AFHTTPSessionManager *)afnManager
                           allSessionTask:(NSMutableArray *)allSessionTask
                                cacheTime:(NSTimeInterval)cacheTime
                            responseCache:(LLCacheBlock)responseCache
                                 progress:(LLProgressBlock)progress
                                  success:(LLSuccessBlock)success
                                  failure:(LLFailedBlock)failure
{
    //请求结果
    LLRequestResult *_requestResult = [LLRequestResult new];
    
    //FIXME:读取缓存!!!
    if(responseCache && cacheTime > 0)
    {
        id cacheResponse = [LLResponseCacheUtil ll_gethttpCacheForURL:url parameters:parameters];
        
        _requestResult.responseCache = cacheResponse;
        LLBLOCK_EXEC(responseCache,_requestResult); //返回数据
        
        if (cacheResponse != nil) {
            _requestResult.responseObject = cacheResponse;
            LLBLOCK_EXEC(success,_requestResult); //缓存存在时的策略是, success返回缓存数据, 目的是避免调用地方更新view的代码重复在responseCache添加;  并且不再发起请求.
            return nil;
        }
    }
    
    
    LLNSURLSessionDataTask *sessionTask
    = (LLNSURLSessionDataTask *)[afnManager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        _requestResult.downloadProgress = downloadProgress;
        LLBLOCK_EXEC(progress,_requestResult);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [allSessionTask removeObject:task];

        _requestResult.responseObject = responseObject;
        LLBLOCK_EXEC(success,_requestResult);
        
        //缓存处理: 对数据进行异步缓存
        if(responseCache && cacheTime > 0)
        {
            responseCache!=nil ? [LLResponseCacheUtil ll_setHttpCache:responseObject URL:url cacheTime:cacheTime parameters:parameters] : nil;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [allSessionTask removeObject:task];
        
        _requestResult.error = error;
        LLBLOCK_EXEC(failure,_requestResult);
        
    }];
    
    // 添加sessionTask到数组
//    sessionTask ? [allSessionTask addObject:sessionTask] : nil;
    !sessionTask ? : [allSessionTask addObject:sessionTask];

    
    return sessionTask;
}





+ (LLNSURLSessionDataTask *)_POST:(NSString *)url
                                parameters:(id)parameters
                                afnManager:(AFHTTPSessionManager *)afnManager
                            allSessionTask:(NSMutableArray *)allSessionTask
                                 cacheTime:(NSTimeInterval)cacheTime
                             responseCache:(LLCacheBlock)responseCache
                                  progress:(LLProgressBlock)progress
                                   success:(LLSuccessBlock)success
                                   failure:(LLFailedBlock)failure
{
    //请求结果
    LLRequestResult *_requestResult = [LLRequestResult new];
    
    //FIXME:读取缓存!!!
    // 缓存处理:
    if(responseCache && cacheTime > 0)
    {
        id cacheResponse = [LLResponseCacheUtil ll_gethttpCacheForURL:url parameters:parameters];
        
        _requestResult.responseCache = cacheResponse;
        LLBLOCK_EXEC(responseCache,_requestResult); //返回数据
        
        if (cacheResponse != nil) {
            _requestResult.responseObject = cacheResponse;
            LLBLOCK_EXEC(success,_requestResult);
            return nil;
        }
    }
    
    
    LLNSURLSessionDataTask *sessionTask
    = (LLNSURLSessionDataTask *)[afnManager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        _requestResult.uploadProgress = uploadProgress;
        LLBLOCK_EXEC(progress,_requestResult);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [allSessionTask removeObject:task];
        
        _requestResult.responseObject = responseObject;
        LLBLOCK_EXEC(success,_requestResult);
        
        //缓存处理: 对数据进行异步缓存
        if(responseCache && cacheTime > 0)
        {
            responseCache!=nil ? [LLResponseCacheUtil ll_setHttpCache:responseObject URL:url cacheTime:cacheTime parameters:parameters] : nil;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [allSessionTask removeObject:task];

        _requestResult.error = error;
        LLBLOCK_EXEC(failure,_requestResult);
        
    }];
    
    // 添加sessionTask到数组
    !sessionTask ? : [allSessionTask addObject:sessionTask];
    
    return sessionTask;
}



@end
