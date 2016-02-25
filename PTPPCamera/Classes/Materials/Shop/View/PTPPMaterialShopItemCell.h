//
//  PTPaiPaiMaterialShopItemCell.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PTPPMaterialDownloadStatus){
    PTPPMaterialDownloadStatusReady = 0,
    PTPPMaterialDownloadStatusInProgress = 1,
    PTPPMaterialDownloadStatusFinished = 2
};

typedef NS_ENUM(NSInteger, PTPPMaterialEditStatus){
    PTPPMaterialEditStatusItemSelected = 1,
    PTPPMaterialEditStatusItemDeselected = 2
};
typedef void(^DownloadAction)();

@interface PTPPMaterialShopItemCell : UICollectionViewCell

@property (nonatomic, copy) DownloadAction downloadAction;
@property (nonatomic, assign) PTPPMaterialDownloadStatus downloadStatus;
@property (nonatomic, assign) PTPPMaterialEditStatus editStatus;
@property (nonatomic, assign) BOOL selectionMode;
@property (nonatomic, strong) UIImageView *stickerPreview;
@property (nonatomic, strong) UIButton *downloadStatusView;
@property (nonatomic, strong) UIButton *editStatusView;
@property (nonatomic, strong) UIImageView *latestArrivalTag;
@property (nonatomic, strong) UIActivityIndicatorView *cellLoadingView;

-(void)toggleDownloadButton;
@end
