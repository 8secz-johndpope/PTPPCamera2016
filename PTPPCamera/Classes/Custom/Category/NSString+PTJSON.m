//
//  NSString+PTJSON.m
//  PTLatitude
//
//  Created by so on 15/12/10.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "NSString+PTJSON.h"

@implementation NSString(PTJSON)
+ (NSString *)JSONStringWithJSONObj:(id)obj {
    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    if(error) {
        return (nil);
    }
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    return (JSONString);
}


@end
