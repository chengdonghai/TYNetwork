//
//  TYRequest.h
//  TYNetwok
//
//  Created by chengdonghai on 16/5/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TYRequestDefine.h"
#import <AFNetworking.h>
#import "TYError.h"
#import "TYRequestParameterConverterDelegate.h"
#import "TYResponseDataConverterDelegate.h"

//Request task finished block


@class TYRequest;

typedef void(^TYConstructingBlock)(id<AFMultipartFormData> formData);

typedef void(^TYRequestBlock)(TYRequest *req);

@protocol TYRequestDelegate <NSObject>

@required

//request url
-(NSString *)requestUrl;

//request headers
-(NSDictionary *)requestHeaders;

//request parameters
-(id)requestParameters;

//request method @TYRequestMethod
-(TYRequestMethod)requestMethod;

-(TYRequestType)requestType;

@optional

-(TYConstructingBlock)requestConstructingBlock;

-(AFHTTPRequestSerializer *)requestSerializer;

-(id)requestParameterBeforeConverted:(id)requestParameter;

-(id)requestParameterAfterConverted:(id)requestParameter;

@end

@protocol TYResponseDelegate <NSObject>

@required
-(TYError *)checkSuccessedResponseObj:(id)responseObj andResponseHeaders:(NSDictionary *)headers;

-(TYError *)responseDidFailedWithError:(NSError *)error;

@optional
-(id)responseDataBeforeConverted:(id)responseObj;

-(id)responseDataAfterConverted:(id)responseObj;

-(AFHTTPResponseSerializer *)responseSerializer;

@end



@interface TYRequest : NSObject <TYRequestDelegate,TYResponseDelegate>

@property (nonatomic, copy) TYRequestBlock sucess;
@property (nonatomic, copy) TYRequestBlock failure;
@property (nonatomic, copy) TYRequestBlock inRequest;
@property (nonatomic, strong) id<TYRequestParameterConverterDelegate> requestConverter;
@property (nonatomic, strong) id<TYResponseDataConverterDelegate> responseConverter;

/**
 *  @brief request task object
 */
@property (nonatomic, strong) NSURLSessionDataTask *task;
/**
 *  @brief response object
 */
@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) id responseSerializeredObject;
/**
 *  @brief response headers
 */
@property (nonatomic, strong) NSDictionary* responseHeaders;

/**
 The dispatch group for `completionBlock`. If `NULL` (default), a private dispatch group is used.
 */
@property (nonatomic, strong) dispatch_group_t completionGroup;

/**
 The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
 */
@property (nonatomic, strong) dispatch_queue_t completionQueue;

/**
 *  @brief request error.
 */
@property (nonatomic, strong) TYError *error;

/**
 *  @brief request progress.
 */
@property (nonatomic, strong) NSProgress *progress;

/**
 *  @brief start request
 */
-(void) start;
-(void) startWithSuccess:(TYRequestBlock)success;
-(void) startWithSuccess:(TYRequestBlock)success andFailure:(TYRequestBlock)failure;
-(void) startWithSuccess:(TYRequestBlock)success inRequest:(TYRequestBlock)inRequest;
-(void) startWithSuccess:(TYRequestBlock)success inRequest:(TYRequestBlock)inRequest andFailure:(TYRequestBlock)failure;

/**
 *  @brief cancel request
 */
-(void) cancel;

/**
 *  @brief clear request
 */
-(void) clear;

/**
 *  @brief clear block
 */
-(void) clearBlock;

@end
