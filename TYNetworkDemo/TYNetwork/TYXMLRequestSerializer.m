//
//  TYXMLRequestSerializer.m
//  TYNetwork
//
//  Created by chengdonghai on 16/5/12.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "TYXMLRequestSerializer.h"
#import <XMLDictionary.h>
#import "TYRequestHandler.h"

@implementation TYXMLRequestSerializer

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
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
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/xml" forHTTPHeaderField:@"Content-Type"];
        }
        
        NSString *xmlString = [reqParameters XMLString];
        [mutableRequest setHTTPBody:[xmlString dataUsingEncoding:self.stringEncoding]];
    }
    
    return mutableRequest;
}

-(NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary<NSString *,id> *)parameters constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> _Nonnull))block error:(NSError *__autoreleasing  _Nullable *)error
{
    id reqParameters = [parameters objectForKey:TYNetworkRequestParametersKey];
    id reqHeaders = [parameters objectForKey:TYNetworkRequestHeadersKey];
    NSMutableURLRequest *mutableRequest = [super multipartFormRequestWithMethod:method URLString:URLString parameters:reqParameters constructingBodyWithBlock:block error:error];
    NSURLRequest *request = [mutableRequest copy];
    [self addCustomHeadersInReq:mutableRequest request:request headers:reqHeaders];
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
