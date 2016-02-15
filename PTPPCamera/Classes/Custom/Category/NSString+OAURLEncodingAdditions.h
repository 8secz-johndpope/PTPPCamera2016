//
//  NSString+OAURLEncodingAdditions.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/9.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "SOBaseItem.h"


/**
 * 如果需要转换一个NSString, 只需要
 
 NSString *temp = [@"测试utf8" URLEncodedString];
 NSString *decoded = [temp URLDecodedString];
 
 */
@interface NSString (OAURLEncodingAdditions)
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;
@end
