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
#import "NSString+path.h"
#import "MJWebImageManager.h"

@interface ViewController ()
/**
 *  装有模型的数组
 */
@property (nonatomic,strong)NSMutableArray *appInfosData;
/**
 *  全局操作队列中
 */
@property (nonatomic,strong)NSOperationQueue *operations;
/**
 *  图片缓存字典
 */
@property (nonatomic,strong)NSMutableDictionary *imageCache;
/**
 *  操作缓存字典
 */
@property (nonatomic,strong)NSMutableDictionary *operationCache;


@end

@implementation ViewController
{
    //测试变量
    __block NSInteger count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadData];
    count = 1;
    
    //测试单例
    //    MJWebImageManager *manage1 = [MJWebImageManager sharedWebImageManager];
    //    NSLog(@"%p",manage1);
    //    MJWebImageManager *manage2 = [MJWebImageManager sharedWebImageManager];
    //    NSLog(@"%p",manage2);
    //    MJWebImageManager *manage3 = [MJWebImageManager sharedWebImageManager];
    //    NSLog(@"%p",manage3);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //1.清除内存中的所有image
    [self.imageCache removeAllObjects];
    //2.清除队列中的所有操作
    [self.operations cancelAllOperations];
    //3.移除所有的操作
    [self.operationCache removeAllObjects];
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
 5.把图片缓存到字典
 - 为什么: 缓存到字典里面在清除缓存的时候更加方式
 - 以后做缓存的话,请尽量考虑使用字典 NSCache(基于 LRU 算法)
 6. 如果图片下载需要10秒钟,我不停止的拖动cell,会造成什么样的情况??
 - 会一直初始化操作,一直给同一个图片下载添加多个操作,怎么解决?? 缓存操作
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
    
    [[MJWebImageManager sharedWebImageManager] downloadImageWithUrlString:infoData.icon compeletion:^(UIImage *image){
        cell.iconView.image = image;
    }];
    //    [[MJWebImageManager sharedWebImageManager] downloadImageWithUrlString:infoData.icon compeletion:nil];
    
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

- (NSMutableDictionary *)imageCache
{
    if (!_imageCache) {
        _imageCache = [NSMutableDictionary dictionary];
    }
    return _imageCache;
}

- (NSMutableDictionary *)operationCache
{
    if (!_operationCache) {
        _operationCache = [NSMutableDictionary dictionary];
    }
    
    return _operationCache;
}


@end
