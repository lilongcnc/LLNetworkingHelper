//
//  LLNetworkingHelperUtil.h
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/28.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLNetworkingHelperUtil : NSObject

+ (NSString *)md5StringFromString:(NSString *)string;


/**
 生成AFN实际请求的URL注意, urlStr这里是指的完整链接中"?"前边的部分,parameters是"?"后边的部分.不按照这个规则来,会造成[取消单个网络请求功能]不能正常执行

 @param urlStr 完整链接中"?"前边的部分
 @param parameters 完整链接中"?"后边的部分
 @return 生成实际请求的URL
 */
+ (NSString *)getRequestURLWithURL:(NSString *)urlStr parameters:(NSDictionary *)parameters;


/**
 避免空参数,实际开发不一定使用

 @param originalParm 原始请求参数
 @return 请求参数
 */
+ (NSDictionary *)getRealRequestParameter:(NSDictionary *)originalParm;

@end
