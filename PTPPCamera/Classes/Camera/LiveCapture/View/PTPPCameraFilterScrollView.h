//
//  PTPPCameraFilterScrollView.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 7/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FilterSelected)(NSInteger filterID, BOOL animated);
typedef void(^FinishBlock)(BOOL saveChange);
@interface PTPPCameraFilterScrollView : UIView
-(void)setAttributeWithFilterSet:(NSArray *)filterSet;
@property (nonatomic, assign) BOOL iconHightlightMode;
@property (nonatomic, assign) NSInteger activeFilterID;
@property (nonatomic, assign) NSInteger previousActiveFilterID;
@property (nonatomic, copy) FilterSelected filterSelected;
@property (nonatomic, copy) FinishBlock finishBlock;
-(void)confirm;
@end
