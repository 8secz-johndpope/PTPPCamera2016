//
//  PTPPMaterialStickerDetailHeaderView.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 18/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialStickerDetailHeaderView.h"
#import "PTMacro.h"

@interface PTPPMaterialStickerDetailHeaderView ()
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIView *detailContainer;
@property (nonatomic, strong) UILabel *stickerNameLabel;
@property (nonatomic, strong) UILabel *stickerDetailLabel;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, assign) BOOL downloadStatus;
@end

@implementation PTPPMaterialStickerDetailHeaderView

+(CGFloat)getHeightWithStickerDetailText:(NSString *)stickerDetail constraintWidth:(CGFloat)width{
    CGFloat totalHeight = 0;
    totalHeight+= 10*3+[UIFont systemFontOfSize:14].lineHeight+[stickerDetail soSizeWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:width].height+Screenwidth/3+10+4;
    return totalHeight;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bannerImageView];
        [self addSubview:self.detailContainer];
        [self.detailContainer addSubview:self.stickerNameLabel];
        [self.detailContainer addSubview:self.stickerDetailLabel];
        [self.detailContainer addSubview:self.downloadButton];
        self.backgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return self;
}

-(void)setAttributeWithBannerImgURL:(NSString *)bannerImgURL stickerName:(NSString *)stickerName stickerDetail:(NSString *)stickerDetail isDownloaded:(BOOL)downloaded{
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:bannerImgURL] placeholderImage:nil];
    self.stickerNameLabel.text = stickerName;
    self.stickerDetailLabel.text = stickerDetail;
    self.downloadStatus = downloaded;
    if (self.downloadStatus) {
        [self.downloadButton setTitle:@"已下载" forState:UIControlStateNormal];
        self.downloadButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
        
    }else{
        [self.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        self.downloadButton.backgroundColor = UIColorFromRGB(0xff5a5d);
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat detailHeight = [self.stickerDetailLabel.text soSizeWithFont:self.stickerDetailLabel.font constrainedToWidth:self.detailContainer.width-20].height;
    self.stickerNameLabel.frame = CGRectMake(10, 10, self.detailContainer.width-20-10-self.downloadButton.width, self.stickerNameLabel.font.lineHeight);
    self.downloadButton.frame = CGRectMake(self.stickerNameLabel.right+10, 10, self.downloadButton.width, self.downloadButton.height);
    self.downloadButton.center = CGPointMake(self.downloadButton.centerX, self.stickerNameLabel.centerY);
    self.stickerDetailLabel.frame = CGRectMake(10, self.stickerNameLabel.bottom+10, self.detailContainer.width-20, detailHeight);
    self.detailContainer.frame = CGRectMake(0, self.bannerImageView.bottom, self.detailContainer.width, self.stickerDetailLabel.bottom+10);
}

-(void)initiateDownload{
    if (!self.downloadStatus) {
        if (self.downloadAciton) {
            self.downloadAciton();
        }
    }
}

-(UIImageView *)bannerImageView{
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, Screenwidth/3)];
        _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerImageView.clipsToBounds = YES;
    }
    return _bannerImageView;
}

-(UIView *)detailContainer{
    if (!_detailContainer) {
        _detailContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, 0)];
        _detailContainer.backgroundColor = [UIColor whiteColor];
    }
    return _detailContainer;
}

-(UILabel *)stickerNameLabel{
    if (!_stickerNameLabel) {
        _stickerNameLabel = [[UILabel alloc] init];
    }
    return _stickerNameLabel;
}

-(UILabel *)stickerDetailLabel{
    if (!_stickerDetailLabel) {
        _stickerDetailLabel = [[UILabel alloc] init];
        _stickerDetailLabel.font = [UIFont systemFontOfSize:13];
        _stickerDetailLabel.textColor = [UIColor grayColor];
        _stickerDetailLabel.numberOfLines = 0;
    }
    return _stickerDetailLabel;
}

-(UIButton *)downloadButton{
    if (!_downloadButton) {
        _downloadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 84, 25)];
        _downloadButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
        _downloadButton.backgroundColor = UIColorFromRGB(0xff5a5d);
        _downloadButton.layer.cornerRadius = 2;
        _downloadButton.layer.masksToBounds = YES;
        [_downloadButton addTarget:self action:@selector(initiateDownload) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

@end
