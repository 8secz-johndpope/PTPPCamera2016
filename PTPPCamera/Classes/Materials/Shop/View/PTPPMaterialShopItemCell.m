//
//  PTPaiPaiMaterialShopItemCell.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialShopItemCell.h"
#import "SOKit.h"
@interface PTPPMaterialShopItemCell ()

@end

@implementation PTPPMaterialShopItemCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.stickerPreview];
        [self.contentView addSubview:self.downloadStatusView];
        [self.contentView addSubview:self.editStatusView];
        [self.contentView addSubview:self.latestArrivalTag];
    }
    return self;
}

-(void)toggleDownloadButton{

}

-(void)setDownloadStatus:(PTPPMaterialDownloadStatus)downloadStatus{
    _downloadStatusView.hidden = NO;
    _editStatusView.hidden = YES;
    switch (downloadStatus) {
        case PTPPMaterialDownloadStatusReady:
            [self.downloadStatusView setImage:[UIImage imageNamed:@"btn_22_01"] forState:UIControlStateNormal];
            break;
        case PTPPMaterialDownloadStatusInProgress:
            [self.downloadStatusView setImage:[UIImage imageNamed:@"btn_22_02"] forState:UIControlStateNormal];
            break;
        case PTPPMaterialDownloadStatusFinished:
            [self.downloadStatusView setImage:[UIImage imageNamed:@"btn_22_03"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)setEditStatus:(PTPPMaterialEditStatus)editStatus{
    _downloadStatusView.hidden = YES;
    _editStatusView.hidden = NO;
    switch (editStatus) {
        case PTPPMaterialEditStatusItemSelected:
            [self.editStatusView setImage:[UIImage imageNamed:@"check_box_sel"] forState:UIControlStateNormal];
            break;
        case PTPPMaterialEditStatusItemDeselected:
            [self.editStatusView setImage:[UIImage imageNamed:@"check_box_nor"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(void)setSelectionMode:(BOOL)selectionMode{
    if (selectionMode) {
        self.editStatusView.hidden = NO;
    }else{
        self.editStatusView.hidden = YES;
    }
}

-(UIImageView *)stickerPreview{
    if (!_stickerPreview) {
        _stickerPreview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        _stickerPreview.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _stickerPreview.contentMode = UIViewContentModeCenter;
        _stickerPreview.clipsToBounds = YES;
    }
    return _stickerPreview;
}

-(UIButton *)downloadStatusView{
    if (!_downloadStatusView) {
        _downloadStatusView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [_downloadStatusView addTarget:self action:@selector(toggleDownloadButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadStatusView;
}

-(UIButton *)editStatusView{
    if (!_editStatusView) {
        _editStatusView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [_editStatusView addTarget:self action:@selector(toggleDownloadButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editStatusView;
}

-(UIImageView *)latestArrivalTag{
    if (!_latestArrivalTag) {
        _latestArrivalTag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 56, 32)];
        _latestArrivalTag.image = [UIImage imageNamed:@"img_tag_new"];
    }
    return _latestArrivalTag;
}

@end
