//
//  LLYTKUrlCommonParamsFilter.m
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/6/23.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLYTKUrlCommonParamsFilter.h"
#import "YTKNetworkPrivate.h"


@interface LLYTKUrlCommonParamsFilter ()<YTKUrlFilterProtocol>

@end

@implementation LLYTKUrlCommonParamsFilter{
    NSDictionary *_arguments;
}


+ (LLYTKUrlCommonParamsFilter *)ll_filterWithArguments:(NSDictionary *)arguments{
    return [[self alloc] initWithArgumets:arguments];
}


- (id)initWithArgumets:(NSDictionary *)arguments { //函数名必须为'init'开头,否则不能用 self = [super init];
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}


//重写YTKNetWork的代理方法,设置全局请求参数
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request{
    return [YTKNetworkPrivate urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
}


@end
