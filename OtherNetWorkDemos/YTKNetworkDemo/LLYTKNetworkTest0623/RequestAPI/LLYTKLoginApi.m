//
//  LLYTKLoginApi.m
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/6/23.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLYTKLoginApi.h"

@implementation LLYTKLoginApi{
    NSString *_userName;
    NSString *_password;
}


-(id)initWithUserName:(NSString *)userName password:(NSString *)password{
    self = [super init];
    if (self) {
        _userName = userName;
        _password = password;
    }
    return self;
}

//-------------------------- 重写YTKRequest中方法,设置请求相关事宜 --------------------------

//htt://192.168.1.194:1800/JoinCustomer.ashx?action=login&userAccount=15801538221&Passwd=E10ADC3949BA59ABBE56E057F20F883E&version=1.0&BusinessAreaID=

//设置 http://192.168.1.194:1800/JoinCustomer.ashx? 剩下的网址信息
- (NSString *)requestUrl{
    return @"/JoinCustomer.ashx";
}


//设置请求方式:POST或者是GET
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}


- (id)requestArgument{
    return @{
             @"action" : @"login",
             @"userAccount" : _userName,
             @"Passwd" : _password,
             @"version" : @"1.0",
             };
}

- (id)responseJSONObject {
    return self.requestOperation.responseObject;
}

//- (YTKRequestSerializerType)requestSerializerType {
//    return YTKRequestSerializerTypeHTTP | YTKRequestSerializerTypeJSON;
//}

////按时间缓存内容
//- (NSInteger)cacheTimeInSeconds {
//    // 3分钟 = 180 秒
//    return 60 * 3;
//}


//验证返回数据格式
//- (id)jsonValidator {
//    return @{
//             @"data": @{
//                         @"AccountID" : [NSString class],
//                         @"Address" : [NSString class],
//                         @"Birthday" : [NSString class],
//                         @"BusinessAreaID" : [NSString class],
//                         @"City" : [NSString class],
//                         @"Credit" : [NSString class],
//                         @"Email" : [NSString class],
//                         @"HeadPhoto" : [NSString class],
//                         @"IDs" : [NSString class],
//                         @"IsPromotion" : [NSString class],
//                         @"MemberID" : [NSString class],
//                         @"MobilePhone" : [NSString class],
//                         @"Name" : [NSString class],
//                         @"P2PAccountID" : [NSString class],
//                         @"P2PMemberID" : [NSString class],
//                         @"PostCode" : [NSString class],
//                         @"Provice" : [NSString class],
//                         @"SelfPromotionID" : [NSString class],
//                         @"Sex" : [NSString class],
//                         @"SoloCredit" : [NSString class],
//                         @"Status" : [NSString class],
//                         @"Subs" : [NSArray class],
//                     },
//                 @"errorMessage" : [NSString class],
//                 @"flag" : [NSString class],
//             };
//
//}


//获取返回的数据
- (NSString *)userId {
//    NSLog(@"%s  %@",__FUNCTION__,[self responseJSONObject]);
    return self.responseJSONObject[@"data"][@"AccountID"];
}


@end
