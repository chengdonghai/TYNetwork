//
//  TYRequestHandler.m
//  TYNetwok
//
//  Created by chengdonghai on 16/5/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "TYRequestHandler.h"
#import "TYRequestDefine.h"
#import "TYNetworkConfig.h"
#import "NSString+ty_urlEncoding.h"

NSString *const TYNetworkRequestParametersKey = @"TYNetworkRequestParametersKey__";
NSString *const TYNetworkRequestHeadersKey = @"TYNetworkRequestHeadersKey__";
#define TY_NETWORK_NO_NETWORK_MESSAGE @"当前没有网络"

@interface TYRequestHandler()

@property(nonatomic,strong) NSMutableDictionary<NSString *,AFHTTPSessionManager *> *sessionManagerPool;
@end
@implementation TYRequestHandler

+ (instancetype)sharedInstance
{
    static dispatch_once_t one;
    static TYRequestHandler *handler;
    dispatch_once(&one, ^{
        handler = [self new];
    });
    return handler;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManagerPool = [NSMutableDictionary dictionary];//用来存放sessionmanager
        
        
    }
    return self;
}

-(void)addRequest:(TYRequest *)req
{
    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [self handleNoNetwrokWithRequest:req];//处理没网的情况
        return;
    }
    TYRequestMethod method = [req requestMethod];
    TYRequestType reqType = [req requestType];
    id requestParameters = [req requestParameters];
    NSString *url = [self buildRequestUrl: [req requestUrl]];
    NSDictionary *requestHeaders = [req requestHeaders];
    void(^constructingBlock)(id<AFMultipartFormData>) = [[req requestConstructingBlock] copy];
    
    AFHTTPSessionManager *sessionManager = [self getSessionManagerFromPoolWithRequest:req];
    
    //Converter
    if ([req respondsToSelector:@selector(requestParameterBeforeConverted:)]) {
        requestParameters = [req requestParameterBeforeConverted:requestParameters];
    }
    
    if (method == TYRequestMethodPOST) {
        if (req.requestConverter) {
            requestParameters = [req.requestConverter requestParametersForParameters:requestParameters];
        }
    }
    
    
    if ([req respondsToSelector:@selector(requestParameterAfterConverted:)]) {
        requestParameters = [req requestParameterAfterConverted:requestParameters];
    }
    
    NSMutableDictionary *parametersAndHeaders = [NSMutableDictionary dictionary];
    if (requestParameters) {
        [parametersAndHeaders setObject:requestParameters forKey:TYNetworkRequestParametersKey];
    }
    if (requestHeaders) {
        [parametersAndHeaders setObject:requestHeaders forKey:TYNetworkRequestHeadersKey];
    }
    
    NSURLSessionDataTask *returnedTask = nil;

    if (method == TYRequestMethodGET) {
       returnedTask = [sessionManager GET:url parameters:parametersAndHeaders progress:^(NSProgress * _Nonnull downloadProgress) {
           [self handleInProgressBlock:downloadProgress req:req];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //6.0_lis,网络请求
            [self handleSuccessResponseBlock:task req:req responseObj:responseObject];
            //PLog(@"Success_Res,URL:%@\nResponse: %@",url,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleFailureResponseBlock:task req:req error:error];
            //PLog(@"Fail_Res,URL:%@\n%@",url,error);
        }];
        
    } else if (method == TYRequestMethodPOST) {
        if (reqType == TYRequestTypeNormal) {
            returnedTask = [sessionManager POST:url parameters:parametersAndHeaders progress:^(NSProgress * _Nonnull uploadProgress) {
                [self handleInProgressBlock:uploadProgress req:req];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessResponseBlock:task req:req responseObj:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleFailureResponseBlock:task req:req error:error];
            }];
        } else if(reqType == TYRequestTypeUpload){
            [sessionManager POST:url parameters:parametersAndHeaders constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                if (constructingBlock) {
                    constructingBlock(formData);
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                [self handleInProgressBlock:uploadProgress req:req];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleSuccessResponseBlock:task req:req responseObj:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleFailureResponseBlock:task req:req error:error];
            }];
        }
        
     
        
    } else if (method == TYRequestMethodHEAD) {
        returnedTask = [sessionManager HEAD:url parameters:parametersAndHeaders success:^(NSURLSessionDataTask * _Nonnull task) {
            [self handleSuccessResponseBlock:task req:req responseObj:nil];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleFailureResponseBlock:task req:req error:error];

        }];
    }
    req.task = returnedTask;
}

-(void)removeRequest:(TYRequest *)req
{
    [req.task cancel];
}

