//
//  PTPPMaterialManagementBottomView.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 15/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTPPMaterialManagementBottomView;

@protocol PTPPMaterialManagementBottomViewDelegate <NSObject>

-(void)didToggleSelectAll:(PTPPMaterialManagementBottomView *)bottomView;
-(void)didToggleDelete:(PTPPMaterialManagementBottomView *)bottomView;

@end

@interface PTPPMaterialManagementBottomView : UIToolbar
@property (nonatomic, assign) id<PTPPMaterialManagementBottomViewDelegate>viewDelegate;

@end
