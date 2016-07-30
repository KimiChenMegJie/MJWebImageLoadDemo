//
//  ViewController.m
//  MJWebImageLoadDemo
//
//  Created by kimi on 16/7/30.
//  Copyright © 2016年 kimi. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 初始化&加载数据

/**
 *  加载网络数据
 */
-(void)loadData
{
    //获取url地址
    NSString *urlString = @"https://raw.githubusercontent.com/KimiChenMegJie/MJWebImageLoadDemo/master/MJWebImageLoadDemo/MJWebImageLoadDemo/apps.json";
    //初始化一个网络请求管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /**
     *  参数：
     1.请求的地址
     2.请求的参数
     3.加载的进度
     4.成功的回调
     5.失败的回调
     */
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络请求成功");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败");
    }];
    
}


@end
