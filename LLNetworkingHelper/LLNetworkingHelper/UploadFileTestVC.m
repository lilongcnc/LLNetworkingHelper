//
//  UploadFileTestVC.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/28.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "UploadFileTestVC.h"
#import "LLNetAPIworking.h"

@interface UploadFileTestVC ()
//@property (nonatomic,strong) AFHTTPSessionManager *mySessionManager;

@end

@implementation UploadFileTestVC
{
    NSArray *_imageJPGArray;
    NSArray *_imageJPGNameArray;
    
    NSArray *_imagePNGArray;
    NSArray *_imagePNGNameArray;
    
    NSString *_urlHeader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imageJPGArray = @[[UIImage imageNamed:@"10.jpg"],[UIImage imageNamed:@"11.jpg"],[UIImage imageNamed:@"12.jpg"],[UIImage imageNamed:@"13.jpg"],[UIImage imageNamed:@"14.jpg"],[UIImage imageNamed:@"15.jpg"],[UIImage imageNamed:@"16.jpg"],[UIImage imageNamed:@"17.jpg"]];
    _imageJPGNameArray = @[@"10.jpg",@"11.jpg",@"12.jpg",@"13.jpg",@"14.jpg",@"15.jpg",@"16.jpg",@"17.jpg"];
    
    
    _imagePNGArray = @[[UIImage imageNamed:@"0.png"],[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"5.png"],[UIImage imageNamed:@"6.png"],[UIImage imageNamed:@"7.png"]];
    _imagePNGNameArray = @[@"0.png",@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"7.png"];
    
    
    _urlHeader = @"192.168.2.238";
    
//    _mySessionManager = [AFHTTPSessionManager manager];
//    _mySessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//    _mySessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"video/*", nil];
//    _mySessionManager.requestSerializer.timeoutInterval = 60; //默认超时时间60s

}

//单图上传
- (IBAction)uploadOneImage:(id)sender {
    NSLog(@"上传一个图片");
    /*
     url = @"http://your local url/postupload/upload.php
     name:@"userfile"
     */
    NSString *url = [NSString stringWithFormat:@"http://%@/postupload/upload.php",_urlHeader];
    
    [LLNetAPIworking ll_uploadImageWithUrl:url
                                          parameters:nil
                                          imageArray:@[[UIImage imageNamed:@"big"]]
                                           imageType:ImageTypePNG
                                    jpegImageQuality:0
                                                name:@"userfile"
                                      uploadProgress:^(LLRequestResult * _Nonnull requestResult)
    {
        
        NSLog(@"-- %f",requestResult.uploadProgress.fractionCompleted);
        NSLog(@"-- %lld--%lld",requestResult.uploadProgress.totalUnitCount, requestResult.uploadProgress.totalUnitCount);

    } success:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"成功:%@",requestResult.responseObject);
    } failure:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"失败:%@",requestResult.error);
    }];
    
    //自定义
//    [LLNetAPIworking ll_diyUploadImageWithUrl:url
//                                             parameters:nil
//                                        imageArray:@[[UIImage imageNamed:@"10.jpg"]]
//                                         imageNameArray:@[@"10.jpg"]
//                                              imageType:ImageTypeJPEG
//                                       jpegImageQuality:0.9
//                                                   name:@"userfile"
//                                               mimeType:@"image/jpeg"
//                                         uploadProgress:^(LLRequestResult * _Nonnull requestResult)
//     {
//         NSLog(@"-- %f",requestResult.uploadProgress.fractionCompleted);
//         
//     } success:^(LLRequestResult * _Nonnull requestResult) {
//         NSLog(@"成功:%@",requestResult.responseObject);
//     } failure:^(LLRequestResult * _Nonnull requestResult) {
//         NSLog(@"失败:%@",requestResult.error);
//     }];
    
}


//多图上传
- (IBAction)uploadImageArray:(id)sender {
    NSLog(@"上传一个图片");
    /*
     url = @"http://your local url/postuploadm/upload-m.php
     name:@"userfile[]"
     */
    NSString *url = [NSString stringWithFormat:@"http://%@/postuploadm/upload-m.php",_urlHeader];


    [LLNetAPIworking ll_diyUploadImageWithUrl:url
                                             parameters:nil
                                             imageArray:_imageJPGArray
                                         imageNameArray:_imageJPGNameArray
                                              imageType:ImageTypeJPEG
                                       jpegImageQuality:0.9
                                                   name:@"userfile[]"
                                               mimeType:@"image/jpeg"
                                         uploadProgress:^(LLRequestResult * _Nonnull requestResult)
     {
        NSLog(@"-- %f",requestResult.uploadProgress.fractionCompleted);
        
    } success:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"成功:%@",requestResult.responseObject);
    } failure:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"失败:%@",requestResult.error);
    }];

    // 直接上传
