//
//  PTPPMaterialShopViewController.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "SOBaseViewController.h"
#import "PTPPMaterialShopStickerItem.h"
#import "AssetHelper.h"
typedef void(^TemplateSwap)(PTPPMaterialShopStickerItem *item);
@interface PTPPMaterialShopViewController : SOBaseViewController
@property (nonatomic, assign) BOOL hideMenu;
@property (nonatomic, assign) BOOL proceedToImageEdit;
@property (nonatomic, assign) BOOL proceedToSwapTemplate;
@property (nonatomic, assign) NSInteger jigsawTemplateFilter;   //Max number of template masks
@property (nonatomic, assign) NSInteger activeSection;
@property (nonatomic, copy) TemplateSwap templateSwap;
@end
