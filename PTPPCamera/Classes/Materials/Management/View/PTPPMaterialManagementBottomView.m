//
//  PTPPMaterialManagementBottomView.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 15/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialManagementBottomView.h"
#import "SOKit.h"
@interface PTPPMaterialManagementBottomView ()
@property (nonatomic, strong) UIButton *selectAllButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *splitterView;
@end

@implementation PTPPMaterialManagementBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.selectAllButton];
        [self addSubview:self.deleteButton];
        [self addSubview:self.splitterView];
        [self setNeedsLayout];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.splitterView.center = CGPointMake(self.width/2, self.height/2);
}

-(void)toggleSelectAll{
    if (self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(didToggleSelectAll:)]) {
        [self.viewDelegate didToggleSelectAll:self];
    }
}

-(void)toggleDelete{
    if (self.viewDelegate && [self.viewDelegate respondsToSelector:@selector(didToggleDelete:)]) {
        [self.viewDelegate didToggleDelete:self];
    }
}

-(UIButton *)selectAllButton{
    if (!_selectAllButton) {
        _selectAllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width/2, self.height)];
        [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [_selectAllButton addTarget:self action:@selector(toggleSelectAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAllButton;
}

-(UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2, 0, self.width/2, self.height)];
        [_deleteButton setTitle:@"删除所选" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:UIColorFromRGB(0xff5a5d) forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(toggleDelete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

-(UIView *)splitterView{
    if (!_splitterView) {
        _splitterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.height-20)];
        _splitterView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }
    return _splitterView;
}

@end
