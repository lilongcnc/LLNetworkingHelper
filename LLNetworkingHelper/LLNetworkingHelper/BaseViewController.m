//
//  BaseViewController.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/29.
//  Copyright © 2017年 李龙. All rights reserved.
//

/*
 *********************************************************************************
 *
 *  实际开发中,关于在何时取消网络请求,有自己的一套业务逻辑. 一般在基类中,离开当前页面时,则取消当前页面的所有的请求
 *
 *********************************************************************************
 */

#import "BaseViewController.h"
#import "LLNetAPIworking.h"


#define LLRGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif



@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:LLRGBColor(0,0,0),NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%s  %@",__FUNCTION__,@"父类中取消当前页面全局请求");
    [LLNetAPIworking cancelAllRequest];
}




@end
