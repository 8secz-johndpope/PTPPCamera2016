//
//  NSDate+PTDate.h
//  PTLatitude
//
//  Created by so on 15/12/3.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(PTDate)

/*
 规则：
 < 1分       ->  刚刚
 < 1小时     ->   xx分钟前
 < 1天       ->  xx小时前
 < 1年       ->  xx天前
 > 1年       ->  xx年前
 */

- (NSString *)timeDescriptionSinceDate:(NSDate *)anotherDate;
- (NSString *)timeDescriptionSinceTimeInt:(NSTimeInterval)anotherTimeInt;
- (NSString *)timeDescriptionSinceDateString:(NSString *)dateString formatter:(NSString *)formatter;

@end
