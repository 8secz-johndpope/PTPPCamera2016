//
//  PTPPJigsawTemplateModel.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTPPJigsawTemplateModel : NSObject
@property (nonatomic, strong) UIImage *baseImage;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) NSArray <NSString *>*maskArray;
@end
