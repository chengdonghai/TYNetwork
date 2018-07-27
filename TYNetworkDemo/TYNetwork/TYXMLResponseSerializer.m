//
//  TYXMLResponseSerializer.m
//  TYNetwork
//
//  Created by chengdonghai on 16/5/12.
//  Copyright © 2016年 天翼文化. All rights reserved.
//

#import "TYXMLResponseSerializer.h"
#import <XMLDictionary.h>

@implementation TYXMLResponseSerializer

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error
{
    NSXMLParser *parser = [super responseObjectForResponse:response data:data error:error];
    
    if (parser) {
        XMLDictionaryParser *dictParser = [[XMLDictionaryParser alloc] init];
       return [dictParser dictionaryWithParser:parser];
    }
    return nil;
}

@end
