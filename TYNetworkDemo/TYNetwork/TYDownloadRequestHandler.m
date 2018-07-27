//
//  TYDownloadRequestHandler.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 16/8/28.
//  Copyright © 2016年 天翼阅读. All rights reserved.
//

#import "TYDownloadRequestHandler.h"
#import "TYDownloadRequest.h"
#import "NSString+ty_urlEncoding.h"
#import <AFHTTPSessionManager.h>
@implementation TYDownloadRequestHandler

+ (instancetype)sharedInstance
{
    static dispatch_once_t one;
    static TYDownloadRequestHandler *handler;
    dispatch_once(&one, ^{
        handler = [self new];
    });
    return handler;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
    }
    return self;
}

-(void)addDownloadRequest:(TYDownloadRequest *)downloadReq
{
    NSString *url = [[downloadReq downloadUrl] ty_stringByURLEncoding];//url encoding
    
    [self createFolderIfNeeded:[downloadReq downloadDestinationPath]];
    
    NSString *tempDestinationPath = [[downloadReq downloadDestinationPath] stringByAppendingString:@".temp"];//解决文件不能覆盖的问题，先换个临时名字，再改名
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.sessionManager.completionQueue = downloadReq.completionQueue;
    self.sessionManager.completionGroup = downloadReq.completionGroup;
    
    NSURLSessionDownloadTask *task = [self.sessionManager downloadTaskWithRequest:req progress:^(NSProgress * _Nonnull downloadProgress) {
        [self downloadingHandle:downloadProgress downloadReq:downloadReq];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:tempDestinationPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self completionHandle:response filePath:filePath error:error downloadReq:downloadReq];
    }];
    downloadReq.downloadTask = task;
 
    [task resume];
    
    
}

-(void)removeDownloadRequest:(TYDownloadRequest *)downloadReq
{
    [downloadReq.downloadTask cancel];
}

-(void)completionHandle:(NSURLResponse *)response filePath:(NSURL*)filePath error:(NSError *)error downloadReq:(TYDownloadRequest *)req
{
    NSLog(@"destinationPath:%@",req.destinationPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //删除老图片，再更新新图片
    if (req.destinationPath) {
        [fileManager removeItemAtPath:req.destinationPath error:nil];

    }
    if (filePath) {
        [fileManager moveItemAtURL:filePath toURL:[NSURL fileURLWithPath:req.destinationPath] error:nil];

    }
    
    req.filePath = filePath;
    req.error = error;
    
    if (req.completionHandler) {
        req.completionHandler(req);
    }
    
    [req clearBlock];
}

-(void)downloadingHandle:(NSProgress *)progress downloadReq:(TYDownloadRequest *)req
{
    req.progress = progress;
    if (req.inProgress) {
        req.inProgress(req);
    }
}

-(void)createFolderIfNeeded:(NSString *)destinationPath
{
    NSString *destinationFolder = [destinationPath stringByDeletingLastPathComponent];
    if (destinationFolder) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:destinationFolder]) {
            [fileManager createDirectoryAtPath:destinationFolder withIntermediateDirectories:YES attributes:nil error:nil];
            
        }
    }
}
@end
