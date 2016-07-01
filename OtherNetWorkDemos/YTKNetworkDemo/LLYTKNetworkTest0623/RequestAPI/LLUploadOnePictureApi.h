//
//  LLUploadOnePictureApi.h
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/7/1.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "YTKRequest.h"

@interface LLUploadOnePictureApi : YTKRequest

- (id)initWithImage:(UIImage *)image;

- (NSString *)responseImageId;

@end
