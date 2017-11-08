//
//  CancelRequestAndTimeOutTestVC.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/29.
//  Copyright © 2017年 李龙. All rights reserved.
//

/*
 *********************************************************************************
 *
 * 1. 取消网络请求,是在网络环境较差的情况下，请求后台数据的任务正在执行中，然后取消。
 *    【cancelRequestByURL：withParam：】下， 在GET请求中，我们可以拿到url和param组成的链接来精确取消，但是在POS请求下，我们只能拿到url作对比，取消url前缀的部分
 *     推荐直接用AFN的（LL）NSURLSessionTask来取消某个请求。
 * 2. LLNetworkingHelper超时时间为60s,这里测试为1s
 * 3. 你需要先把自己当前的网络设置为较差网络。 具体参考这篇文章http://www.jianshu.com/p/6949c2ecb401或者http://www.jianshu.com/p/b2582d790b52. 我测试的状态是"Very Bad Network"
 * 4. 开始测试。
 *
 *
 *********************************************************************************
 */


#import "CancelRequestAndTimeOutTestVC.h"
#import "LLNetAPIworking.h"
#import "LLRequestResult.h"
#import "LLNetworkingHelperUtil.h"

@interface CancelRequestAndTimeOutTestVC ()
@property (nonatomic,strong) NSArray *urlArray;
@property (nonatomic,strong) NSArray *paramArray;
@end

@implementation CancelRequestAndTimeOutTestVC

//测试超时时间
- (IBAction)timeOutTest:(id)sender {
    [LLNetAPIworking setRequestTimeout:1];
    
    for (NSInteger i = 0; i <_urlArray.count ; i++) {
        [self sendPOSTRequestWithURL:_urlArray[i] param:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]] index:i];
    }
}


//发送全部POST请求
- (IBAction)sendPOSTReuqests:(id)sender {
    [LLNetAPIworking setRequestTimeout:60];

    for (NSInteger i = 0; i <_urlArray.count ; i++) {
        [self sendPOSTRequestWithURL:_urlArray[i] param:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]] index:i];
    }
}

//发送全部GET请求
- (IBAction)sendGETReuqests:(id)sender {
    [LLNetAPIworking setRequestTimeout:60];
    
    for (NSInteger i = 0; i <_urlArray.count ; i++) {
        [self sendGETRequestWithURL:_urlArray[i] param:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]] index:i];
    }
}


//取消全部请求
- (IBAction)cancelReuqests:(id)sender {
    [LLNetAPIworking cancelAllRequest];
}

//取消单个请求
- (IBAction)cancelReuqestsOne:(id)sender {
    NSInteger i = 0;
    [LLNetAPIworking cancelRequestByURL:_urlArray[i] withParam:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]]];
}


-(IBAction)cancelReuqestsTwo:(id)sender {
    NSInteger i = 1;
    [LLNetAPIworking cancelRequestByURL:_urlArray[i] withParam:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]]];
}


-(IBAction)cancelReuqestsThree:(id)sender {
    NSInteger i = 2;
    [LLNetAPIworking cancelRequestByURL:_urlArray[i] withParam:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]]];
}


-(IBAction)cancelReuqestsFour:(id)sender {
    NSInteger i = 3;
    [LLNetAPIworking cancelRequestByURL:_urlArray[i] withParam:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]]];
}


-(IBAction)cancelReuqestsFive:(id)sender {
    NSInteger i = 4;
    [LLNetAPIworking cancelRequestByURL:_urlArray[i] withParam:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]]];
}


-(IBAction)cancelReuqestsSix:(id)sender {
    NSInteger i = 5;
    [LLNetAPIworking cancelRequestByURL:_urlArray[i] withParam:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]]];
}



- (IBAction)cancelOneRequest:(id)sender {
    
    NSInteger i = 4;
    LLNSURLSessionDataTask *task1 =  [self sendGETRequestWithURL:_urlArray[i] param:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]] index:i];
    
    i = 3;
    LLNSURLSessionDataTask *task2 =  [self sendPOSTRequestWithURL:_urlArray[i] param:[LLNetworkingHelperUtil getRealRequestParameter:_paramArray[i]] index:i];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [task1 cancel];
        [task2 cancel];
    });
}



