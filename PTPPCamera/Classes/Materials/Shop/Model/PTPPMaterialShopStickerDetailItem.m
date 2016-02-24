//
//  PTPPMaterialShopStickerDetailItem.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 24/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPMaterialShopStickerDetailItem.h"

@implementation PTPPMaterialShopStickerDetailItem

+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTPPMaterialShopStickerDetailItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    item.storeDescription = [dict safeStringForKey:kDescription];
    item.bannerPic = [dict safeStringForKey:kBannerPic];
    item.thunbmailList = [dict safeObjectForKey:kThumbnailList];
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _storeDescription = nil;
        _bannerPic = nil;
        _thunbmailList = nil;
    }
    return (self);
}

- (id)copyWithZone:(NSZone *)zone {
    PTPPMaterialShopStickerDetailItem *item = [super copyWithZone:zone];
    item.storeDescription = self.storeDescription;
    item.bannerPic = self.bannerPic;
    item.thunbmailList = self.thunbmailList;
    return (item);
}

@end