//    [LLNetAPIworking ll_uploadImageWithUrl:url
//                                parameters:nil
//                                imageArray:_imageJPGArray
//                                 imageType:ImageTypePNG
//                          jpegImageQuality:0
//                                      name:@"userfile[]"
//                            uploadProgress:^(LLRequestResult * _Nonnull requestResult)
//     {
//         
//         NSLog(@"-- %f",requestResult.uploadProgress.fractionCompleted);
//         NSLog(@"-- %lld--%lld",requestResult.uploadProgress.totalUnitCount, requestResult.uploadProgress.totalUnitCount);
//         
//     } success:^(LLRequestResult * _Nonnull requestResult) {
//         NSLog(@"成功:%@",requestResult.responseObject);
//     } failure:^(LLRequestResult * _Nonnull requestResult) {
//         NSLog(@"失败:%@",requestResult.error);
//     }];
}

//上传一个日志/文本文件
- (IBAction)ueploadTEXTFile:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"http://%@/postupload/upload.php",_urlHeader];
    NSURL *textUrl=  [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"phone" ofType:@"txt"]];
//    NSURL *txtUrl=  [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"0" ofType:@"pdf"]];

    
    [LLNetAPIworking ll_uploadTEXTWithUrl:url
                               parameters:nil
                                  textURL:textUrl
                                     name:@"userfile"
                                 fileName:@"appdate.txt"
                           uploadProgress:^(LLRequestResult * _Nonnull requestResult)
    {
        NSLog(@"-- %f",requestResult.uploadProgress.fractionCompleted);
        
    } success:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"成功:%@",requestResult.responseObject);
    } failure:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"失败:%@",requestResult.error);
    }];
}


//上传一个视频文件
- (IBAction)uploadVideoFile:(id)sender {
    NSString *url = [NSString stringWithFormat:@"http://%@/postupload/upload.php",_urlHeader];

    NSURL *videoUrl=  [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];

    [LLNetAPIworking ll_uploadVideoWithUrl:url
                                parameters:nil
                                   videoUR:videoUrl
                                      name:@"userfile"
                                 videoType:VideoTypeMP4
                            uploadProgress:^(LLRequestResult * _Nonnull requestResult)
    {
        NSLog(@"-- %f",requestResult.uploadProgress.fractionCompleted);
        
    } success:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"成功:%@",requestResult.responseObject);
    } failure:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"失败:%@",requestResult.error);
    }];
}


//原生方法上传
- (IBAction)DIYUploadImages:(id)sender {
    
    NSString *url = [NSString stringWithFormat:@"http://%@/postuploadm/upload-m.php",_urlHeader];
    
    
    [LLNetAPIworking ll_baseUploadWithUrl:url
                               parameters:nil
                    multipartFileFormData:^(LLRequestResult * _Nonnull requestResult)
    {
     
        //上传单个/多个图片
        [_imagePNGArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImagePNGRepresentation(obj);
            NSLog(@"🐳🐳🐳🐳🐳🐳🐳 --- 完全自定义上传上传第%zd张图片, fileName:%@----------",idx, _imagePNGNameArray[idx]);
            [requestResult.formData appendPartWithFileData:imageData name:@"userfile[]" fileName:_imagePNGNameArray[idx] mimeType:@"image/png"];
        }];
        
        
    } uploadProgress:^(LLRequestResult * _Nonnull requestResult) {
          NSLog(@"-- %f",requestResult.uploadProgress.fractionCompleted);

    } success:^(LLRequestResult * _Nonnull requestResult) {
          NSLog(@"成功:%@",requestResult.responseObject);

    } failure:^(LLRequestResult * _Nonnull requestResult) {
          NSLog(@"失败:%@",requestResult.error);

    }];
}


//取消请求
- (IBAction)cancelTask:(id)sender {
    
    
}


/**
 NSString *url = @"http://apijsy.zhuoyunkeji.com:1800/JoinCustomer.ashx";
 NSDictionary *params = @{
 @"UserAccount" : @"15801538221",
 @"version" : @"3.0",
 @"AccountID" : @"A0717062100006",
 @"BusinessAreaID" : @"BA011703310002",
 @"MemberID" : @"JM071706210005",
 @"action" : @"updateuserheadphoto"
 };
 
 */


@end
