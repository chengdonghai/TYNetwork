//
//  NSString+urlEncoding.m
//  SurfingReader_V4.0
//
//  Created by chengdonghai on 16/5/31.
//  Copyright © 2016年 天翼阅读. All rights reserved.
//

#import "NSString+ty_urlEncoding.h"

@implementation NSString (ty_urlEncoding)


-(NSString *)ty_stringByURLEncoding
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
@end
