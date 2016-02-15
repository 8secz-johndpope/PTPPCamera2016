//
//  NSString+OAURLEncodingAdditions.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/9.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "NSString+OAURLEncodingAdditions.h"

@implementation NSString (OAURLEncodingAdditions)

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
    return result;
}

@end
