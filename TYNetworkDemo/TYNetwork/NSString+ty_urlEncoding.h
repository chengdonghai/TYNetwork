//
//  NSString+urlEncoding.h
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 16/5/31.
//  Copyright © 2016年 天翼阅读. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ty_urlEncoding)

/**
 *  @brief 解决带中文的url无法转换成NSURL问题，将中文进行url转码
 *
 *  @return 返回转码后的url字符串
 */
-(NSString *)ty_stringByURLEncoding;

@end
