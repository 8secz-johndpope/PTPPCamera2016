//
//  PTDebugManager.h
//  PTRequestDebugManager
//
//  Created by so on 15/12/31.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTDebugManager : NSObject
+ (instancetype)manager;
- (void)show;
- (void)dismiss;
@end
