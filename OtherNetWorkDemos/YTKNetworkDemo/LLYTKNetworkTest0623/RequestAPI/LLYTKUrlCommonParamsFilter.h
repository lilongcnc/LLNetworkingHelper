//
//  LLYTKUrlCommonParamsFilter.h
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/6/23.
//  Copyright © 2016年 李龙. All rights reserved.
//
//  设置全局请求参数

#import <Foundation/Foundation.h>
#import "YTKBaseRequest.h"
#import "YTKNetworkConfig.h"//YTKUrlFilterProtocol

@interface LLYTKUrlCommonParamsFilter : NSObject<YTKUrlFilterProtocol>

+ (LLYTKUrlCommonParamsFilter *)ll_filterWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;


@end
