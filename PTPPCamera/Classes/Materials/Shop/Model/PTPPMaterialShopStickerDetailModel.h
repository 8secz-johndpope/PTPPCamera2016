//
//  PTPPMaterialShopStickerDetailModel.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 24/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "SOHTTPPageRequestModel.h"

@interface PTPPMaterialShopStickerDetailModel : SOHTTPRequestModel
@property (nonatomic, strong) NSString *materialType;
@property (nonatomic, strong) NSString *packageID;
+ (instancetype)shareModel;
@end
