//
//  TYRequestConfig.h
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 16/8/25.
//  Copyright © 2016年 天翼阅读. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYNetworkConfig : NSObject

+(instancetype)sharedInstance;

@property(nonatomic,copy) NSString *baseUrl;
@property(nonatomic,copy) NSString *networkRequestFailMessage;
@property(nonatomic,copy) NSString *noNetworkMessage;


@end
