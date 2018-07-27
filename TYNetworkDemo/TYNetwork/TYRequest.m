//
//  TYRequest.m
//  TYNetwok
//
//  Created by chengdonghai on 16/5/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "TYRequest.h"
#import "TYRequestHandler.h"
#import <JavaScriptCore/JavaScriptCore.h>

@implementation TYRequest


-(void) start {
    [self startWithSuccess:nil];
}

-(void)startWithSuccess:(TYRequestBlock)success
{
    [self startWithSuccess:success andFailure:nil];
}

-(void)startWithSuccess:(TYRequestBlock)success andFailure:(TYRequestBlock)failure
{
    [self startWithSuccess:success inRequest:nil andFailure:failure];
}

-(void)startWithSuccess:(TYRequestBlock)success inRequest:(TYRequestBlock)inRequest
{
    [self startWithSuccess:success inRequest:inRequest andFailure:nil];
}

-(void)startWithSuccess:(TYRequestBlock)success inRequest:(TYRequestBlock)inRequest andFailure:(TYRequestBlock)failure
{
    
    if (success) {
        self.sucess = success;
    }
    if (inRequest) {
        self.inRequest = inRequest;
    }
    if (failure) {
        self.failure = failure;
    }
    [[TYRequestHandler sharedInstance] addRequest:self];
    
    
}

-(void) cancel {
    [[TYRequestHandler sharedInstance] removeRequest:self];
    [self clearBlock];
}

-(void)clear {
    [self cancel];
}

-(void)clearBlock {
    self.sucess = nil;
    self.inRequest = nil;
    self.failure = nil;
}

#pragma mark -
#pragma mark - TYRequestDelegate
-(NSString *)requestUrl
{
    return @"";
}

-(NSDictionary *)requestHeaders
{
    return nil;
}

-(NSDictionary *)requestParameters
{
    return nil;
}

-(TYRequestMethod)requestMethod
{
    return TYRequestMethodGET;
}

-(TYRequestType)requestType
{
    return TYRequestTypeNormal;
}

-(TYConstructingBlock)requestConstructingBlock
{
    return nil;
}

-(AFHTTPRequestSerializer *)requestSerializer
{
    return [AFHTTPRequestSerializer serializer];
}

#pragma mark -
#pragma mark - TYResponseDelegate

-(TYError *)checkSuccessedResponseObj:(id)responseObj andResponseHeaders:(NSDictionary *)headers
{
    //For Example:
    //TYError *eor = [[TYError alloc]initWithErrorCode:@"code" errorMessage:@"msg"];
    //return eor;
    return nil;
}

-(TYError *)responseDidFailedWithError:(NSError *)error
{
    return nil;
}

-(AFHTTPResponseSerializer *)responseSerializer
{
    return [AFJSONResponseSerializer serializer];
}


+(void)ty_removeCache
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}
- (void)dealloc
{
    [self clear];
}

@end
