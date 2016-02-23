//
//  PTPPMaterialStickerDetailCell.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 15/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialStickerDetailCell.h"
#import "SOKit.h"
#import "UIImageView+WebCache.h"
@interface PTPPMaterialStickerDetailCell ()
@property (nonatomic, strong) UIImageView *stickerView;
@end

@implementation PTPPMaterialStickerDetailCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.stickerView];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 4;
    }
    return self;
}

-(void)setAttributeWithImageURL:(NSString *)imageURL{
    __weak typeof(self) weakSelf = self;
    [self.stickerView sd_setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            weakSelf.stickerView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
}

-(UIImageView *)stickerView{
    if (!_stickerView) {
        _stickerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _stickerView.contentMode = UIViewContentModeCenter;
        _stickerView.clipsToBounds = YES;
    }
    return _stickerView;
}

@end
