//
//  PTRecommendAppBottomView.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 27/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTRecommendAppBottomView.h"
#import "SOKit.h"
#import "PTMacro.h"

@interface PTRecommendAppBottomView ()
@property (nonatomic, strong) UIImageView *appIcon;
@property (nonatomic, strong) UILabel *appTitle;
@property (nonatomic, strong) UILabel *appSubtitle;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) NSString *urlScheme;
@property (nonatomic, strong) NSString *appStoreLink;
@end

@implementation PTRecommendAppBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.appIcon];
        [self addSubview:self.appTitle];
        [self addSubview:self.appSubtitle];
        [self addSubview:self.actionButton];
    }
    return self;
}

-(void)setAttributeWithAppIcon:(NSString *)iconName appTitle:(NSString *)title appSubtitle:(NSString *)subtitle urlScheme:(NSString *)urlScheme appStoreLink:(NSString *)appStoreLink{
    self.appIcon.image = [UIImage imageNamed:iconName];
    self.appTitle.text = title;
    self.appSubtitle.text = subtitle;
    self.urlScheme = urlScheme;
    self.appStoreLink = appStoreLink;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlScheme]]) {
        //App installed
        [self.actionButton setTitle:@"立即打开" forState:UIControlStateNormal];
    }else{
        [self.actionButton setTitle:@"立即下载" forState:UIControlStateNormal];
        //App not installed
       
    }

    [self layoutSubviews];
}

-(void)toggleAction{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.urlScheme]]) {
        //App installed
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlScheme]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appStoreLink]];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.appIcon.frame = CGRectMake(20, self.height/2-self.appIcon.height/2, self.appIcon.width, self.appIcon.height);
    self.appTitle.frame = CGRectMake(self.appIcon.right+10, self.appIcon.top, self.appTitle.width, self.appTitle.font.lineHeight);
    self.appSubtitle.frame = CGRectMake(self.appIcon.right+10, self.appTitle.bottom+5, self.appSubtitle.width, self.appSubtitle.font.lineHeight);
    self.actionButton.frame = CGRectMake(self.width-20-self.actionButton.width, self.height/2-self.actionButton.height/2, self.actionButton.width, self.actionButton.height);
}

-(UIImageView *)appIcon{
    if (!_appIcon) {
        _appIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        _appIcon.image = [UIImage imageNamed:@"icon_40_10"];
    }
    return _appIcon;
}

-(UILabel *)appTitle{
    if (!_appTitle) {
        _appTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screenwidth/2, 0)];
    }
    return _appTitle;
}

-(UILabel *)appSubtitle{
    if (!_appSubtitle) {
        _appSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screenwidth/2, 0)];
        _appSubtitle.font = [UIFont systemFontOfSize:12];
    }
    return _appSubtitle;
}

-(UIButton *)actionButton{
    if (!_actionButton) {
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
        _actionButton.backgroundColor = UIColorFromRGB(0xff5a5d);
        _actionButton.layer.cornerRadius = 5;
        _actionButton.layer.masksToBounds = YES;
        [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(toggleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

@end
