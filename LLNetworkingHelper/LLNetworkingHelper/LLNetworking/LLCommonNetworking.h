//
//  LLCommonNetworking.h
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/28.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLNetworkingHelperDefine.h"
@class AFHTTPSessionManager;

@interface LLCommonNetworking : NSObject

+ (__kindof LLNSURLSessionDataTask *)_GET:(NSString *)url
                               parameters:(id)parameters
                               afnManager:(AFHTTPSessionManager *)afnManager
                           allSessionTask:(NSMutableArray *)allSessionTask
                                cacheTime:(NSTimeInterval)cacheTime
                            responseCache:(LLCacheBlock)responseCache
                                 progress:(LLProgressBlock)progress
                                  success:(LLSuccessBlock)success
                                  failure:(LLFailedBlock)failure;


+ (__kindof LLNSURLSessionDataTask *)_POST:(NSString *)url
                                parameters:(id)parameters
                                afnManager:(AFHTTPSessionManager *)afnManager
                            allSessionTask:(NSMutableArray *)allSessionTask
                                 cacheTime:(NSTimeInterval)cacheTime
                             responseCache:(LLCacheBlock)responseCache
                                  progress:(LLProgressBlock)progress
                                   success:(LLSuccessBlock)success
                                   failure:(LLFailedBlock)failure;

@end
