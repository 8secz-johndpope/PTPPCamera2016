//
//  PTPPJigsawTemplateModel.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPJigsawTemplateModel.h"

@implementation PTPPJigsawTemplateModel
+(instancetype)initWithDictionary:(NSDictionary *)dictionary templateSize:(CGSize)templateSize folderPath:(NSString *)folderPath{
    PTPPJigsawTemplateModel *model = [[PTPPJigsawTemplateModel alloc] init];
    if (model) {
        model.imageSize = templateSize;
        NSString *imagePath = [folderPath stringByAppendingPathComponent:[[dictionary safeObjectForKey:@"imageName"] safeStringForKey:@"text"]];
        model.baseImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
        id maskData = [dictionary safeObjectForKey:@"mask"];
        if ([maskData isKindOfClass:[NSArray class]]) {
            NSArray *pointDictArray = maskData;
            model.maskPointArray = [[NSMutableArray alloc] init];
            for(NSDictionary *pointDict in pointDictArray){
                NSArray *pointArray = [pointDict safeObjectForKey:@"point"];
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                for(NSDictionary *coordinatesDict in pointArray){
                    NSString *coordinateString = [coordinatesDict safeStringForKey:@"text"];
                    [tempArray safeAddObject:coordinateString];
                   // NSLog(@"coord:%@",coordinateString);
                }
                [model.maskPointArray addObject:tempArray];
            }
        }else if ([maskData isKindOfClass:[NSDictionary class]]){
            model.maskPointArray = [[NSMutableArray alloc] init];
            NSArray *pointArray = [maskData safeObjectForKey:@"point"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for(NSDictionary *coordinatesDict in pointArray){
                NSString *coordinateString = [coordinatesDict safeStringForKey:@"text"];
                [tempArray safeAddObject:coordinateString];
                //NSLog(@"coord:%@",coordinateString);
            }
            [model.maskPointArray addObject:tempArray];
        }
    }
    return model;
}
@end
