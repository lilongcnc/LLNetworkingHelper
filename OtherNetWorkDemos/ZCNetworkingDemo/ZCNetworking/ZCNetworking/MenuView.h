//
//  MenuView.h
//  ZCNetworking
//
//  Created by 李龙 on 16/6/30.
//  Copyright © 2016年 charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

@property (nonatomic,copy) void(^ menuViewOnClick)(NSString *btnTitle);

@end
