//
//  PTPPMaterialShopStickerModel.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 24/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "SOHTTPPageRequestModel.h"

@interface PTPPMaterialShopStaticStickerModel : SOHTTPPageRequestModel
@property (nonatomic, strong) NSString *materialType;
+ (instancetype)shareModel;
@end
