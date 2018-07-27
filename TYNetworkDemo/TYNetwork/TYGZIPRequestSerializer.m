//
//  TYGZIPRequestSerializer.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 2018/7/6.
//  Copyright © 2018年 天翼阅读. All rights reserved.
//

#import "TYGZIPRequestSerializer.h"
#import "TYRequestHandler.h"

@implementation TYGZIPRequestSerializer
-(NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing  _Nullable *)error
{
    NSParameterAssert(request);
    id reqParameters = [parameters objectForKey:TYNetworkRequestParametersKey];
    id reqHeaders = [parameters objectForKey:TYNetworkRequestHeadersKey];
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        
        NSURLRequest *req = [super requestBySerializingRequest:request withParameters:reqParameters error:error];
        NSMutableURLRequest *mutableRequest = [req mutableCopy];
        
        [self addCustomHeadersInReq:mutableRequest request:req headers:reqHeaders];
        return mutableRequest;
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    [self addCustomHeadersInReq:mutableRequest request:request headers:reqHeaders];
    
    if (reqParameters) {
        [mutableRequest setValue:@"application/gzip" forHTTPHeaderField:@"Content-Type"];
        [mutableRequest setHTTPBody:reqParameters];
    }
    
    return mutableRequest;
}

-(void)addCustomHeadersInReq:(NSMutableURLRequest *)mutableRequest request:(NSURLRequest *)request headers:(id)headers
{
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull field, id  _Nonnull value, BOOL * _Nonnull stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
}

@end
