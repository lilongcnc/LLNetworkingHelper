

//
//  LLYTKGetImageApi.m
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/6/24.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLYTKGetImageApi.h"

@implementation LLYTKGetImageApi{
    NSString *_imageName;
}


- (id)initWithImageId:(NSString *)imageName{
    self = [super init];
    
    if (self) {
        _imageName = imageName;
    }
    
    return self;
}



- (NSString *)requestUrl {
    //http://www.lilongcnc.cc/lauren_picture/20160203/1.png
    
    return [NSString stringWithFormat:@"/lauren_picture/20160426/%@", _imageName];
    ///lauren_picture/20160426/1.png
    ///lauren_picture/20160218/1.gif
}

- (BOOL)useCDN {
    return YES;
}

//
//- (NSString *)resumableDownloadPath {
//    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *cachePath = [libPath stringByAppendingPathComponent:@"Caches"];
//    NSString *filePath = [cachePath stringByAppendingPathComponent:_imageName];
//    NSLog(@"save image path->%@",filePath);
//    return filePath;
//}




@end
