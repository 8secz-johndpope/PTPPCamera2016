//
//  PTLoadingViewCell.m
//  PTLatitude
//
//  Created by CHEN KAIDI on 1/12/2015.
//  Copyright © 2015 PT. All rights reserved.
//

#import "PTLoadingViewCell.h"

@interface PTLoadingViewCell ()
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@end

@implementation PTLoadingViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        [self.contentView addSubview:self.loadingView];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.loadingView.center = self.contentView.center;
    [self.loadingView startAnimating];
}

-(UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _loadingView;
}

@end
