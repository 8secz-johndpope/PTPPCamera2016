//
//  PTPPMaterialShopStickerItem.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 24/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPMaterialShopStickerItem.h"

@implementation PTPPMaterialShopStickerItem

+ (instancetype)itemWithDict:(NSDictionary *)dict {
    PTPPMaterialShopStickerItem *item = [super itemWithDict:dict];
    if(!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return (item);
    }
    item.packageID = [dict safeStringForKey:kPackageID];
    item.packageName = [dict safeStringForKey:kPackageName];
    item.secondType = [dict safeStringForKey:kSecondType];
    item.downloadURL = [dict safeStringForKey:kDownloadURL];
    item.packageSize = [dict safeStringForKey:kPackageSize];
    item.totalNum = [dict safeStringForKey:kTotalNum];
    item.maxNum = [dict safeStringForKey:kMaxNum];
    item.icon = [dict safeStringForKey:kIcon];
    item.coverPic = [dict safeStringForKey:kCoverPic];
    item.releaseTime = [dict safeStringForKey:kReleaseTime];
    item.isNew = [[dict safeStringForKey:kIsNew] boolValue];
    return (item);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _packageID = nil;
        _packageName = nil;
        _secondType = nil;
        _downloadURL = nil;
        _packageSize = nil;
        _totalNum = nil;
        _maxNum = nil;
        _icon = nil;
        _coverPic = nil;
        _releaseTime = nil;
    }
    return (self);
}

- (id)copyWithZone:(NSZone *)zone {
    PTPPMaterialShopStickerItem *item = [super copyWithZone:zone];
    item.packageID = self.packageID;
    item.packageName = self.packageName;
    item.secondType = self.secondType;
    item.downloadURL = self.downloadURL;
    item.packageSize = self.packageSize;
    item.totalNum = self.totalNum;
    item.maxNum = self.maxNum;
    item.icon = self.icon;
    item.coverPic = self.coverPic;
    item.releaseTime = self.releaseTime;
    item.isNew = self.isNew;
    return (item);
}

@end

