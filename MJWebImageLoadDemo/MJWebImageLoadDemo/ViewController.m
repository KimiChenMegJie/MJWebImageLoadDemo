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
    
//    NSLog(@"%@",infoData.icon);
    
    //获取URL地址
    NSURL *imageUrl = [NSURL URLWithString:infoData.icon];
    //获取二进制数据
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    
    //二进制数据转换图片
    UIImage *image = [UIImage imageWithData:imageData];
    
    cell.iconView.image = image;
    
    
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

@end
