//
//  TYRequestDefine.h
//  TYNetwok
//
//  Created by chengdonghai on 16/5/11.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#ifndef TYRequestDefine_h
#define TYRequestDefine_h


#endif /* TYRequestDefine_h */
/**
 HTTP request Method
 */
typedef enum : NSUInteger {
    TYRequestMethodGET = 0,
    TYRequestMethodPOST,
    TYRequestMethodHEAD,
    TYRequestMethodPUT,
    TYRequestMethodBATCH,
    TYRequestMethodDELETE
} TYRequestMethod;

/**
 HTTP request Type
 */
typedef enum : NSUInteger {
    TYRequestTypeNormal = 0,
    TYRequestTypeUpload
} TYRequestType;