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

@interface PTPPMaterialShopStickerItem : SOBaseItem
@property (nonatomic, strong) NSString *packageID;
@property (nonatomic, strong) NSString *packageName;
@property (nonatomic, strong) NSString *secondType;
@property (nonatomic, strong) NSString *downloadURL;
@property (nonatomic, strong) NSString *packageSize;
@property (nonatomic, strong) NSString *totalNum;
@property (nonatomic, strong) NSString *maxNum;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *coverPic;
@property (nonatomic, strong) NSString *releaseTime;

+ (instancetype)itemWithDict:(NSDictionary *)dict;
@end
