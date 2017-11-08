//
//  LLNetReachabilityHelper.h
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/6/27.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LLNetworkStatus) {
    /** 未知网络*/
    LLReachableViaUnkown,
    /** 无网络*/
    LLNotReachable,
    /** 手机网络*/
    LLReachableViaWWAN,
    /** WIFI网络*/
    LLReachableViaWiFi
};

/** 网络状态的Block*/
typedef void(^LLNetworkStatusBlock)(LLNetworkStatus status);


@interface LLReachabilityUtil : NSObject

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)monitorCurrentNetworkStatus:(LLNetworkStatusBlock)networkStatus;

+ (BOOL)isReachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;

@end
