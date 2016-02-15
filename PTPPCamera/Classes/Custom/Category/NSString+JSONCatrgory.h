//
//  NSString+JSONCatrgory.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/20.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "SOBaseItem.h"

@interface NSString (JSONCatrgory)

/**
 * @brief  将NSString转化为NSArray或者NSDictionary
 */
-(id)JSONObj;

/**
 * @brief 将NSArray或者NSDictionary转化为NSString
 */
-(NSData*)JSONString;

@end
