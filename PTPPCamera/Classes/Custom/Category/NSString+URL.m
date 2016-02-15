//
//  NSString+URL.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/25.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSString *)URLEncodedString
{
    /*
     CFStringRef CFURLCreateStringByAddingPercentEscapes(CFAllocatorRef allocator, CFStringRef originalString, CFStringRef charactersToLeaveUnescaped, CFStringRef legalURLCharactersToBeEscaped, CFStringEncoding encoding) CF_DEPRECATED(10_0, 10_11, 2_0, 9_0, "Use [NSString stringByAddingPercentEncodingWithAllowedCharacters:] instead, which always uses the recommended UTF-8 encoding, and which encodes for a specific URL component or subcomponent (since each URL component or subcomponent has different rules for what characters are valid).");

     */
    
    /*
    NSString *encodedString = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8);
     */
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,(CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",NULL,kCFStringEncodingUTF8));
    
    
    return encodedString;
}

@end
