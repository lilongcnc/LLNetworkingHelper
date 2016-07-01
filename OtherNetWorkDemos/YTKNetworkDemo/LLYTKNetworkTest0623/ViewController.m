//
//  ViewController.m
//  LLYTKNetworkTest0623
//
//  Created by 李龙 on 16/6/23.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "ViewController.h"
#import "LLYTKLoginApi.h"
#import "LLYTKGetImageApi.h"
#import "YTKBatchRequest.h"
#import "YTKChainRequest.h"
#import "LLDoSignApi.h"
#import "LLUploadOnePictureApi.h"
#import "MenuView.h"

//避免宏循环引用
#define LLWeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define LLStrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
#define LLKeyWindowSize [UIScreen mainScreen].bounds.size



static NSDictionary *dictFromJsonData(NSData *returnData){
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
    return content;
}



@interface ViewController ()<YTKChainRequestDelegate>

@property (nonatomic,strong) MenuView *menuView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

- (void)initSubViews{
    _menuView = ({
        MenuView *menuView = [[MenuView alloc] initWithFrame:(CGRect){0,0,LLKeyWindowSize.width,LLKeyWindowSize.height}];
        [self.view addSubview:menuView];
        @LLWeakObj(self);
        [menuView setMenuViewOnClick:^(NSString *title) {
            @LLStrongObj(self);
            if ([title isEqualToString:@"登录"]) {
                [self ll_loginRequest];
            }else if ([title isEqualToString:@"签到"]) {
                [self ll_doSignRequest];
            }
            else if ([title isEqualToString:@"单图上传"]) {
                [self ll_uploadOnePicture];
            }else if ([title isEqualToString:@"多图上传"]) {
//                [self ll_morePicturesUpload];
            }else if ([title isEqualToString:@"单个图片下载"]) {
                [self ll_downLoadOnePictureRequest];
            }else if ([title isEqualToString:@"batch"]) {
                [self ll_batchRequest];
            }else if ([title isEqualToString:@"chain"]) {
                [self ll_chainRequest];
            }else if ([title isEqualToString:@"先用缓存后请求"]) {
                [self ll_loadLoginCacheData];
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }else if ([title isEqualToString:@""]) {
            }
            
        }];
        menuView;
    });
    
}
#pragma mark ================ 上传单个文件 ================
- (void)ll_uploadOnePicture{
    
    LLUploadOnePictureApi *upOnePictureApi = [[LLUploadOnePictureApi alloc] initWithImage:[UIImage imageNamed:@"1"]];

    [upOnePictureApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"loadLoginCacheData new Data:%@",request.responseJSONObject);

    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"loadLoginCacheData falied:%@",request);

    }];
}


#pragma mark ================ 优先获取缓存 ================
- (void)ll_loadLoginCacheData {
    
    LLYTKLoginApi *loginApi = [[LLYTKLoginApi alloc] initWithUserName:@"15801538221" password:@"E10ADC3949BA59ABBE56E057F20F883E"];
    
    //cacheJson必须实现 - (NSInteger)cacheTimeInSeconds 方法,注意这个时候请求不是每次都有的.在规定时间间隔之后才能再次发起请求
    if ([loginApi cacheJson]) {
        NSDictionary *json = [loginApi cacheJson];
        NSLog(@"json = %@", json);
        // show cached data
    }
    
    [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        NSLog(@"update ui");
        NSLog(@"loadLoginCacheData new Data:%@",request.responseJSONObject);
        
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"failed");
    }];
}



#pragma mark ================ chainReuqest 及其回调方法 ================
- (void)ll_chainRequest {

    LLYTKLoginApi *reg = [[LLYTKLoginApi alloc] initWithUserName:@"15801538221" password:@"E10ADC3949BA59ABBE56E057F20F883E"];
    YTKChainRequest *chainReq = [[YTKChainRequest alloc] init];
    
    [chainReq addRequest:reg callback:^(YTKChainRequest *chainRequest, YTKBaseRequest *baseRequest) {
        
        //第一个请求完成
        LLYTKLoginApi *result = (LLYTKLoginApi *)baseRequest;
//        NSLog(@"%@",dictFromJsonData(baseRequest.responseData));
        NSString *userId = [result userId];
        
        NSLog(@"----------------------------------------------------------------------------------------------------------------------");
        if ([userId isEqualToString:@"A0C16050300001"]) {//-1
            //开始下载图片
            LLDoSignApi *doSignApi = [[LLDoSignApi alloc] init];
            [chainRequest addRequest:doSignApi callback:nil];
        }
        
    }];
    chainReq.delegate = self;
    // start to send request
    [chainReq start];
}


- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
    // all requests are done
    NSLog(@"----------------------------------------------------------------------------------------------------------------------");
    NSLog(@"🐷chainRequestFinished:%@",chainRequest.requestArray);
    NSArray *requests = chainRequest.requestArray;
    LLYTKLoginApi *a = (LLYTKLoginApi *)requests[0];
    
    NSLog(@"🐷chain the 0 request result: %@",a.responseJSONObject);
    
    if(requests.count ==  1) return;
    LLDoSignApi *b = (LLDoSignApi *)requests[1];
    NSLog(@"🐷chain the 1 request result: %@",b.responseJSONObject);

}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
    // some one of request is failed
    // 通过对见过的检查来模拟其中一个请求失败的情况
    NSLog(@"----------------------------------------------------------------------------------------------------------------------");
    NSLog(@"🐷chainRequestFailed:%@------%@",chainRequest.requestArray,request);
    NSArray *requests = chainRequest.requestArray;
    LLYTKLoginApi *a = (LLYTKLoginApi *)requests[0];
    
    NSLog(@"🐷chain the 0 request result: %@",a.responseJSONObject);
    
    if(requests.count ==  1) return;
    LLDoSignApi *b = (LLDoSignApi *)requests[1];
    NSLog(@"🐷chain the 1 request result: %@",b.responseJSONObject);
}


#pragma mark ================ batchRequest ================
- (void)ll_batchRequest {
    
    
    LLYTKLoginApi *a = [[LLYTKLoginApi alloc] initWithUserName:@"15801538221" password:@"E10ADC3949BA59ABBE56E057F20F883E"];
    LLDoSignApi *b = [[LLDoSignApi alloc] init];
    
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[a, b]];
    
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSLog(@"batch succeed->%@",batchRequest.requestArray);
        
        NSArray *requests = batchRequest.requestArray;
        LLYTKLoginApi *a = (LLYTKLoginApi *)requests[0];
        
        NSLog(@"batch the 0 request result: %@",a.responseJSONObject);
        
        LLDoSignApi *b = (LLDoSignApi *)requests[1];
        NSLog(@"batch the 1 request result: %@",b.responseJSONObject);
        
        // deal with requests result ...
        
        
        
    } failure:^(YTKBatchRequest *batchRequest) {
        NSLog(@"failed");
    }];
}



#pragma mark ================ 使用CDN加载图片 ================
- (void) ll_downLoadOnePictureRequest{
    LLYTKGetImageApi *imageApi = [[LLYTKGetImageApi alloc] initWithImageId:@"1.png"];
    
    [imageApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        [self showResultLog:request];
//        [self showResultLog:request];
        NSLog(@"request.responseJSONObject:%@",request.responseJSONObject);
        UIImage *image = [UIImage imageWithData:request.responseData];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 300, 350, 100)];
        imageView.image = image;
        [self.view addSubview:imageView];
        
    } failure:^(__kindof YTKBaseRequest *request) {
        
    }];
    
    
}




#pragma mark ================ 登陆验证 ================
//htt://192.168.1.194:1800/JoinCustomer.ashx?action=login&userAccount=15801538221&Passwd=E10ADC3949BA59ABBE56E057F20F883E&version=1.0&BusinessAreaID=
- (void)ll_loginRequest{
    

    //如果实现 - (NSInteger)cacheTimeInSeconds 方法,注意这个时候请求不是每次都有的.在规定时间间隔之后才能再次发起请求
    LLYTKLoginApi *loginApi = [[LLYTKLoginApi alloc] initWithUserName:@"15801538221" password:@"E10ADC3949BA59ABBE56E057F20F883E"];
    
    [loginApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        //注意：你可以直接在block回调中使用 self，不用担心循环引用。因为 YTKRequest 会在执行完 block 回调之后，将相应的 block 设置成 nil。从而打破循环引用
//        [self showResultLog:request];
        //dictFromJsonData(request.responseData)
        NSLog(@"login result ->%@",request.responseJSONObject);
        
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"LLYTKLoginApi failed");
        
    }];
}


- (void)ll_doSignRequest{
    
    //发送请求
    LLDoSignApi *doSignApi = [[LLDoSignApi alloc] init];
    
    [doSignApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        
        NSLog(@"login result ->%@",dictFromJsonData(request.responseData));
        
        
    } failure:^(__kindof YTKBaseRequest *request) {
        NSLog(@"LLYTKLoginApi failed");
        
    }];
}





- (void)showResultLog:(YTKBaseRequest *)request{
    NSLog(@"+++++++++++++++++++++++++++++ 华丽的分割线 +++++++++++++++++++++++++++");
    NSLog(@"LLYTKLoginApi successed-userInfo: %@",request.userInfo);
    NSLog(@"LLYTKLoginApi successed-responseData: %@",request.responseData);
    NSLog(@"LLYTKLoginApi successed-requestOperation: %@",request.requestOperation);
    NSLog(@"LLYTKLoginApi successed-responseJSONObject: %@",request.responseJSONObject);
    NSLog(@"LLYTKLoginApi successed-request.responseString: %@",request.responseString);
    NSLog(@"LLYTKLoginApi successed-responseHeaders: %@",request.responseHeaders);
    NSLog(@"LLYTKLoginApi successed-requestAccessories: %@",request.requestAccessories);
}



@end
