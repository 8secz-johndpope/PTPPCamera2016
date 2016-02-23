//
//  PTPPMaterialShopJigsawItemCell.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialShopJigsawItemCell.h"
#import "UIImageView+WebCache.h"
#import "SOKit.h"

@implementation PTPPMaterialShopJigsawItemCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setAttributeWithImageURL:(NSString *)imageURL downloadStatus:(PTPPMaterialDownloadStatus)downloadStatus isNew:(BOOL)isNew{
    if (isNew) {
        self.latestArrivalTag.hidden = NO;
    }else{
        self.latestArrivalTag.hidden = YES;
    }
    self.downloadStatus = downloadStatus;
    __weak typeof(self) weakSelf = self;
    [self.stickerPreview sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"img_image_default_g"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
            weakSelf.stickerPreview.contentMode = UIViewContentModeScaleAspectFill;
    }];
    [self setNeedsLayout];
}

-(void)setAttributeWithImageURL:(NSString *)imageURL editStatus:(PTPPMaterialEditStatus)editStatus isNew:(BOOL)isNew{
    if (isNew) {
        self.latestArrivalTag.hidden = NO;
    }else{
        self.latestArrivalTag.hidden = YES;
    }
    self.editStatus = editStatus;
    __weak typeof(self) weakSelf = self;
    [self.stickerPreview sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"img_image_default_g"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
            weakSelf.stickerPreview.contentMode = UIViewContentModeScaleAspectFill;
    }];
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.stickerPreview.frame = CGRectMake(0, 0, self.width, self.height);
    self.downloadStatusView.frame = CGRectMake(self.width-5-self.downloadStatusView.width, self.height-5-self.downloadStatusView.height, self.downloadStatusView.width, self.downloadStatusView.height);
    self.editStatusView.frame = self.downloadStatusView.frame;
}

-(void)toggleDownloadButton{
    [super toggleDownloadButton];
}
@end
