//
//  PTPPStickerAnimation.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 19/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PTPPStickerAnimation : NSObject
@property (nonatomic, strong) NSString *faceFeature;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, strong) NSArray *imageList;
+(instancetype)animationWithDictionarySettings:(NSDictionary *)dictionary feature:(NSString *)feature filePath:(NSString *)filePath;
@end
