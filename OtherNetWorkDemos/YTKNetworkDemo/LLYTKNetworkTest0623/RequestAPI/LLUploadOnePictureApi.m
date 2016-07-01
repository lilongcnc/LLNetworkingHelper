//
//  LLUploadOnePictureApi.m
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/7/1.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLUploadOnePictureApi.h"

@implementation LLUploadOnePictureApi{
    UIImage *_image;
}

- (id)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPost;
}

- (NSString *)requestUrl {
    return @"/deal.ashx";
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSData *data = UIImageJPEGRepresentation(_image, 0.9);
        NSString *fileName = @"photo.png";
        NSString *formKey = @"data";
        NSString *mimeType = @"image/png";
        /**
         猿题库原来是这种类型
         NSString *name = @"image";
         NSString *formKey = @"image";
         NSString *type = @"image/jpeg";
         */
        [formData appendPartWithFileData:data name:formKey fileName:fileName mimeType:mimeType];
    };
}

- (id)requestArgument{
    return @{
             @"action" : @"uploadphoto",
             @"CustomerID" : @"C0016050400001",
             @"Type" : @"OfflineProduct",
             @"flowId" : @"160628100654295",
             };
}


//- (id)jsonValidator {
//    return @{ @"imageId": [NSString class] };
//}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"imageId"];
}


@end
