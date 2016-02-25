//
//  PTPPLiveStickerScrollView.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 21/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LiveStickerFinishBlock)();
typedef void (^StickerSelected)(NSString *filePath, BOOL isFromBundle);
@interface PTPPLiveStickerScrollView : UIView
@property (nonatomic, copy) LiveStickerFinishBlock finishBlock;
@property (nonatomic, copy) StickerSelected stickerSelected;
@property (nonatomic, strong) NSString *selectedStickerName;
-(void)setAttributeWithLocalCacheWithPreinstalledSet:(NSArray *)preinstalledSet;
@end
