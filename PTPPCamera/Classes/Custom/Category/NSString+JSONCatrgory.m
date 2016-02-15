//
//  NSString+JSONCatrgory.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/20.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "NSString+JSONCatrgory.h"

@implementation NSString (JSONCatrgory)

-(id)JSONObj{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)JSONString{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

@end
