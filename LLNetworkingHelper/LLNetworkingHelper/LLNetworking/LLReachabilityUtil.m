//
//  LLReachabilityUtil.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/6/27.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLReachabilityUtil.h"
#import "AFNetworkReachabilityManager.h"

@implementation LLReachabilityUtil

#pragma mark - 开始监听网络
+ (void)monitorCurrentNetworkStatus:(LLNetworkStatusBlock)networkStatus
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                !networkStatus ? : networkStatus(LLReachableViaUnkown);
//                if (_isOpenLog) LLLog(@"🐳🐳🐳🐳🐳🐳🐳 未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                !networkStatus ? : networkStatus(LLNotReachable);
//                if (_isOpenLog) LLLog(@"🐳🐳🐳🐳🐳🐳🐳 无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                !networkStatus ? : networkStatus(LLReachableViaWWAN);
//                if (_isOpenLog) LLLog(@"🐳🐳🐳🐳🐳🐳🐳 手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                !networkStatus ? : networkStatus(LLReachableViaWiFi);
//                if (_isOpenLog) LLLog(@"🐳🐳🐳🐳🐳🐳🐳 WIFI");
                break;
        }
    }];
}

- (void)saveToModel {
    NSLog(@"%@",@"xxxxx");
}



/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (BOOL)isReachable {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isReachableViaWWAN {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isReachableViaWiFi {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}




@end
