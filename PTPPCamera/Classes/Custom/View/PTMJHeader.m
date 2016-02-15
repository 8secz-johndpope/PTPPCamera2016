//
//  MJDIYHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "PTMJHeader.h"

@interface PTMJHeader()

@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *robotImageView;
@property (weak, nonatomic) UIImageView *pinwheelImageView;

@end

@implementation PTMJHeader

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
    self.backgroundColor = UIColorFromRGB(0xebebeb);
    // 设置控件的高度
    self.mj_h = 112;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    self.label = label;
    
    //添加背景
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"ani_loading_refresh_bg"];
    [self addSubview:imageView];
    
    self.robotImageView = imageView;
    
    //添加摩天轮
    UIImageView *imageAnimateView = [[UIImageView alloc] init];
    imageAnimateView.image = [UIImage imageNamed:@"ani_loading_screw"];
    [self addSubview:imageAnimateView];
    
    self.pinwheelImageView = imageAnimateView;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];

    CGRect tempFrame = self.bounds;
    tempFrame.size.height = 40;
    tempFrame.origin = CGPointZero;
    self.label.frame = tempFrame;
    
    tempFrame.size = CGSizeMake(240, 60);
    tempFrame.origin.x = (self.mj_w - tempFrame.size.width)/2.0;
    tempFrame.origin.y = 52;
    self.robotImageView.frame = tempFrame;
    
    tempFrame.size = CGSizeMake(68, 68);
    tempFrame.origin.x += 85;
    tempFrame.origin.y -= 20.5;
    self.pinwheelImageView.frame = tempFrame;
    
    self.clipsToBounds = YES;
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
    
    self.label.textColor = [UIColor colorWithHexString:@"B5B5B5"];
    self.label.font = [UIFont systemFontOfSize:14.0f];
    switch (state) {
        case MJRefreshStateIdle:
             self.label.text = @"下拉刷新";
            [self stopAnimate];

            break;
        case MJRefreshStatePulling:
             self.label.text = @"松开手以刷新页面";
            
            break;
        case MJRefreshStateRefreshing:
             self.label.text = @"加载数据中...";
            [self startAnimation];
             break;
        default:
            break;
    }
}


 

-(void)startAnimation
{
    CABasicAnimation* RotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    RotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    RotateAnimation.toValue = [NSNumber numberWithFloat:2*M_PI]; //-2*M_PI 逆时针方向
    RotateAnimation.duration = 1.6;   //0.6
    RotateAnimation.autoreverses = NO;
    RotateAnimation.removedOnCompletion = YES;
    RotateAnimation.fillMode = kCAFillModeForwards;
    [self.pinwheelImageView.layer addAnimation:RotateAnimation forKey:@"RotateAnimation"];
    
    //做循环，动画
    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.6];
}

-(void)stopAnimate
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimation) object:nil];
    [self.pinwheelImageView.layer removeAllAnimations];
}

//#pragma mark 监听拖拽比例（控件被拖出来的比例）
//- (void)setPullingPercent:(CGFloat)pullingPercent
//{
//    [super setPullingPercent:pullingPercent];
//    
//    // 1.0 0.5 0.0
//    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//}

@end
