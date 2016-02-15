//
//  AvatarView.h
//  kidsPlay
//
//  Created by Sean Li on 15/7/27.
//  Copyright (c) 2015年 Sean Li. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PTAvatarView : UIView

@property(nonatomic,copy)dispatch_block_t clickBlock;
@property (strong, nonatomic) UIImageView *headImageView; //更新头像属性


-(void)setAttrbutesWithHeadURL:(NSString*)headURL placeHolder:(NSString *)placeHolder;
- (void)forceRefreshHeadURL:(NSString *)headURL;

-(void)startLoadingAnimation;
-(void)stopLoadingAnimation;

@end
