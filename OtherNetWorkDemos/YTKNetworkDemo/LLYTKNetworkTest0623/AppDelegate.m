//
//  AppDelegate.m
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/6/23.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "AppDelegate.h"
#import "YTKNetworkConfig.h"
#import "LLYTKUrlCommonParamsFilter.h"
#import "YTKNetworkAgent.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setHTTPRequestConfig];
    
    return YES;
}

- (void)setHTTPRequestConfig{
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedInstance];
    //设置全局请求参数
    //(关于CDN:大部分企业应用都需要对一些静态资源（例如图片、js、css）使用CDN。YTKNetworkConfig的cdnUrl参数用于统一设置这一部分网络请求的地址。)
    //Debug url
    config.baseUrl = @"http://192.168.1.194:1800";
    
    config.cdnUrl = @"http://www.lilongcnc.cc"; //http://www.lilongcnc.cc/lauren_picture/20160203/1.png
    
    
    //Release url
//    config.baseUrl = @"set release sever address";
//    config.cdnUrl = @"set release sever CDN address";
    
    //设置全局请求公共参数
//    LLYTKUrlCommonParamsFilter *urlFilter = [LLYTKUrlCommonParamsFilter ll_filterWithArguments:
//                                                @{@"version": @"1.0"}];
    
//    [config addUrlFilter:urlFilter];

    //KVC返回设置contentType
    NSSet *contentTypeSet = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html",@"text/css", nil];
    [[YTKNetworkAgent sharedInstance] setValue:contentTypeSet forKeyPath:@"_manager.responseSerializer.acceptableContentTypes"];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
