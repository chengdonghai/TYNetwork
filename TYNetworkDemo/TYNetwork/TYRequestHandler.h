//
//  TYRequestHandler.h
//  TYNetwok
//
//  Created by chengdonghai on 16/5/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "TYRequest.h"

extern NSString *const TYNetworkRequestParametersKey;
extern NSString *const TYNetworkRequestHeadersKey;


@interface TYRequestHandler : NSObject

/**
 *  @brief singleton
 *
 *  @return instance
 */
+ (instancetype)sharedInstance;

/**
 *  @brief add HTTP request
 *
 *  @param req request object
 */
-(void)addRequest:(TYRequest *)req;

/**
 *  @brief remove request
 *
 *  @param req request object
 */
-(void)removeRequest:(TYRequest *)req;

@end
