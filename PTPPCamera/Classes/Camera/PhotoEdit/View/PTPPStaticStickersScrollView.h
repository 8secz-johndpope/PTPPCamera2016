//
//  PTPPStaticStickersScrollView.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 23/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPrimaryCollectionViewHeight 40
#define kSecondaryCollectionViewHeight 80
typedef void(^StaticStickerFinishBlock)();
typedef void(^StaticStickerTopUpBlock)();
typedef void (^StaticStickerSelected)(NSString *stickerName, BOOL isFromBundle);

@interface PTPPStaticStickersScrollView : UIView
@property (nonatomic, copy) StaticStickerFinishBlock finishBlock;
@property (nonatomic, copy) StaticStickerSelected stickerSelected;
@property (nonatomic, copy) StaticStickerTopUpBlock topupBlock;
@property (nonatomic, assign) NSInteger activeID;
-(void)setAttributeWithFilePathSet:(NSArray *)filePathSet;
@end
