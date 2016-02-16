//
//  PTPPStaticImageEditViewController.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 16/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPStaticImageEditViewController.h"
#import "PTPPStaticImageEditToolBar.h"

@interface PTPPStaticImageEditViewController ()
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) PTPPStaticImageEditToolBar *toolBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *canvasView;
@property (nonatomic, strong) UIImageView *basePhotoView;
@property (nonatomic, strong) UIImage *basePhoto;
@end

@implementation PTPPStaticImageEditViewController

#pragma mark - Life Cycles
-(instancetype)initWithBasePhoto:(UIImage *)basePhoto{
    self = [super init];
    if (self) {
        self.basePhoto = basePhoto;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    [self.view addSubview:self.canvasView];
    [self.canvasView addSubview:self.basePhotoView];
    self.basePhotoView.image = self.basePhoto;
    [self.view addSubview:self.topBar];
    [self.view addSubview:self.toolBar];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.saveButton];
    
    NSMutableArray *settingArray = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<5; i++) {
        NSString *name = @"";
        NSString *icon = @"";
        switch (i) {
            case 0:
                name = @"贴纸";
                icon = @"icon_capture_20_18";
                break;
            case 1:
                name = @"滤镜";
                icon = @"icon_capture_20_16";
                break;
            case 2:
                name = @"";
                icon = @"icon_capture_20_15";
                break;
            case 3:
                name = @"裁剪";
                icon = @"icon_capture_20_19";
                break;
            case 4:
                name = @"旋转";
                icon = @"icon_capture_20_31";
                break;
            default:
                break;
        }
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:icon,kEditImageControlIconKey,name,kEditImageControlNameKey, nil];
        [settingArray safeAddObject:dict];
    }
    [self.toolBar setAttributeWithControlSettings:settingArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.topBar.frame = CGRectMake(0, 0, Screenwidth, HEIGHT_NAV);
    self.backButton.frame = CGRectMake(10, 0, 30, 40);
    self.saveButton.frame = CGRectMake(Screenwidth-100, 0, 100, HEIGHT_NAV);
}

#pragma mark - Touch Events
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAndExport{
    
}

#pragma mark - Getters/Setters
-(UIView *)canvasView{
    if (!_canvasView) {
        _canvasView = [[UIView alloc] initWithFrame:self.view.frame];
    }
    return _canvasView;
}

-(UIImageView *)basePhotoView{
    if (!_basePhotoView) {
        _basePhotoView = [[UIImageView alloc] initWithFrame:self.canvasView.frame];
        _basePhotoView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _basePhotoView;
}

-(UIView *)topBar{
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _topBar;
}

-(PTPPStaticImageEditToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[PTPPStaticImageEditToolBar alloc] initWithFrame:CGRectMake(0, Screenheight-HEIGHT_NAV, Screenwidth, HEIGHT_NAV)];
    }
    return _toolBar;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"back_white.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        [_saveButton setTitle:@"保存/分享" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveAndExport) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

@end