//---------------------------------------------------------------------------------------------------
#pragma mark ================================== xx ==================================
//---------------------------------------------------------------------------------------------------
- (LLNSURLSessionDataTask *)sendPOSTRequestWithURL:(NSString *)urlStr param:(NSDictionary *)param index:(NSInteger)index{
    NSLog(@"%s--[第%zd个请求]-开始请求......",__FUNCTION__,index+1);
    LLNSURLSessionDataTask *task = [LLNetAPIworking ll_POST:urlStr parameters:param success:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"%s--[第%zd个请求]-请求已经成功",__FUNCTION__,index+1);

    } failure:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"%s--[第%zd个请求]-请求失败-%@",__FUNCTION__,index+1,requestResult.error.userInfo);

    }];
    
    return task;
}


- (LLNSURLSessionDataTask *)sendGETRequestWithURL:(NSString *)urlStr param:(NSDictionary *)param index:(NSInteger)index{
    NSLog(@"%s--[第%zd个请求]-开始请求......",__FUNCTION__,index+1);
    LLNSURLSessionDataTask *task = [LLNetAPIworking ll_GET:urlStr parameters:param success:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"%s--[第%zd个请求]-请求已经成功",__FUNCTION__,index+1);

    } failure:^(LLRequestResult * _Nonnull requestResult) {
        NSLog(@"%s--[第%zd个请求]-请求失败-%@",__FUNCTION__,index+1,requestResult.error.userInfo);
    }];
    return task;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    tip:
    因为cancelRequestByURL:withParam:的匹配链接是标准格式,所以不支持该格式: 前半段url已经带"?"和部分请求参数, 后半段param中补全后半段请求参数
    比如 urlStr=http://www.lilong.cc? parsm=@{@"xxx":@"pw"} 在cancelRequestByURL:withParam:方法中会变成 http://www.lilong.cc?name=zhangsan?pw=xxx(多了个问号)
    注意https请求
    */
    _urlArray= @[@"http://sp.kaola.com/api/application",
                 @"http://community.kaola.com/api/index/v2",
                 @"https://m.kaola.com/user/ajax/getUserProfile.html",
                 @"https://m.kaola.com/appComment/goodArticle/subjectInfo.html",
                 @"https://m.kaola.com/activity/detail/getWapActivityShowZone/30490/15008993043590.shtml",
                 @"http://m.banggo.com/search/get-search-goods/Metersbonwe_a_a_a_a_a_a_a_a_a_a_a.shtml"
                 ];

    
    /*
     注意:
     http://112.25.243.73/ipservice +  @{@"did":@"CF3CF6F6-1BD1-46A0-B5B9-8C0A5CCA8C54",
     @"func": @"dns_resolver",
     @"network": @"wifi",
     @"version": @"9.2.2.3333",
     @"domains": @"api.mogujie.com"
     }
     这个请求是从美丽说请求链接,该链接在GET下请求正常,在POST请求下会出现 [Error Domain=NSURLErrorDomain Code=-1005 “The network connection was lost.”] 问题, 可能是后端问题, 需要根据自家的服务器解决.
     */
    
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
                      }
                    ];

    
    LLNetAPIworking.ll_NetworkingDebugEnabled = YES;
    

}


