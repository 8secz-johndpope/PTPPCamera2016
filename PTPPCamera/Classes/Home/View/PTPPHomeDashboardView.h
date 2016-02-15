//
//  PTPPHomeDashboardView.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 12/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPPHomeItemView.h"
@class PTPPHomeDashboardView;

@protocol PTPPHomeDashboardViewDelegate <NSObject>

-(void)didTapMenuItemAtIndex:(NSInteger)index;

@end

@interface PTPPHomeDashboardView : UIView
@property (nonatomic, assign) id<PTPPHomeDashboardViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray <PTPPHomeItemView *>*menuItems;
-(void)setAttributeWithItems:(NSArray *)item;
@end
