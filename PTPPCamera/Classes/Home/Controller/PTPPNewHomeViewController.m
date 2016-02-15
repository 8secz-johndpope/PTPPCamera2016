//
//  PTPPNewHomeViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 12/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//
#import "SOKit.h"
#import "PTPPNewHomeViewController.h"
#import "PTPPLiveCameraViewController.h"

#import "PTAvatarView.h"
#import "PTMacro.h"
#import "PTPPHomeDashboardView.h"
@interface PTPPNewHomeViewController ()<PTPPHomeDashboardViewDelegate>
@property (nonatomic, strong) UIImageView *fullBgImageView;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) PTAvatarView *avatarView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) PTPPHomeDashboardView *dashboard;
@end

@interface PTPPNewHomeViewController ()

@end

@implementation PTPPNewHomeViewController

#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.fullBgImageView];
    [self.view addSubview:self.cameraButton];
    [self.view addSubview:self.titleImageView];
//    [self.view addSubview:self.avatarView];
//    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.dashboard];
    [self.dashboard setAttributeWithItems:@[[[NSDictionary alloc] initWithObjectsAndKeys:@"img_index_01",kIcon,@"素材中心",kTitle, nil],
                                            [[NSDictionary alloc] initWithObjectsAndKeys:@"img_index_05",kIcon,@"葡萄官网",kTitle, nil],
                                            [[NSDictionary alloc] initWithObjectsAndKeys:@"img_index_03",kIcon,@"意见反馈",kTitle, nil],
                                            [[NSDictionary alloc] initWithObjectsAndKeys:@"img_index_04",kIcon,@"关于我们",kTitle, nil]]];
    [self layoutDashboard];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xffffff)];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutDashboard{
    self.dashboard.center = self.view.center;
    self.cameraButton.frame = CGRectMake(Screenwidth-20-self.cameraButton.width, 20, self.cameraButton.width, self.cameraButton.height);
    self.titleImageView.frame = CGRectMake(self.dashboard.left+20, self.cameraButton.bottom+10, self.dashboard.width-40, self.dashboard.top-self.cameraButton.bottom-20);
    self.avatarView.frame = CGRectMake(20, Screenheight-20-self.avatarView.height, self.avatarView.width, self.avatarView.height);
    self.userNameLabel.frame = CGRectMake(self.avatarView.right+10, self.avatarView.top, self.userNameLabel.width, self.avatarView.height);
    //[self animatedDashboard];
}

-(void)animatedDashboard{
    NSInteger index = 0;
    for(PTPPHomeItemView *view in self.dashboard.menuItems){
        view.iconView.transform = CGAffineTransformMakeScale(2.0, 2.0);
        view.iconView.alpha = 0.0;
        view.titleLabel.transform = CGAffineTransformMakeScale(0.1, 0.1);
        view.titleLabel.alpha = 0.0;
        [UIView animateWithDuration:1.5 delay:index*0.1 usingSpringWithDamping:0.5
              initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                  view.iconView.transform = CGAffineTransformIdentity;
                  view.iconView.alpha = 1.0;
                  view.titleLabel.transform = CGAffineTransformMakeScale(1.0,1.0);
                  view.titleLabel.alpha = 1.0;
              } completion:^(BOOL finished) {
                 
              }];
        index++;
    }
    self.titleImageView.alpha = 0.0;
    self.cameraButton.alpha = 0.0;
    self.avatarView.alpha = 0.0;
    self.userNameLabel.alpha = 0.0;
    self.titleImageView.center = CGPointMake(self.titleImageView.centerX, self.titleImageView.centerY-100);
    self.cameraButton.center = CGPointMake(self.cameraButton.centerX, self.cameraButton.centerY-100);
    self.avatarView.center = CGPointMake(self.avatarView.centerX, self.avatarView.centerY+100);
    self.userNameLabel.center = CGPointMake(self.userNameLabel.centerX, self.userNameLabel.centerY+100);
    self.dashboard.transform = CGAffineTransformMakeScale(4.0, 4.0);
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.8
          initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
              self.dashboard.transform = CGAffineTransformMakeScale(1.0, 1.0);
          } completion:^(BOOL finished) {
              
              [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.8
                    initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                        self.titleImageView.center = CGPointMake(self.titleImageView.centerX, self.titleImageView.centerY+100);
                        self.titleImageView.alpha = 1.0;
                    } completion:^(BOOL finished) {
                    }];
              [UIView animateWithDuration:1.0 delay:0.2 usingSpringWithDamping:0.8
                    initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                        self.cameraButton.center = CGPointMake(self.cameraButton.centerX, self.cameraButton.centerY+100);
                        self.cameraButton.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        
                    }];
              [UIView animateWithDuration:1.0 delay:0.2 usingSpringWithDamping:0.8
                    initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn  animations:^(){
                        self.avatarView.center = CGPointMake(self.avatarView.centerX, self.avatarView.centerY-100);
                        self.userNameLabel.center = CGPointMake(self.userNameLabel.centerX, self.userNameLabel.centerY-100);
                        self.avatarView.alpha = 1.0;
                        self.userNameLabel.alpha =1.0;
                    } completion:^(BOOL finished) {
                        
                    }];

          }];
    
    }

#pragma mark - Touch events
-(void) openCamera{
//    PTPPLiveCameraViewController *cameraVC = [[PTPPLiveCameraViewController alloc] init];
//    [self.navigationController pushViewController:cameraVC animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(resumeFaceDetector)]) {
        [self.delegate resumeFaceDetector];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)toRecommededApp{
//    NSString *customURL = @"ptapp://";
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customURL]]) {
//        //App installed, Go to app
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
//    }else{
//        //App not installed, go to AppStore
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/pu-tao-shi-guang-bao-bao-cheng/id987826034?l=en&mt=8"]];
//    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.putao.com/"]];
}

- (void)toMaterialCenter{

}

-(void)toFeedBack{

}

-(void)toAboutUs{

}

#pragma mark - PTPPHomeDashboardViewDelegate
-(void)didTapMenuItemAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            [self toMaterialCenter];
            break;
        case 1:
            [self toRecommededApp];
            break;
        case 2:
            [self toFeedBack];
            break;
        case 3:
            [self toAboutUs];
            break;
        default:
            break;
    }
}

#pragma mark - getters/setters
-(UIImageView *)fullBgImageView{
    if (!_fullBgImageView) {
        _fullBgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _fullBgImageView.image = [UIImage imageNamed:@"img_index_bg_736h@3x.jpg"];
    }
    return _fullBgImageView;
}

-(UIButton *)cameraButton{
    if (!_cameraButton) {
        _cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 72, 32)];
        [_cameraButton setImage:[UIImage imageNamed:@"btn_to_capture_nor"] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

-(UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _titleImageView.image = [UIImage imageNamed:@"img_index_logo"];
        _titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _titleImageView;
}

-(PTAvatarView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[PTAvatarView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_avatarView setAttrbutesWithHeadURL:nil placeHolder:@"img_head_signup"];
    }
    return _avatarView;
}

-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, 20)];
        _userNameLabel.text = @"这里显示用户名";
        _userNameLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    }
    return _userNameLabel;
}

-(PTPPHomeDashboardView *)dashboard{
    if (!_dashboard) {
        _dashboard = [[PTPPHomeDashboardView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth-90,  Screenwidth-60)];
        _dashboard.delegate = self;
    }
    return _dashboard;
}

@end
