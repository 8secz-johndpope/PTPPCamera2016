//
//  PTPPLiveCameraTipsView.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 26/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPLiveCameraTipsView.h"
#import "SOKit.h"
@interface PTPPLiveCameraTipsView ()
@property (nonatomic, strong) UIImageView *topTipsView;
@property (nonatomic, strong) UIImageView *bottomTipsView;
@property (nonatomic, strong) UIImageView *iKnowView;
@property (nonatomic, strong) UIImageView *backButton;
@property (nonatomic, strong) UIImageView *liveStickerButton;
@end

@implementation PTPPLiveCameraTipsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self addSubview:self.topTipsView];
        [self addSubview:self.bottomTipsView];
        [self addSubview:self.iKnowView];
        [self addSubview:self.backButton];
        [self addSubview:self.liveStickerButton];
        [self addTarget:self action:@selector(dismissMe) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setAttributeWithBackButtonFrame:(CGRect)backButtonFrame liveStickerButtonFrame:(CGRect)liveStickerFrame{
    self.backButton.frame = backButtonFrame;
    self.liveStickerButton.frame = liveStickerFrame;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.iKnowView.frame = CGRectMake(0, self.bottomTipsView.top-30-44, self.iKnowView.width, self.iKnowView.height);
    self.iKnowView.center = CGPointMake(self.width/2, self.iKnowView.centerY);
}

-(void)dismissMe{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(UIImageView *)topTipsView{
    if(!_topTipsView){
        _topTipsView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 40, 175, 60)];
        _topTipsView.image = [UIImage imageNamed:@"img_tips_01"];
    }
    return _topTipsView;
}

-(UIImageView *)bottomTipsView{
    if (!_bottomTipsView) {
        _bottomTipsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-100, self.width, 50)];
        _bottomTipsView.image = [UIImage imageNamed:@"img_tips_02"];
        _bottomTipsView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bottomTipsView;
}

-(UIImageView *)iKnowView{
    if (!_iKnowView) {
        _iKnowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        _iKnowView.image = [UIImage imageNamed:@"img_tips_iknow"];
    }
    return _iKnowView;
}

-(UIImageView *)backButton{
    if (!_backButton) {
        _backButton = [[UIImageView alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"icon_back_index"]];
        [_backButton setBackgroundColor:UIColorFromRGB(0x662425)];
        _backButton.contentMode = UIViewContentModeCenter;
    }
    return _backButton;
}

-(UIImageView *)liveStickerButton{
    if (!_liveStickerButton) {
        _liveStickerButton = [[UIImageView alloc] init];
        [_liveStickerButton setImage:[UIImage imageNamed:@"icon_capture_20_15"]];
        _liveStickerButton.contentMode = UIViewContentModeCenter;
    }
    return _liveStickerButton;
}

@end
