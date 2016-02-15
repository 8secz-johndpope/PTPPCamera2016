//
//  PTLiveStickerPickerCell.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 21/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTLiveStickerPickerCell.h"
#import "SOkit.h"
@interface PTLiveStickerPickerCell ()
@property (nonatomic, strong) UIImageView *stickerPreview;
@property (nonatomic, strong) UIImageView *tickIcon;
@end

@implementation PTLiveStickerPickerCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.stickerPreview];
        [self.contentView addSubview:self.tickIcon];
    }
    return self;
}

-(void)setAttributeWithImage:(UIImage *)image selected:(BOOL)selected{
    self.stickerPreview.image = image;
    self.tickIcon.hidden = !selected;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.tickIcon.frame = CGRectMake(self.width-self.tickIcon.width-10, self.height-self.tickIcon.height-10, self.tickIcon.width, self.tickIcon.height);
}

-(UIImageView *)stickerPreview{
    if (!_stickerPreview) {
        _stickerPreview = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _stickerPreview;
}

-(UIImageView *)tickIcon{
    if (!_tickIcon) {
        _tickIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _tickIcon.image = [UIImage imageNamed:@"btn_22_03"];
    }
    return _tickIcon;
}

@end
