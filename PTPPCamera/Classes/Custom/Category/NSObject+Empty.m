//
//  NSObject+Empty.m
//  PTLatitude
//
//  Created by so on 16/1/27.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "NSObject+Empty.h"

@implementation NSObject (Empty)

- (BOOL)objectIsEmpty {
    if (self == nil || self == Nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([self isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self;
        return [arr count] == 0;
    }
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)self;
        return [dict count] == 0;
    }
    if ([self isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)self;
        return [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
    }
    
    return NO;
}

@end
