//
//  LLNetworkingHelperDefine.h
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/31.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLRequestResult.h"

#define LLBLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); }


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif



FOUNDATION_EXPORT void LLLog(NSString * _Nonnull format, ...) NS_FORMAT_FUNCTION(1,2);




/*----------------------------------------------------------------------------------
 *                      LLNetAPIworking- block define                              *
 ----------------------------------------------------------------------------------*/
//基础网络请求
typedef void(^LLSuccessBlock)(LLRequestResult * _Nonnull requestResult);
typedef void(^LLProgressBlock)(LLRequestResult * _Nonnull requestResult);
typedef void(^LLCacheBlock)(LLRequestResult * _Nonnull requestResult);
typedef void(^LLFailedBlock)(LLRequestResult * _Nonnull requestResult);
typedef void(^LLMultipartFileFormDataBlock)(LLRequestResult * _Nonnull requestResult);


/*----------------------------------------------------------------------------------
 *                      LLNetAPIworking- Enum define                              *
 ----------------------------------------------------------------------------------*/
typedef NS_OPTIONS(NSUInteger, ImageType)
{
    ImageTypeJPEG = 0,
    ImageTypePNG
};

typedef NS_OPTIONS(NSUInteger, VideoType) {
    VideoTypeMOV = 0,
    VideoTypeMP4
};





@interface LLNetworkingHelperDefine : NSObject
@end
