//
//  MJAppInfo.h
//  MJWebImageLoadDemo
//
//  Created by kimi on 16/7/30.
//  Copyright © 2016年 kimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJAppInfo : NSObject
/**
 *  下载量
 */
@property (nonatomic,copy)NSString *download;
/**
 *  图片名称
 */
@property (nonatomic,copy)NSString *icon;
/**
 *  图标名称
 */
@property (nonatomic,copy)NSString *name;


+ (instancetype)appInfoWithDict:(NSDictionary *)dict;

@end
