//
//  MJAppInfo.m
//  MJWebImageLoadDemo
//
//  Created by kimi on 16/7/30.
//  Copyright © 2016年 kimi. All rights reserved.
//

#import "MJAppInfo.h"

@implementation MJAppInfo

+ (instancetype)appInfoWithDict:(NSDictionary *)dict
{
    MJAppInfo *info = [[self alloc]init];
    
    [info setValuesForKeysWithDictionary:dict];
    
    return info;
}

//重写此方法，防止多个数据给少量模型参数赋值
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
