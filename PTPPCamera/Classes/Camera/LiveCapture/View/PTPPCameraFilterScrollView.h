//
//  PTPPCameraFilterScrollView.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 7/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FilterSelected)(NSInteger filterID);
typedef void(^FinishBlock)();
@interface PTPPCameraFilterScrollView : UIView
-(void)setAttributeWithFilterSet:(NSArray *)filterSet;
@property (nonatomic, assign) BOOL iconHightlightMode;
@property (nonatomic, assign) NSInteger activeFilterID;
@property (nonatomic, copy) FilterSelected filterSelected;
@property (nonatomic, copy) FinishBlock finishBlock;
@end
