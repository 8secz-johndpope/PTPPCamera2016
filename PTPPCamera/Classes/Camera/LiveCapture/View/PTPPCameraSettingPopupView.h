//
//  PTPPCameraSettingPopupView.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 8/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PTPPCameraSettingPopupView;
typedef void(^CameraSettingFinishBlock)(PTPPCameraSettingPopupView *popupView, NSInteger selectedID);
@interface PTPPCameraSettingPopupView : UIView
-(void)setAttributeWithButtonImages:(NSArray *)buttonImages;
@property (nonatomic, copy) CameraSettingFinishBlock finishBlock;
@property (nonatomic, strong) NSString *kSettingCategory;
@property (nonatomic, strong) NSString *kOption;
@end
