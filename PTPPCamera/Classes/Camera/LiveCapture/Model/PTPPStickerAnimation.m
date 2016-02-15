
//
//  PTPPStickerAnimation.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 19/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPStickerAnimation.h"
#import "NSObject+Swizzle.h"
@implementation PTPPStickerAnimation
+(instancetype)animationWithDictionarySettings:(NSDictionary *)dictionary feature:(NSString *)feature filePath:(NSString *)filePath{
    PTPPStickerAnimation *animation = [[PTPPStickerAnimation alloc] init];
    if (animation) {
        animation.faceFeature = feature;
        animation.width = [[[dictionary safeObjectForKey:@"width"] safeObjectForKey:@"text"]floatValue];
        animation.height = [[[dictionary safeObjectForKey:@"height"] safeObjectForKey:@"text"] floatValue];
        animation.centerX = [[[dictionary safeObjectForKey:@"centerX"] safeObjectForKey:@"text"] floatValue];
        animation.centerY = [[[dictionary safeObjectForKey:@"centerY"] safeObjectForKey:@"text"] floatValue];
        animation.distance = [[[dictionary safeObjectForKey:@"distance"] safeObjectForKey:@"text"] floatValue];
        animation.duration = [[[dictionary safeObjectForKey:@"duration"] safeObjectForKey:@"text"] floatValue];
        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        NSArray *dictArray = [[dictionary safeObjectForKey:@"imageList"] safeObjectForKey:@"imageName"];
        BOOL fromDisk = filePath.length != 0;
        for(NSDictionary *tempDict in dictArray){
            NSString *imageFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",[tempDict safeObjectForKey:@"text"]]];
            UIImage *image = nil;
            if (fromDisk) {
                image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageFilePath]];
            }else{
                image = [UIImage imageNamed:[tempDict safeObjectForKey:@"text"]];
            }
            if (image) {
                [imageArray addObject:image];
            }else{
                NSLog(@"Image reading error :%@ - %@",feature,[tempDict safeObjectForKey:@"text"]);
            }
        }
        animation.imageList = [[NSArray alloc] initWithArray:imageArray];
    }
    return animation;
}
@end
