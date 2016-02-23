//
//  PTPPMaterialShopItemCell.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialShopStickerItemCell.h"
#import "SOKit.h"
#import "UIImageView+WebCache.h"
@interface PTPPMaterialShopStickerItemCell ()
@property (nonatomic, strong) UILabel *stickerNameLabel;
@property (nonatomic, strong) UILabel *stickerDetailLabel;

@end

@implementation PTPPMaterialShopStickerItemCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.stickerNameLabel];
        [self.contentView addSubview:self.stickerDetailLabel];
    }
    return self;
}

-(void)setAttributeWithImageURL:(NSString *)imageURL stickerName:(NSString *)stickerName stickerCount:(NSString *)stickerCount binarySize:(NSString *)binarySize downloadStatus:(PTPPMaterialDownloadStatus)downloadStatus isNew:(BOOL)isNew{
    if (isNew) {
        self.latestArrivalTag.hidden = NO;
    }else{
        self.latestArrivalTag.hidden = YES;
    }
    self.downloadStatus = downloadStatus;
    __weak typeof(self) weakSelf = self;
    [self.stickerPreview sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"img_image_default_g"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            weakSelf.stickerPreview.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
    self.stickerNameLabel.text = stickerName;
    self.stickerDetailLabel.text = [NSString stringWithFormat:@"%@枚 %@",stickerCount,binarySize];
    [self setNeedsLayout];
}

-(void)setAttributeWithImageURL:(NSString *)imageURL stickerName:(NSString *)stickerName stickerCount:(NSString *)stickerCount binarySize:(NSString *)binarySize editStatus:(PTPPMaterialEditStatus)editStatus isNew:(BOOL)isNew{
    if (isNew) {
        self.latestArrivalTag.hidden = NO;
    }else{
        self.latestArrivalTag.hidden = YES;
    }
    self.editStatus = editStatus;
    __weak typeof(self) weakSelf = self;
    [self.stickerPreview sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"img_image_default_g"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            weakSelf.stickerPreview.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
    self.stickerNameLabel.text = stickerName;
    self.stickerDetailLabel.text = [NSString stringWithFormat:@"%@枚 %@",stickerCount,binarySize];
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.stickerNameLabel.frame = CGRectMake(10, (self.height-self.stickerPreview.height)/2-self.stickerNameLabel.font.lineHeight+self.stickerPreview.bottom, self.width-20, self.stickerNameLabel.font.lineHeight);
    self.stickerDetailLabel.frame = CGRectMake(10, self.stickerNameLabel.bottom+10, self.width-15-self.downloadStatusView.width-5, self.stickerDetailLabel.font.lineHeight);
    self.downloadStatusView.frame = CGRectMake(self.width-5-self.downloadStatusView.width, self.height-5-self.downloadStatusView.height, self.downloadStatusView.width, self.downloadStatusView.height);
    self.editStatusView.frame = self.downloadStatusView.frame;
}

-(void)toggleDownloadButton{
    [super toggleDownloadButton];
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
        _stickerDetailLabel.font = [UIFont systemFontOfSize:12];
        _stickerDetailLabel.textColor = [UIColor grayColor];
    }
    return _stickerDetailLabel;
}



@end
