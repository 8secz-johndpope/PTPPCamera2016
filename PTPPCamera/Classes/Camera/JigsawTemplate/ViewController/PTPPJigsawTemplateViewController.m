//
//  PTPPJigsawTemplateViewController.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPJigsawTemplateViewController.h"
#import "PTPPLocalFileManager.h"

@interface PTPPJigsawTemplateViewController ()
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;
@end

@implementation PTPPJigsawTemplateViewController

#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:@"img_blur_bg_736h@3x.jpg"];
    [self.view addSubview:bgView];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.topBar];
    [self.topBar addSubview:self.backButton];
    [self.topBar addSubview:self.saveButton];
    [self updateFrame];
    [self readLocalFileSetting];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateFrame{
    self.topBar.frame = CGRectMake(0, 0, Screenwidth, HEIGHT_NAV);
    self.backButton.frame = CGRectMake(10, 0, 30, 40);
    self.saveButton.frame = CGRectMake(Screenwidth-100, 0, 100, HEIGHT_NAV);
}


#pragma mark - Touch Events
-(void)saveAndExport{

}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods
-(void)readLocalFileSetting{
    NSArray *folderList = [PTPPLocalFileManager getListOfFilePathAtDirectory:[PTPPLocalFileManager getRootFolderPathForJigsawTemplate]];
    NSArray *fileContents = [PTPPLocalFileManager getListOfFilePathAtDirectory:[folderList safeObjectAtIndex:0]];
    
}

#pragma mark - Getters/Setters

-(UIView *)topBar{
    if (!_topBar) {
        _topBar = [[UIView alloc] init];
        _topBar.backgroundColor = [UIColor clearColor];
    }
    return _topBar;
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
