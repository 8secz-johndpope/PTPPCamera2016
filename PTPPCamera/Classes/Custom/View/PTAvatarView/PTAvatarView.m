//
//  AvatarView.m
//  kidsPlay
//
//  Created by Sean Li on 15/7/27.
//  Copyright (c) 2015年 Sean Li. All rights reserved.
//

#import "PTAvatarView.h"
#import "SOKit.h"
#import "UIImageView+WebCache.h"

@interface PTAvatarView()
@property (strong, nonatomic) UIActivityIndicatorView *avatarLoadingView; //头像活动指示
@property (nonatomic, strong) UIView *blackMask;
@end



@implementation PTAvatarView
@synthesize headImageView = _headImageView;
@synthesize avatarLoadingView = _avatarLoadingView;
@synthesize blackMask = _blackMask;

- (void)dealloc{
    SORELEASE(_headImageView);
    SORELEASE(_avatarLoadingView);
    SORELEASE(_blackMask);
    SOSUPERDEALLOC();
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.headImageView];
        
        UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonPressed:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.headImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    self.headImageView.layer.cornerRadius = CGRectGetHeight(self.bounds)/ 2.0;
    
    
    
}

#pragma mark - getter
- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.contentMode = UIViewContentModeScaleAspectFit;
        _headImageView.backgroundColor = [UIColor clearColor];
        
        //头像圆角
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.zPosition = 888;
    }
    return _headImageView;
}


- (UIActivityIndicatorView *)avatarLoadingView{
    if (!_avatarLoadingView) {
        _avatarLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _avatarLoadingView;
}

- (UIView *)blackMask{
    if (!_blackMask) {
        _blackMask = [[UIView alloc] initWithFrame:self.frame];
        _blackMask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _blackMask.layer.masksToBounds = YES;
        _blackMask.layer.cornerRadius = self.frame.size.height / 2.0;
        [_blackMask setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    }
    return _blackMask;
}
#pragma mark -



#pragma mark - setter
#pragma mark -

#pragma mark - actions
- (void)buttonPressed:(UITapGestureRecognizer *)recognizer{
    if (self.clickBlock) {
        self.clickBlock();
    }
}


-(void)startLoadingAnimation{
    [self addSubview:self.blackMask];
    [self.blackMask addSubview:self.avatarLoadingView];
    [self.avatarLoadingView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [self.avatarLoadingView startAnimating];
}

-(void)stopLoadingAnimation{
    [self.blackMask removeFromSuperview];
}


-(void)setAttrbutesWithHeadURL:(NSString*)headURL placeHolder:(NSString *)placeHolder
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headURL]
                          placeholderImage:[UIImage imageNamed:placeHolder]];
   
}

- (void)forceRefreshHeadURL:(NSString *)headURL{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headURL]
                          placeholderImage:[UIImage imageNamed:@"loginIcon"]options:SDWebImageRefreshCached];
}


@end
