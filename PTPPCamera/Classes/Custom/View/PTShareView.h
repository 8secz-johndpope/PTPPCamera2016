//
//  PTShareView.h
//  PTLatitude
//
//  Created by CHEN KAIDI on 11/12/2015.
//  Copyright © 2015 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

extern CGFloat const PTShareImageMaxSize;
extern CGFloat const PTShareImageThumbSize;
UIImage *PTShareCopmpressImage(CGFloat maxSize, UIImage *image);

extern NSString *PTShareOptionWechatFriends;
extern NSString *PTShareOptionWechatNewsFeed;
extern NSString *PTShareOptionQQFriends;
extern NSString *PTShareOptionQQZone;
extern NSString *PTShareOptionSinaWeibo;
extern NSString *PTShareOptionWebLink ;

@interface PTShareView : UIView
+(void)showOptionsWithTitle:(NSString *)title thumbImage:(UIImage *)thumb webURL:(NSString *)webURL message:(NSString *)message description:(NSString *)description options:(NSArray *)options;
@end
