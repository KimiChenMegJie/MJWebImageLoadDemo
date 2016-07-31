//
//  MJWebImageManager.h
//  MJWebImageLoadDemo
//
//  Created by kimi on 7/31/16.
//  Copyright © 2016 kimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJWebImageManager : NSObject
/**
 *  单例，设置全局访问点
 */
+ (instancetype)sharedWebImageManager;
/**
 *  提供外部调用下载的方法，异步的操作是不能直接给当前函数提供返回值的，因此需要block进行回调
 *
 *  @param urlString   图片URL地址
 *  @param compeletion 使用block将异步下载的图片进行回调
 */
- (void)downloadImageWithUrlString:(NSString *)urlString compeletion:(void (^)(UIImage *))compeletion;

@end
