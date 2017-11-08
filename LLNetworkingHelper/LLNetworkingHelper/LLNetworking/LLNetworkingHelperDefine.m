//
//  LLNetworkingHelperDefine.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/31.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "LLNetworkingHelperDefine.h"
#import "LLNetAPIworking.h"


void LLLog(NSString *format, ...) {
#ifdef DEBUG
    if (!LLNetAPIworking.ll_NetworkingDebugEnabled) {
        return;
    }
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}



@implementation LLNetworkingHelperDefine

@end
