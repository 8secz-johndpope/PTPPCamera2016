//
//  PTLiveStickerPickerCell.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 21/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , PTLiveStickerDownloadStatus){
    PTLiveStickerDownloadStatusNotDownloaded = 0,
    PTLiveStickerDownloadStatusDownloading = 1,
    PTLiveStickerDownloadStatusDownloaded =2
};

@interface PTLiveStickerPickerCell : UICollectionViewCell
-(void)setAttributeWithImage:(UIImage *)image selected:(BOOL)selected;
-(void)setAttributeWithImageURL:(NSString *)imageURL selected:(BOOL)selected downloadStatus:(PTLiveStickerDownloadStatus)downloadStatus;
@end