-(void)handleInProgressBlock:(NSProgress *)progress req:(TYRequest *)req
{
    req.progress = progress;
    if (req.inRequest) {
        req.inRequest(req);
    }
    
}
-(void)handleSuccessResponseBlock:(NSURLSessionDataTask *)task req:(TYRequest *)req responseObj:(id)respObj
{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSDictionary *responseHeaders = response.allHeaderFields;
    req.responseHeaders = responseHeaders;//响应头
    req.responseSerializeredObject = respObj;
    
    if ([req respondsToSelector:@selector(responseDataBeforeConverted:)]) {
        respObj = [req responseDataBeforeConverted:respObj];
    }

    if (req.responseConverter) {
        respObj = [req.responseConverter responseDataForResponseObject:respObj];
    }
    //6.0_lis,网络请求
//    if (![req.requestHeaders[@"Action"] isEqualToString:@"getChapterInfo"] || ![req.requestHeaders[@"Action"] isEqualToString:@"getContentInfo"]) {
//        
//        PLog(@"XML_Action: %@\nRequestHeaders: %@\nResponseHeaders: %@\nParameters: %@\nrespObj: %@",req.requestHeaders[@"Action"], req.responseHeaders,req.responseHeaders, req.requestParameters, respObj);
//    }
    
    if ([req respondsToSelector:@selector(responseDataAfterConverted:)]) {
        respObj = [req responseDataAfterConverted:respObj];
    }
    
    req.responseObject = respObj;//响应体

    TYError *error = [req checkSuccessedResponseObj:respObj andResponseHeaders:responseHeaders];
    
    if (error) {
        error.errorType = TYErrorTypeBusinessLogic;
        [self handleFilureBlock:req error:error];
    } else {
        if (req.sucess) {
            req.sucess(req);
        }
        [req clearBlock];
        
    }
    
}

-(void)handleFailureResponseBlock:(NSURLSessionDataTask *)task req:(TYRequest *)req error:(NSError *)error
{
    TYError *tyeror = [req responseDidFailedWithError:error];
    if (tyeror) {
        tyeror.errorType = TYErrorTypeHTTP;
        tyeror.httpErrorType = TYHTTPErrorTypeOther;
        [self handleFilureBlock:req error:tyeror];
    } else {
        TYError *eor = [[TYError alloc]initWithDomain:error.domain code:error.code userInfo:error.userInfo];
        eor.errorCode = [NSString stringWithFormat:@"%li",(long)error.code];
        if([TYNetworkConfig sharedInstance].networkRequestFailMessage) {
            eor.errorMessage = [TYNetworkConfig sharedInstance].networkRequestFailMessage;
        } else {
            eor.errorMessage = [error localizedDescription];
        }
        eor.errorType = TYErrorTypeHTTP;
        eor.httpErrorType = TYHTTPErrorTypeOther;

        [self handleFilureBlock:req error:eor];
    }
    
}

//处理没有网络的情况
-(void)handleNoNetwrokWithRequest:(TYRequest *)req
{
    
    NSString *errorMessage = [TYNetworkConfig sharedInstance].noNetworkMessage?:TY_NETWORK_NO_NETWORK_MESSAGE;
    TYError *eor = [[TYError alloc]initWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
    eor.errorCode = [NSString stringWithFormat:@"%li",(long)NSURLErrorNotConnectedToInternet];
    eor.errorMessage = errorMessage;
    TYError *tyeror = [req responseDidFailedWithError:eor];
    if (tyeror) {
        tyeror.errorType = TYErrorTypeHTTP;
        tyeror.httpErrorType = TYHTTPErrorTypeNoNetwork;
        [self handleFilureBlock:req error:tyeror];
    } else {
        eor.errorType = TYErrorTypeHTTP;
        eor.httpErrorType = TYHTTPErrorTypeNoNetwork;
        [self handleFilureBlock:req error:eor];
    }
    
}

-(void)handleFilureBlock:(TYRequest *)req error:(TYError *)error
{
    req.error = error;
    if (req.failure) {
        req.failure(req);
    }
    [req clearBlock];
}

//获取sessionmanager，
-(AFHTTPSessionManager *)getSessionManagerFromPoolWithRequest:(TYRequest *)req
{
    
    AFHTTPRequestSerializer * requestSerializer = [req requestSerializer];
    AFHTTPResponseSerializer * responseSerializer = [req responseSerializer];
    NSString *sessionManagerKey =[NSString stringWithFormat:@"%@_%@_%@_%@",NSStringFromClass([requestSerializer class]),NSStringFromClass([responseSerializer class]),NSStringFromClass([req.completionQueue class]),NSStringFromClass([req.completionGroup class])];//这个作为key
    
    AFHTTPSessionManager *sessionManager = self.sessionManagerPool[sessionManagerKey];
    if (sessionManager == nil) {
        sessionManager = [self newSessionManager];
        sessionManager.requestSerializer = requestSerializer;
        sessionManager.responseSerializer = responseSerializer;
        sessionManager.completionQueue = req.completionQueue;
        sessionManager.completionGroup = req.completionGroup;
        self.sessionManagerPool[sessionManagerKey] = sessionManager;
        
    }
    
    
    return sessionManager;
}

-(NSString *)buildRequestUrl:(NSString *)url
{
    NSString *lowerUrl = [url lowercaseString];
    if ([lowerUrl hasPrefix:@"http"]) {
        return [url ty_stringByURLEncoding];
    } else {
        NSString *baseUrl = [TYNetworkConfig sharedInstance].baseUrl;
        if (baseUrl && baseUrl.length > 0) {
            return [[NSString stringWithFormat:@"%@/%@",baseUrl,url] ty_stringByURLEncoding];
        } else {
            return [url ty_stringByURLEncoding];
        }
    }
}
-(AFHTTPSessionManager *)newSessionManager
{
    return [AFHTTPSessionManager manager];
}
@end
