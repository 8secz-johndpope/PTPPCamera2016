//
//  PTPPJigsawView.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 29/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPPJigsawTemplateModel.h"

@interface PTPPJigsawView : UIView
-(void)setAttributeWithTemplateModel:(PTPPJigsawTemplateModel *)templateModel images:(NSArray *)images;
@end
