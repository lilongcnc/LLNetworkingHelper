//
//  LLRequestResult.h
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/31.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"
NS_ASSUME_NONNULL_BEGIN

@interface LLNSURLSessionDataTask : NSURLSessionDataTask

@end


@interface LLRequestResult : NSObject

@property (nonatomic, strong) id _Nullable responseObject;
@property (nonatomic, strong) id _Nullable responseCache;
@property (nonatomic, strong) NSError * error;
@property (nonatomic, strong) NSProgress * _Nullable uploadProgress;
@property (nonatomic, strong) NSProgress * _Nullable downloadProgress;
@property (nonatomic, strong) LLNSURLSessionDataTask * _Nullable successTtask;
@property (nonatomic, strong) LLNSURLSessionDataTask * _Nullable errorTask;
@property (nonatomic, strong) id<AFMultipartFormData> formData;

@end

NS_ASSUME_NONNULL_END

