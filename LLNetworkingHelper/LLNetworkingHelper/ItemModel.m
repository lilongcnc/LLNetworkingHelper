//
//  ItemModel.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/28.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

+ (instancetype)itemWithName:(NSString *)name object:(id)object {
    
    ItemModel *item  = [[[self class] alloc] init];
    item.name   = name;
    item.object = object;
    return item;
}

@end
