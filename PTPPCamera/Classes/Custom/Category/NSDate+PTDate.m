//
//  NSDate+PTDate.m
//  PTLatitude
//
//  Created by so on 15/12/3.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "NSDate+PTDate.h"
#import "NSDate+SOAdditions.h"

#define PT_MINUTE_TIMEINT    (60)
#define PT_HOUR_TIMEINT      (60 * 60)
#define PT_DAY_TIMEINT       (60 * 60 * 24)
#define PT_YEAR_TIMEINT      (60 * 60 * 24 * 365)

@implementation NSDate(PTDate)

- (NSString *)timeDescriptionSinceDate:(NSDate *)anotherDate {
    return ([self timeDescriptionSinceTimeInt:[anotherDate timeIntervalSince1970]]);
}

- (NSString *)timeDescriptionSinceTimeInt:(NSTimeInterval)anotherTimeInt {
    NSTimeInterval nowTimeInt = [self timeIntervalSince1970];
    NSTimeInterval distanceTimeInt = nowTimeInt - anotherTimeInt;
    if(distanceTimeInt < PT_MINUTE_TIMEINT) {
        return (@"刚刚");
    }
    if(distanceTimeInt < PT_HOUR_TIMEINT) {
        return ([NSString stringWithFormat:@"%0.0f分钟前", distanceTimeInt / PT_MINUTE_TIMEINT]);
    }
    if(distanceTimeInt < PT_DAY_TIMEINT) {
        return ([NSString stringWithFormat:@"%0.0f小时前", distanceTimeInt / PT_HOUR_TIMEINT]);
    }
    if(distanceTimeInt < PT_YEAR_TIMEINT) {
        return ([NSString stringWithFormat:@"%0.0f天前", distanceTimeInt / PT_DAY_TIMEINT]);
    }
    return ([NSString stringWithFormat:@"%0.0f年前", distanceTimeInt / PT_YEAR_TIMEINT]);
}

- (NSString *)timeDescriptionSinceDateString:(NSString *)dateString formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return ([self timeDescriptionSinceDate:date]);
}

@end
