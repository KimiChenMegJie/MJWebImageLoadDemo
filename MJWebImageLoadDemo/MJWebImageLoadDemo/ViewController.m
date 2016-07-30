//
//  ViewController.m
//  MJWebImageLoadDemo
//
//  Created by kimi on 16/7/30.
//  Copyright © 2016年 kimi. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MJAppInfo.h"
#import "MJAppInfoCell.h"

@interface ViewController ()
/**
 *  装有模型的数组
 */
@property (nonatomic,strong)NSMutableArray *appInfosData;
/**
 *  全局操作队列中
 */
@property (nonatomic,strong)NSOperationQueue *operations;

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
     1.请求的地址2.请求的参数3.加载的进度4.成功的回调5.失败的回调
     */
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"网络请求成功");
        //1.获取数据到临时数组
        NSArray *tempArray = responseObject;
        //2.字典转模型
        for (NSDictionary *dict in tempArray) {
            MJAppInfo *info = [MJAppInfo appInfoWithDict:dict];
            [self.appInfosData addObject:info];
        }
        NSLog(@"%@",self.appInfosData);
        //重新刷新tabelView数据
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败");
    }];
    
}

#pragma mark - 数据源方法
/*
 问题:
 
 1.不能同步下载图片,不然会很卡
 - 在异步下载图片
 2.图片下载完成之后,图片显示不出来
 - 原因: 返回cell的时候,图片可能还没有下载成功,而一返回cell的话,cell就被显示到界面上,这个时候还没有图片,图片下载成功之后给cell的imageView设置了图片,但是imageView没有大小.而当我一点击的时候,就会调用 layoutsubviews 的方法
 3.如果在返回cell的时候,图片不清空,那么这个cell被复用的时候,会先显示之前的图标 ,然后才会显示当前cell对应的图标
 - 在返回cell的时候清空图片或者设置占位图片
 4.如果后面的图片下载得慢,界面来回拖的时候,就会造成图片错乱,cell复用
 - 图片下载完成之后,将图片保存到模型中(图片与模型相对应,而不是与cell相对应,因为cell会复用)
 - 保存到模型中之后,就去刷新对应模型那一行的cell
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appInfosData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJAppInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //获取模型数据
    MJAppInfo *infoData = self.appInfosData[indexPath.row];
    
    cell.nameLabel.text = infoData.name;
    cell.downloadLabel.text = infoData.download;
    //设置默认显示图片为空
    cell.iconView.image = nil;

    //初始化一个操作到后台下载图片
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        //制造网络不好数据加载慢的情况
        if (indexPath.row >= 9) {
            [NSThread sleepForTimeInterval:3];
        }
        //获取URL地址
        NSURL *imageUrl = [NSURL URLWithString:infoData.icon];
        //获取二进制数据
        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
        //二进制数据转换图片
        UIImage *image = [UIImage imageWithData:imageData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //在主线程中更新UI
            cell.iconView.image = image;
        }];

    }];
    //记得将操作加入到队列
    [self.operations addOperation:op];
    
    return cell;
}

#pragma mark - 懒加载
-(NSMutableArray *)appInfosData
{
    if (!_appInfosData) {
        _appInfosData = [NSMutableArray array];
    }
    return _appInfosData;
}

-(NSOperationQueue *)operations
{
    if (!_operations) {
        _operations = [[NSOperationQueue alloc]init];
    }
    return _operations;
}

@end