/*
 
 _urlArray= @[@"http://api.budejie.com/api/api_open.php?a=user_login_report&appname=bs0315&asid=0E654373-EBD6-45A7-93F6-DA21F4243AC4&c=user&client=iphone&device=iPhone%206&from=ios&jbk=1&market=&openudid=5372453f2ec2bc8dbf03e368e6ab211ebf8f4b00&t=1503640612&udid=",
 @"http://sp.kaola.com/api/application?idfa=547DE90B5084A29C45CD4A6057C51F21AF5AC9E92C841399C268EA323FDCAC0553A36933E9910269D53B0B11D1F65605&initial=1&messageToken=www.kaola.com-5daaa74eeef4e5a28adc3f85e4cfe6dc4a015d65&userAgent=Mozilla%2F5.0%20%28iPhone%3B%20CPU%20iPhone%20OS%209_3_1%20like%20Mac%20OS%20X%29%20AppleWebKit%2F601.1.46%20%28KHTML%2C%20like%20Gecko%29%20Mobile%2F13E238",
 @"http://s.mobile.jumei.com/api/v1/ad/common?ab=144%3Aa%7C164%3Av3%7C166%3Ab%7C180%3Ahide%7C182%3Ab%7C183%3Ab%7C203%3Ashow%7C281%3Av7%7C667%3Afake%7C701%3Ashow%7C802%3Ashow%7C901%3Ashow%7C1001%3AB%7C1655%3Av1%7C73159%3Anew%7C73162%3Aa%7C100101%3A2b&app_id=com.jumei.iphone&appfirstinstall=0&client_v=4.550&platform=iphone&position=home&site=bj&source=AppstoreI1&type=set_nav",
 @"http://m.kaola.com/apple-app-site-association?had=936760b0d7e1c0d51ee206cfc5ff309292594edd&hudid=815a8c4995d80fe7b9cda191d2f608016e0a4240&1503995085",
 @"http://s.mobile.jumei.com/api/v1/activity/activitylist?ab=144%3Aa%7C164%3Av3%7C166%3Ab%7C180%3Ahide%7C182%3Ab%7C183%3Ab%7C203%3Ashow%7C281%3Av7%7C667%3Afake%7C701%3Ashow%7C802%3Ashow%7C901%3Ashow%7C1001%3AB%7C1655%3Av1%7C73159%3Anew%7C73162%3Aa%7C73163%3Ad%7C73164%3Af%7C100101%3A2b&app_id=com.jumei.iphone&appfirstinstal=0&appfirstinstall=0&card_id=2382&client_v=4.550&item_per_page=20&join_from=categorybrand_mall&page=1&page_key=&platform=iphone&sellparams=card%3A2382&site=bj&source=AppstoreI1",
 @"http://s.mobile.jumei.com/api/v1/product/detailStatic?ab=144%3Aa%7C164%3Av3%7C166%3Ab%7C180%3Ahide%7C182%3Ab%7C183%3Ab%7C203%3Ashow%7C281%3Av7%7C667%3Afake%7C701%3Ashow%7C802%3Ashow%7C901%3Ashow%7C1001%3AB%7C1655%3Av1%7C73159%3Anew%7C73162%3Aa%7C73163%3Ad%7C73164%3Af%7C100101%3A2b&app_id=com.jumei.iphone&appfirstinstall=0&client_v=4.550&item_id=ht170829p1897393t2&platform=iphone&selllabel=%E6%B4%81%E9%9D%A2%2B%E7%94%B7&selltype=mSearch&site=bj&source=AppstoreI1&type=global_deal"
 ,

 ];
 
 
 _paramArray = @[@{@"ver":@"4.5.7"},
 @{@"version":@"3.8.6"},
 @{@"user_tag_id":@"131"},
 @{@"htype":@"appactive"},
 @{@"user_tag_id":@"131"},
 @{@"user_tag_id":@"131"}
 ];
 
 
                  @"http://s.budejie.com/danmu/list/25565294/baisishequ-iphone-4.0.json",
 @{
 @"appname":@"baisishequ",
 @"asid": @"0E654373-EBD6-45A7-93F6-DA21F4243AC4",
 @"client": @"iphone",
 @"device": @"ios%20device",
 @"from": @"ios",
 @"jbk": @"1",
 @"mac": @"",
 @"openudid": @"49b978a22d0d3d90f0cdfdd8a78f53bcff8a40a1",
 @"udid": @"",
 @"ver":@"4.0"
 }
 ,
 */

@end
