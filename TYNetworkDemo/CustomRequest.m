//
//  CustomRequest.m
//  TYNetworkDemo
//
//  Created by chengdonghai on 2018/7/27.
//  Copyright © 2018年 Dahai. All rights reserved.
//

#import "CustomRequest.h"
@interface CustomRequest()
{
    NSString *_param;
}
@end
@implementation CustomRequest

- (instancetype)initWithParam:(NSString *)param
{
    self = [super init];
    if (self) {
        _param = param;
    }
    return self;
}
-(id)requestParameters
{
    return @{@"param":_param};
}
-(NSDictionary *)requestHeaders
{
    return @{};
}

-(NSString *)requestUrl {
    return @"2/comments/show.json";
}
@end
