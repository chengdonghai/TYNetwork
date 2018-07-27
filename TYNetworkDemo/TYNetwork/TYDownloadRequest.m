//
//  TYDownloadRequest.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 16/8/28.
//  Copyright © 2016年 天翼阅读. All rights reserved.
//

#import "TYDownloadRequest.h"
#import "TYDownloadRequestHandler.h"

@implementation TYDownloadRequest

- (instancetype)initWithUrl:(NSString *)url andDestinationPath:(NSString *)destinationPath
{
    self = [super init];
    if (self) {
        self.url = url;
        self.destinationPath = destinationPath;
    }
    return self;
}
-(NSString *)downloadUrl
{
    return self.url;
}

-(NSString *)downloadDestinationPath
{
    return self.destinationPath;
}

-(void)startDownload
{
    [self startDownloadWithCompletionHandle:nil];
}

-(void)startDownloadWithCompletionHandle:(TYDownloadRequestBlock)completionHandle
{
    [self startDownloadWithProgress:nil completionHandle:completionHandle];
}

-(void)startDownloadWithProgress:(TYDownloadRequestBlock)progressBlock completionHandle:(TYDownloadRequestBlock )completionHandle
{
    if (progressBlock) {
        self.inProgress = progressBlock;
    }
    if (completionHandle) {
        self.completionHandler = completionHandle;
    }
    
    [[TYDownloadRequestHandler sharedInstance] addDownloadRequest:self];
}



-(void)cancelDownload
{
    [[TYDownloadRequestHandler sharedInstance] removeDownloadRequest:self];
}

-(void)suspendDownload
{
    [self.downloadTask suspend];
}

-(void)contiueDownload
{
    [self.downloadTask resume];
}

-(void)clearBlock
{
    self.inProgress = nil;
    self.completionHandler = nil;
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
    [self clearBlock];
}
@end
