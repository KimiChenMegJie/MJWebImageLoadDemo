//
//  MJWebImageOperation.m
//  MJWebImageLoadDemo
//
//  Created by kimi on 7/31/16.
//  Copyright © 2016 kimi. All rights reserved.
//

#import "MJWebImageOperation.h"
#import "NSString+path.h"

@interface MJWebImageOperation ()

@property (nonatomic,copy)NSString *urlString;

@end

@implementation MJWebImageOperation

+ (instancetype)operationWithUrlString:(NSString *)urlString
{
    //初始化操作
    MJWebImageOperation *op = [MJWebImageOperation new];
    //记录urlString
    op.urlString = urlString;
    
    return op;
}

/*
 Performs the receiver’s non-concurrent task.
 The default implementation of this method does nothing. You should override this method to perform the desired task. In your implementation, do not invoke super. This method will automatically execute within an autorelease pool provided by NSOperation, so you do not need to create your own autorelease pool block in your implementation.
 If you are implementing a concurrent operation, you are not required to override this method but may do so if you plan to call it from your custom start method.
 */


//执行非并发的任务
- (void)main
{
    //1.通过地址字符初始化NSURL
    NSURL *url = [NSURL URLWithString:self.urlString];
    //2.通过URL获取二进制数据
    NSData *data = [NSData dataWithContentsOfURL:url];
    //3.将二进制数据转换成图片
    self.image = [UIImage imageWithData:data];
    
    //将二进制数据写入沙盒
    [data writeToFile:[self.urlString appendCachePath] atomically:YES];
 
}

@end
