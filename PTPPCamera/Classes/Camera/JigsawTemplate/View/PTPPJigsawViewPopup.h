//
//  PTPPJigsawViewPopup.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 1/3/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^JigsawToolButton)(NSInteger index);
@interface PTPPJigsawViewPopup : UIView
@property (nonatomic, copy) JigsawToolButton toolSelected;

@end
