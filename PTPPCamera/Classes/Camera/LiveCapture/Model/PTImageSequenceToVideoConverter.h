//
//  PTImageSequenceToVideoConverter.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 21/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPPLiveStickerPreviewViewController.h"
#import <UIKit/UIKit.h>
typedef void(^FinishExport)(NSURL *videoURL);

@interface PTImageSequenceToVideoConverter : NSObject
@property (nonatomic, copy) FinishExport finishExport;
-(void)exportVideoWithImageSequence:(PTPPLiveStickerPreviewViewController *)baseVC exportSize:(CGSize)exportSize fps:(NSUInteger)fps totalFrame:(NSInteger)totalFrame;
@end
