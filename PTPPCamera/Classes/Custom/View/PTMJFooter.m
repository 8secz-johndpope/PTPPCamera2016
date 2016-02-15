//
//  MJDIYAutoFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "PTMJFooter.h"

@interface PTMJFooter()
@property (weak, nonatomic) UIImageView *pinwheelImageView;
@end

@implementation PTMJFooter


-(void)dealloc
{
    //取消所有的  performRequets
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 40;
    
     //添加风车
    UIImageView *imageAnimateView = [[UIImageView alloc] init];
    imageAnimateView.image = [UIImage imageNamed:@"ani_loading_bubble"];
    [self addSubview:imageAnimateView];
    
    self.pinwheelImageView = imageAnimateView;
    self.pinwheelImageView.hidden = YES;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
 
    self.pinwheelImageView.frame = self.bounds;
//    if (self.isRefreshingTitleHidden) {
//        self.pinwheelImageView.contentMode = UIViewContentModeCenter;
//    } else {
        self.pinwheelImageView.contentMode = UIViewContentModeRight;
        self.pinwheelImageView.mj_w = 22;
        self.pinwheelImageView.mj_x = Screenwidth/2 - 70;
//    }

}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    self.stateLabel.font = [UIFont systemFontOfSize:14];
    switch (state) {
        case MJRefreshStateIdle:
            self.stateLabel.text = @"上拉加载更多";
            [self stopAnimation];
             break;
        case MJRefreshStateRefreshing:
             self.stateLabel.text = @"正在加载";
            [self  startAnimation];
            break;
        case MJRefreshStateNoMoreData:
            self.stateLabel.text = @"没有更多";
            [self stopAnimation];
            break;
        default:
            break;
    }
}

-(void)endRefreshing
{
    [super endRefreshing];
    [self stopAnimation];
}

#pragma mark 动画

-(void)startAnimation
{
    self.pinwheelImageView.hidden = NO;

    CABasicAnimation* RotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    RotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    RotateAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    RotateAnimation.duration = 0.6;
    RotateAnimation.autoreverses = NO;
    RotateAnimation.removedOnCompletion = YES;
    RotateAnimation.fillMode = kCAFillModeForwards;
    [self.pinwheelImageView.layer addAnimation:RotateAnimation forKey:@"RotateAnimation"];
    
    //做循环，动画
    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.6];
}

-(void)stopAnimation
{
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimation) object:nil];
    [self.pinwheelImageView.layer removeAllAnimations];
    self.pinwheelImageView.hidden = YES;
//    self.pinwheelImageView.hidden = YES;  //隐藏icon
}

@end
