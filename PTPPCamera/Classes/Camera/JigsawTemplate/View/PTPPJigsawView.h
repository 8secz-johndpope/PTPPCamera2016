//
//  PTPPJigsawView.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 29/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTPPJigsawTemplateModel.h"
#import "PTPPJigsawTemplateViewController.h"
#import "PTPPJigsawViewPopup.h"

@interface PTPPJigsawView : UIView
@property (nonatomic, weak) PTPPJigsawTemplateViewController *originalVC;
@property (nonatomic, strong) PTPPJigsawViewPopup *popup;
-(void)setAttributeWithTemplateModel:(PTPPJigsawTemplateModel *)templateModel images:(NSArray *)images;
@end
