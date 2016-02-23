//
//  PTPPMaterialStickerDetailHeaderView.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 18/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTPPMaterialStickerDetailHeaderView : UICollectionReusableView
-(void)setAttributeWithBannerImgURL:(NSString *)bannerImgURL stickerName:(NSString *)stickerName stickerDetail:(NSString *)stickerDetail isDownloaded:(BOOL)downloaded;
+(CGFloat)getHeightWithStickerDetailText:(NSString *)stickerDetail constraintWidth:(CGFloat)width;
@end
