//
//  PTPPMaterialShopStickerItem.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 24/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "SOBaseItem.h"

#define kPackageID @"id"
#define kPackageName @"name"
#define kSecondType @"second_type"
#define kDownloadURL @"download_url"
#define kPackageSize @"size"
#define kTotalNum @"num"
#define kMaxNum @"max_num"
#define kIcon @"icon"
#define kCoverPic @"cover_pic"
#define kReleaseTime @"release_time"
#define kIsNew @"is_new"

@interface PTPPMaterialShopStickerItem : SOBaseItem
@property (nonatomic, copy) NSString *packageID;
@property (nonatomic, copy) NSString *packageName;
@property (nonatomic, copy) NSString *secondType;
@property (nonatomic, copy) NSString *downloadURL;
@property (nonatomic, copy) NSString *packageSize;
@property (nonatomic, copy) NSString *totalNum;
@property (nonatomic, copy) NSString *maxNum;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *coverPic;
@property (nonatomic, copy) NSString *releaseTime;
@property (nonatomic, assign) BOOL isNew;

+ (instancetype)itemWithDict:(NSDictionary *)dict;
@end
