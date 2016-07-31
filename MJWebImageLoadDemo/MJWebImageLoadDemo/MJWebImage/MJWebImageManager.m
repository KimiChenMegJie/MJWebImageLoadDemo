//
//  MJWebImageManager.m
//  MJWebImageLoadDemo
//
//  Created by kimi on 7/31/16.
//  Copyright © 2016 kimi. All rights reserved.
//

#import "MJWebImageManager.h"
#import "MJWebImageOperation.h"
#import "NSString+path.h"

@interface MJWebImageManager ()

/**
 *  图片缓存字典
 */
@property (nonatomic,strong)NSMutableDictionary *imageCache;
/**
 *  操作缓存字典
 */
@property (nonatomic,strong)NSMutableDictionary *operationCache;

/**
 *  操作队列
 */
@property (nonatomic,strong)NSOperationQueue *queue;


@end

@implementation MJWebImageManager

+ (instancetype)sharedWebImageManager
{
    static MJWebImageManager *shared;
    
    if (!shared) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[self alloc]init];
        });
    }
    return shared;
}

//注意别忘记初始化对象

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化
        self.imageCache = [NSMutableDictionary dictionary];
        self.operationCache = [NSMutableDictionary dictionary];
        self.queue = [[NSOperationQueue alloc]init];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)downloadImageWithUrlString:(NSString *)urlString compeletion:(void (^)(UIImage *))compeletion
{
    //断言，如果传入空image报错,参数1:条件，参数2：描述
    NSCAssert(compeletion != nil, @"必须传入回调的block");
    
    //1.先判断字典缓存中是否有图片，有的话就不需要下，直接从字典获取
    UIImage *cacheImage = self.imageCache[urlString];
    if (cacheImage) {
        NSLog(@"从内存中取出图片");
        //直接使用block将图片调回
        compeletion(cacheImage);
        return;
    }
    
    //从沙盒中取出图片
    NSString *cachePath = [urlString appendCachePath];
    cacheImage = [UIImage imageWithContentsOfFile:cachePath];
    if (cacheImage) {
        NSLog(@"从沙盒中取出图片");
        //别忘记缓存到内存中一份
        [self.imageCache setObject:cacheImage forKey:urlString];
        //回调图片
        compeletion(cacheImage);
        return;
    }
    
    NSLog(@"%@",urlString);
    NSLog(@"%@",self.operationCache[urlString]);
    
    //操作之前首先判断是否已进行该下载操作
    if (self.operationCache[urlString] != nil) {
        NSLog(@"已经在下载,请稍等...");
        return;
    }
    
    //新创建一个操作去下载图片
    //初始化一个操作到后台下载图片,创建一个MJWebImageOperation操作
    MJWebImageOperation *op = [MJWebImageOperation operationWithUrlString:urlString];
    
    __weak MJWebImageOperation *weakSelf = op;
    //添加监听,添加监听下载完成，此方法不是很清楚
    /*
     A block object called when animations for this transaction group are completed.
     block会在动画处理组完成后调用
     The block object takes no parameters and returns no value.
     这个block对象没有参数和返回值
     */
    [op setCompletionBlock:^{
        //取得图片
        UIImage *image = weakSelf.image;
        //回到主线程调用block,将image传出去
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //保存到内存中一份
            [self.imageCache setObject:image forKey:urlString];
            //保存后，将当前操作从缓存中移除，防止连续创建相同下载操作,同时回调该image
            [self.operationCache removeObjectForKey:urlString];
            compeletion(image);
        }];
    }];
    
    //将操作添加到操作缓存中,方便清除
    [self.operationCache setObject:op forKey:urlString];
    
    //将操作加入队列
    [self.queue addOperation:op];
}

/**
 *  接受内存警告后，完成清除，本质是接受到通知消息后触发相应方法
 */
-(void)memoryWarning{
    NSLog(@"收到内存警告");
    
    //1.清除图片
    [self.imageCache removeAllObjects];
    //2.清除操作
    [self.operationCache removeAllObjects];
    //3.取消队列中所有的操作
    [self.queue cancelAllOperations];
}

/**
 *  在dealloc方法中调用移除通知
 */

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
