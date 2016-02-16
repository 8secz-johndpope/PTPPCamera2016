//
//  PTPPStaticImageEditToolBar.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 16/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPStaticImageEditToolBar.h"

@implementation PTPPStaticImageEditToolBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

-(void)setAttributeWithControlSettings:(NSArray *)controlSettings{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i=0; i<controlSettings.count; i++) {
        NSDictionary *controlsetting = [controlSettings safeObjectAtIndex:i];
        NSString *settingName = [controlsetting safeObjectForKey:kEditImageControlNameKey];
        NSString *settingIcon = [controlsetting safeObjectForKey:kEditImageControlIconKey];
        SOImageTextControl *control = [[SOImageTextControl alloc] initWithFrame:CGRectMake(i*(self.width/controlSettings.count), 0, self.width/controlSettings.count, self.height)];
        control.textLabel.text = settingName;
        control.textLabel.textColor = [UIColor whiteColor];
        control.imageView.image = [UIImage imageNamed:settingIcon];
        control.imageSize = CGSizeMake(20, 20);
        if (settingName.length >0) {
            control.imageAndTextSpace = 5;
        }else{
            control.imageAndTextSpace = -1;
            control.contentView.backgroundColor = THEME_COLOR;
            control.frame = CGRectMake(control.left+10, control.top, control.width-20, control.height);
        }
        [self addSubview:control];
    }
}

@end
