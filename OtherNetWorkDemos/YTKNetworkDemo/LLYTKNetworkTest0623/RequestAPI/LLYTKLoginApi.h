//
//  LLYTKLoginApi.h
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/6/23.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "YTKRequest.h"
// 登录
@interface LLYTKLoginApi : YTKRequest

- (id)initWithUserName:(NSString *)userName password:(NSString *)password;


- (NSString *)userId;

@end
