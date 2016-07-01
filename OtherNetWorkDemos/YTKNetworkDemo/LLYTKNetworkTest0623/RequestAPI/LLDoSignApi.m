


//
//  LLDoSignApi.m
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/6/30.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLDoSignApi.h"

@implementation LLDoSignApi

-(NSString *)requestUrl{
    return @"/deal.ashx";
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPost;
}



-(id)requestArgument{
    return @{
       @"action" : @"signin",
       @"flowId" : @"160630152906958",
       @"CustomerID" : @"C0016050400001",
       @"PosType" : @"1",
       @"fromAPP" : @"IOS",
       @"version" : @"2.0",
       };
}


//- (id)jsonValidator {
//    return @{
//             @"data": @{
//                     @"AccountID" : [NSString class],
//                     @"Address" : [NSString class],
//                     @"Birthday" : [NSString class],
//                     @"Status" : [NSString class],
//                     @"Subs" : [NSArray class],
//                     },
//             @"errorMessage" : [NSString class],
//             @"flag" : [NSString class],
//             };
//    
//}

@end
