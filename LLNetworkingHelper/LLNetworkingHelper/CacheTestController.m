//
//  CacheTestController.m
//  LLNetworking
//
//  Created by 李龙 on 2017/6/26.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "CacheTestController.h"
#import "LLNetAPIworking.h"
#import "LLTools.h"

/*
 *********************************************************************************
 *
 *  方法1,3,5 和 方法2,4,6两组分别采用两个请求
 *
 *********************************************************************************
 */


@interface CacheTestController ()

@property (weak, nonatomic) IBOutlet UITextView *networkData;
@property (weak, nonatomic) IBOutlet UITextView *cacheData;

@property (nonatomic,strong) NSArray *urlArray;
@property (nonatomic,strong) NSArray *paramArray;

@end

@implementation CacheTestController



- (IBAction)requestOne:(id)sender {
    self.networkData.text = @"";
    self.cacheData.text = @"";
    [LLNetAPIworking ll_GET:_urlArray[0] parameters:_paramArray[0] cacheTime:5 responseCache:^(LLRequestResult * _Nonnull requestResult) {
        // 1.先加载缓存数据
        self.cacheData.text = [LLTools jsonToString:requestResult.responseCache];
    } success:^(LLRequestResult * _Nonnull requestResult) {
        // 2.再请求网络数据
        self.networkData.text = [LLTools jsonToString:requestResult.responseObject];
    } failure:^(LLRequestResult * _Nonnull requestResult) {
        
    }];
}


- (IBAction)requestTwo:(id)sender {
    self.networkData.text = @"";
    self.cacheData.text = @"";
    [LLNetAPIworking ll_GET:_urlArray[1] parameters:_paramArray[1] cacheTime:10 responseCache:^(LLRequestResult * _Nonnull requestResult) {
        // 1.先加载缓存数据
        self.cacheData.text = [LLTools jsonToString:requestResult.responseCache];
    } success:^(LLRequestResult * _Nonnull requestResult) {
        // 2.再请求网络数据
        self.networkData.text = [LLTools jsonToString:requestResult.responseObject];
    } failure:^(LLRequestResult * _Nonnull requestResult) {
        
    }];
}


- (IBAction)requestThree:(id)sender {
    self.networkData.text = @"";
    self.cacheData.text = @"";
    [LLNetAPIworking ll_POST:_urlArray[2] parameters:_paramArray[2] cacheTime:5 responseCache:^(LLRequestResult * _Nonnull requestResult) {
        // 1.先加载缓存数据
        self.cacheData.text = [LLTools jsonToString:requestResult.responseCache];
    } success:^(LLRequestResult * _Nonnull requestResult) {
        // 2.再请求网络数据
        self.networkData.text = [LLTools jsonToString:requestResult.responseObject];
    } failure:^(LLRequestResult * _Nonnull requestResult) {
        
    }];
}


- (IBAction)requestFour:(id)sender {
    self.networkData.text = @"";
    self.cacheData.text = @"";
    [LLNetAPIworking ll_POST:_urlArray[3] parameters:_paramArray[3] cacheTime:10 responseCache:^(LLRequestResult * _Nonnull requestResult) {
        // 1.先加载缓存数据
        self.cacheData.text = [LLTools jsonToString:requestResult.responseCache];
    } success:^(LLRequestResult * _Nonnull requestResult) {
        // 2.再请求网络数据
        self.networkData.text = [LLTools jsonToString:requestResult.responseObject];
    } failure:^(LLRequestResult * _Nonnull requestResult) {
        
    }];

}


- (IBAction)requestFive:(id)sender {
    self.networkData.text = @"";
    self.cacheData.text = @"";
    [LLNetAPIworking ll_POST:_urlArray[4] parameters:_paramArray[4] cacheTime:60 responseCache:^(LLRequestResult * _Nonnull requestResult) {
        // 1.先加载缓存数据
        self.cacheData.text = [LLTools jsonToString:requestResult.responseCache];
    } success:^(LLRequestResult * _Nonnull requestResult) {
        // 2.再请求网络数据
        self.networkData.text = [LLTools jsonToString:requestResult.responseObject];
    } failure:^(LLRequestResult * _Nonnull requestResult) {
        
    }];
}

- (IBAction)requestSix:(id)sender {
    self.networkData.text = @"";
    self.cacheData.text = @"";
    [LLNetAPIworking ll_POST:_urlArray[5] parameters:_paramArray[5] cacheTime:60*5 responseCache:^(LLRequestResult * _Nonnull requestResult) {
        // 1.先加载缓存数据
        self.cacheData.text = [LLTools jsonToString:requestResult.responseCache];
    } success:^(LLRequestResult * _Nonnull requestResult) {
        // 2.再请求网络数据
        self.networkData.text = [LLTools jsonToString:requestResult.responseObject];
    } failure:^(LLRequestResult * _Nonnull requestResult) {
        
    }];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    _urlArray= @[@"http://sp.kaola.com/api/application",
                 @"http://community.kaola.com/api/index/v2",
                 @"https://m.kaola.com/user/ajax/getUserProfile.html",
                 @"https://m.kaola.com/appComment/goodArticle/subjectInfo.html",
                 @"https://m.kaola.com/activity/detail/getWapActivityShowZone/30490/15008993043590.shtml",
                 @"http://m.banggo.com/search/get-search-goods/Metersbonwe_a_a_a_a_a_a_a_a_a_a_a.shtml",
                 @"http://api.budejie.com/api/api_open.php?a=user_login_report&appname=bs0315&asid=0E654373-EBD6-45A7-93F6-DA21F4243AC4&c=user&client=iphone&device=iPhone%206&from=ios&jbk=1&market=&openudid=5372453f2ec2bc8dbf03e368e6ab211ebf8f4b00&t=1503640612&udid="
                 ];
    
    _paramArray = @[
                    @{@"version":@"3.8.6",@"update":@"1503997157982"},
                    @{@"":@""},
                    @{@"t":@"1503997752174",@"deviceUdID":@"760ca97be280a04d8823ade41c4a8f3120164b86"},
                    @{@"t":@"1503997752474",@"subject":@"7"},
                    @{@"deviceUdID":@"760ca97be280a04d8823ade41c4a8f3120164b86",@"t":@"1503999536440"},
                    @{
                        @"ts":@"1504058702",
                        @"discountRate":@"a",
                        @"suffix":@".shtml",
                        @"avn":@"1",
                        @"islogin":@"wap",
                        @"frombgapp":@"1",
                        @"network":@"WIFI",
                        @"avn":@"1",
                        @"updateVersion":@"0622",
                        },
                    @{@"ver":@"4.5.7"}
                    ];
    
    
    
    LLNetAPIworking.ll_NetworkingDebugEnabled = YES;

    self.networkData.userInteractionEnabled = NO;
    self.cacheData.userInteractionEnabled = NO;
}



/*
 @"http://112.25.243.73/ipservice",
 @{@"did":@"CF3CF6F6-1BD1-46A0-B5B9-8C0A5CCA8C54",
 @"func": @"dns_resolver",
 @"network": @"wifi",
 @"version": @"9.2.2.3333",
 @"domains": @"api.mogujie.com"
 },
 http://www.jianshu.com/p/3747070e07db
 
 
 
 @{@"did":@"CF3CF6F6-1BD1-46A0-B5B9-8C0A5CCA8C54",
 @"func": @"dns_resolver",
 @"network": @"wifi",
 @"version": @"9.2.2.3333",
 @"domains": @"api.mogujie.com"
 },
 */



@end
