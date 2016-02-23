//
//  PTPPMaterialShopItemCell.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPPMaterialShopItemCell.h"
    
@interface PTPPMaterialShopStickerItemCell :PTPPMaterialShopItemCell
-(void)setAttributeWithImageURL:(NSString *)imageURL stickerName:(NSString *)stickerName stickerCount:(NSString *)stickerCount binarySize:(NSString *)binarySize downloadStatus:(PTPPMaterialDownloadStatus)downloadStatus isNew:(BOOL)isNew;
-(void)setAttributeWithImageURL:(NSString *)imageURL stickerName:(NSString *)stickerName stickerCount:(NSString *)stickerCount binarySize:(NSString *)binarySize editStatus:(PTPPMaterialEditStatus)editStatus isNew:(BOOL)isNew;
@end
