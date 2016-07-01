//
//  MenuView.m
//  ZCNetworking
//
//  Created by 李龙 on 16/6/30.
//  Copyright © 2016年 charles. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (instancetype)init {
    if (self = [super init]) {
        //初始化控件
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //初始化控件
        [self initSubViews];
    }
    return self;
}

//不要xxx.frame = GRectmake()这样设置frame
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //初始化控件
        [self initSubViews];
    }
    return self;
}




- (void)initSubViews{
    
    NSLog(@"%s  %@",__FUNCTION__,NSStringFromCGRect(self.frame));
    
    NSArray *titleArray = @[@"登录",@"签到",@"单图上传",@"多图上传",@"单个图片下载",@"batch",@"chain"];
    
    int flag = 2;

    
    CGFloat margin = 10;
    CGFloat btnW = ([UIScreen mainScreen].bounds.size.width - 30)*0.5;
    CGFloat btnH = 40;
    CGFloat btnY = 0;
    CGFloat btnX = 0;
    
    for (int i = 0; i < titleArray.count; i++) {
        int rowNum = i / flag;
        int cluNum = i % flag;
        
        btnY = 50+(btnH+margin)*rowNum;
        btnX = margin + (btnW + margin)*cluNum;
        
        //上传测试
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [button  setTitle:titleArray[i] forState:0];
        [button setTitleColor:[UIColor blackColor] forState:0];
        button.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
        [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
}


- (void)buttonOnClick:(UIButton *)btn{
    NSLog(@"xxx");
    if (_menuViewOnClick) {
        _menuViewOnClick(btn.currentTitle);
    }
}





@end
