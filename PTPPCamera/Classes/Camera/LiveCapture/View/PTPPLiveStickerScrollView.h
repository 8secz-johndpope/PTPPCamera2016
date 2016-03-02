//
//  PTPPLiveStickerScrollView.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 21/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPPMaterialShopStickerItem.h"

typedef void(^LiveStickerFinishBlock)();
typedef void (^StickerSelected)(NSString *filePath, BOOL isFromBundle);
typedef void (^ActionDownload)(NSString *sourceURL, NSString *destURL, PTPPMaterialShopStickerItem *item);
@interface PTPPLiveStickerScrollView : UIView
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) LiveStickerFinishBlock finishBlock;
@property (nonatomic, copy) StickerSelected stickerSelected;
@property (nonatomic, copy) ActionDownload actionDownload;
@property (nonatomic, strong) NSString *selectedStickerName;
-(void)setAttributeWithLocalCacheWithPreinstalledSet:(NSArray *)preinstalledSet;
-(void)loadNewARStickerData;
@end
