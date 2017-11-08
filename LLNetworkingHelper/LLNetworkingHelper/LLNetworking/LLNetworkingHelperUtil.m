//
//  LLNetworkingHelperUtil.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/28.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLNetworkingHelperUtil.h"
#import <CommonCrypto/CommonDigest.h>



@implementation LLNetworkingHelperUtil

+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}




+ (NSString *)getRequestURLWithURL:(NSString *)urlStr parameters:(NSDictionary *)parameters
{
    if(urlStr == nil || urlStr.length == 0 ){return @"转换失败";};
    if(!parameters){return urlStr;};
    
    //拼接字符串
    NSMutableString *TEMP_URL = [[NSMutableString alloc] init];
    [parameters.allKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
         NSString *string;
         if (idx ==0)
         {
             //拼接时加？
             string = [NSString stringWithFormat:@"%@=%@", key, parameters.allValues[idx]];
         }
         else
         {
             //拼接时加&
             string = [NSString stringWithFormat:@"&%@=%@", key, parameters.allValues[idx]];
         }
         //拼接字符串
         [TEMP_URL appendString:string];
     
    }];
    
    //排序
    NSArray *sortAarray = [TEMP_URL componentsSeparatedByString:@"&"];
    NSArray *comparatorSortedArray = [sortAarray sortedArrayUsingComparator:^NSComparisonResult(NSString  *_Nonnull obj1, NSString  * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSString *REAL_AFN_URL = [comparatorSortedArray componentsJoinedByString:@"&"];
    
    
    // 将URL与转换好的参数字符串拼接在一起,成为最终存储的KEY值
    NSString *tempCacheKey = [NSString stringWithFormat:@"%@?%@",urlStr,REAL_AFN_URL];
    return tempCacheKey;
}



/**
 避免空参数
 */
+ (NSDictionary *)getRealRequestParameter:(NSDictionary *)originalParm
{
    for (NSString *key in originalParm.allKeys) {
        if ([key isEqualToString:@""] || !key || !key.length) {
            originalParm=nil;
        }
    }
    return originalParm;
}

/*
 备用测试数据
 //    NSString *TEMP_URL = @"c=ddd&a=1&e=222&dr=222&q=asdsa&f=sddsfds&d=sdfsdfs&ad=dfdsf&ad=ggg&ad=ddd0&ad=acs&af=adafdaf&aea=dafda&aeb=dd&dddd=vvvv&obh=dadada&ccccd=dsada&v=ddddd&z=xxddd&r=99&user=zhangsan&user=zhangaaa";
 
 
 
 //        pthread_mutex_lock(&_lock);
 //        Lock();
 // 解锁
 //        pthread_mutex_unlock(&_lock);
 //        Unlock();
 //    @synchronized(self ) {
 //    }
 */

@end
