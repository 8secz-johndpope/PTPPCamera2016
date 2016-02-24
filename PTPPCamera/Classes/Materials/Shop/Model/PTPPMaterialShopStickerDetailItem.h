//
//  PTPPMaterialShopStickerDetailItem.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 24/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPMaterialShopStickerItem.h"

#define kDescription @"description"
#define kBannerPic @"banner_pic"
#define kThumbnailList @"thumbnail_list"

@interface PTPPMaterialShopStickerDetailItem : PTPPMaterialShopStickerItem
@property (nonatomic, copy) NSString *storeDescription;
@property (nonatomic, copy) NSString *bannerPic;
@property (nonatomic, copy) NSArray *thunbmailList;

+ (instancetype)itemWithDict:(NSDictionary *)dict;
@end
