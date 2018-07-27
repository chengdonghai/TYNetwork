//
//  TYError.h
//  TYNetwork
//
//  Created by chengdonghai on 16/5/13.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import <Foundation/Foundation.h>
//错误类型
typedef enum : NSUInteger {
    TYErrorTypeHTTP = 1,
    TYErrorTypeBusinessLogic,
    TYErrorTypeOther
} TYErrorType;
//http 错误类型
typedef enum : NSUInteger {
    TYHTTPErrorTypeNoNetwork = 1,
    TYHTTPErrorTypeOther
} TYHTTPErrorType;

@interface TYError : NSError

- (instancetype)initWithErrorCode:(NSString *)code errorMessage:(NSString *)errorMessage;

@property(nonatomic,copy) NSString *errorCode;
@property(nonatomic,copy) NSString *errorMessage;
@property(nonatomic) TYErrorType errorType;
@property(nonatomic) TYHTTPErrorType httpErrorType;

@property(nonatomic,assign,readonly) NSInteger errorCodeForInt;

@end
