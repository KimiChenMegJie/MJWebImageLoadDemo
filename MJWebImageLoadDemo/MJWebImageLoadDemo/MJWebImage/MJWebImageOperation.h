//
//  MJWebImageOperation.h
//  MJWebImageLoadDemo
//
//  Created by kimi on 7/31/16.
//  Copyright © 2016 kimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJWebImageOperation : NSOperation

@property (nonatomic,strong)UIImage *image;

/**
 *  通过一个urlString创建一个操作
 *
 *  @param urlString <#urlString description#>
 *
 *  @return self
 */
+ (instancetype)operationWithUrlString:(NSString *)urlString;

@end
