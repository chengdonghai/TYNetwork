//
//  TYRequestConfig.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 16/8/25.
//  Copyright © 2016年 天翼阅读. All rights reserved.
//

#import "TYNetworkConfig.h"

@implementation TYNetworkConfig

+(instancetype)sharedInstance
{
    static id instance;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        instance = [self new];
    });
    return instance;
}


@end
