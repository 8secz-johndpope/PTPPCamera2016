//
//  PTMaterialShopLoadingCell.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 25/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTMaterialShopLoadingCell.h"

@interface PTMaterialShopLoadingCell ()

@end

@implementation PTMaterialShopLoadingCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.loadingView];
    }
    return self;
}

-(void)startAnimating{
    [self.loadingView startAnimating];
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.loadingView.center = CGPointMake(self.width/2, self.height/2);
}

-(UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _loadingView;
}

@end
