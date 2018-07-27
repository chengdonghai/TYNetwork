//
//  TYDownloadRequestHandler.h
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 16/8/28.
//  Copyright © 2016年 天翼阅读. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TYDownloadRequest;
@class AFHTTPSessionManager;
@interface TYDownloadRequestHandler : NSObject
@property(nonatomic,strong) AFHTTPSessionManager *sessionManager;

+ (instancetype)sharedInstance;

-(void)addDownloadRequest:(TYDownloadRequest *)downloadReq;
-(void)removeDownloadRequest:(TYDownloadRequest *)downloadReq;

@end
