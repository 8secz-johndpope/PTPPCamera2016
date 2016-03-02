//
//  PTLiveStickerPickerCell.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 21/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTLiveStickerPickerCell.h"
#import "SOkit.h"
@interface PTLiveStickerPickerCell ()
@property (nonatomic, strong) UIImageView *stickerPreview;
@property (nonatomic, strong) UIImageView *tickIcon;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *downloadingView;
@end

@implementation PTLiveStickerPickerCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.stickerPreview];
        [self.contentView addSubview:self.tickIcon];
        [self.contentView addSubview:self.loadingView];
        [self.tickIcon addSubview:self.downloadingView];
        self.loadingView.center = self.contentView.center;
        self.loadingView.hidden = YES;
        self.downloadingView.hidden = YES;
    }
    return self;
}

-(void)setAttributeWithImage:(UIImage *)image selected:(BOOL)selected{
    self.stickerPreview.image = image;
    self.tickIcon.hidden = !selected;
    self.tickIcon.image = [UIImage imageNamed:@"btn_22_03"];
    self.downloadingView.hidden = YES;
    [self setNeedsLayout];
}

-(void)setAttributeWithImageURL:(NSString *)imageURL selected:(BOOL)selected downloadStatus:(PTLiveStickerDownloadStatus)downloadStatus{
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    __weak typeof(self) weakSelf = self;
    [self.stickerPreview sd_setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.loadingView stopAnimating];
        weakSelf.loadingView.hidden = YES;
    }];
    
    if (downloadStatus == PTLiveStickerDownloadStatusNotDownloaded) {
        self.tickIcon.hidden = NO;
        self.tickIcon.image = [UIImage imageNamed:@"btn_22_07"];
        self.downloadingView.hidden = YES;
    }else if (downloadStatus == PTLiveStickerDownloadStatusDownloaded){
        self.tickIcon.hidden = !selected;
        self.tickIcon.image = [UIImage imageNamed:@"btn_22_03"];
        self.downloadingView.hidden = YES;
    }else{
        self.tickIcon.hidden = NO;
        self.tickIcon.image = [UIImage imageNamed:@"btn_22_08"];
        self.downloadingView.hidden = NO;
        [self.downloadingView startAnimating];
    }
    [self setNeedsLayout];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.tickIcon.frame = CGRectMake(self.width-self.tickIcon.width-10, self.height-self.tickIcon.height-10, self.tickIcon.width, self.tickIcon.height);
}

-(UIImageView *)stickerPreview{
    if (!_stickerPreview) {
        _stickerPreview = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _stickerPreview;
}

-(UIImageView *)tickIcon{
    if (!_tickIcon) {
        _tickIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _tickIcon.image = [UIImage imageNamed:@"btn_22_03"];
    }
    return _tickIcon;
}

-(UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _loadingView;
}

-(UIActivityIndicatorView *)downloadingView{
    if (!_downloadingView) {
        _downloadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _downloadingView;
}

@end
