//
//  MJAppInfoCell.h
//  MJWebImageLoadDemo
//
//  Created by kimi on 16/7/30.
//  Copyright © 2016年 kimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJAppInfoCell : UITableViewCell
/**
 *  图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  下载量
 */
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@end
