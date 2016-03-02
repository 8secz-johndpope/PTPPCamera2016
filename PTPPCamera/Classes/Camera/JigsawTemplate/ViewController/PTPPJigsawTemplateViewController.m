//
//  PTPPJigsawTemplateViewController.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPJigsawTemplateViewController.h"
#import "PTPPMediaShareViewController.h"
#import "PTPPMaterialShopViewController.h"
#import "PTPPLocalFileManager.h"
#import "PTPPStickerXMLParser.h"
#import "PTPPJigsawTemplateModel.h"
#import "PTPPJigsawView.h"

@interface PTPPJigsawTemplateViewController ()
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *canvasView;
@property (nonatomic, strong) UIImageView *jigsawTemplateView;
@property (nonatomic, strong) PTPPJigsawView *jigsawView;
@property (nonatomic, strong) PTPPJigsawTemplateModel *jigsawTemplateModel;
@property (nonatomic, strong) SOImageTextControl *swapTemplateControl;
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
    [self.view addSubview:self.canvasView];
    [self.canvasView addSubview:self.jigsawView];
    [self.canvasView addSubview:self.jigsawTemplateView];
    [self.view addSubview:self.swapTemplateControl];
    self.swapTemplateControl.center = CGPointMake(self.view.centerX, Screenheight-self.swapTemplateControl.height/2);
    [self readLocalFileSetting];
    [self updateFrame];
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
    CGFloat sizeRatio = self.jigsawTemplateModel.imageSize.height/self.jigsawTemplateModel.imageSize.width;
    self.canvasView.frame = CGRectMake(10, self.topBar.bottom+10, Screenwidth-20, (Screenwidth-20)*sizeRatio);
    self.jigsawTemplateView.frame = self.canvasView.bounds;
    self.jigsawTemplateView.image = self.jigsawTemplateModel.baseImage;
    self.jigsawView.frame = self.canvasView.bounds;
    [self.jigsawView setAttributeWithTemplateModel:self.jigsawTemplateModel images:self.images];
}


#pragma mark - Touch Events
-(void)saveAndExport{
    UIGraphicsBeginImageContextWithOptions(self.canvasView.bounds.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.canvasView.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(screenShot, nil, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"保存成功" duration:1.0];
    PTPPMediaShareViewController *mediaShareVC = [[PTPPMediaShareViewController alloc] initWithImage:screenShot];
    [self.navigationController pushViewController:mediaShareVC animated:YES];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toggleJigsawTemplate{
    self.jigsawView.popup.hidden = YES;
    __weak typeof(self) weakSelf = self;
    PTPPMaterialShopViewController *shopVC = [[PTPPMaterialShopViewController alloc] init];
    shopVC.activeSection = 2;
    shopVC.hideMenu = YES;
    shopVC.proceedToSwapTemplate = YES;
    shopVC.jigsawTemplateFilter = self.images.count;
    shopVC.templateSwap = ^(PTPPMaterialShopStickerItem *item){
        weakSelf.selectedJigsawItem = item;
        if ([weakSelf readLocalFileSetting]) {
            [weakSelf.jigsawView setAttributeWithTemplateModel:weakSelf.jigsawTemplateModel images:weakSelf.images];
        }
    };
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:shopVC];
    [self presentViewController:navi animated:YES completion:^{
        
    }];
}

#pragma mark - Private Methods
-(BOOL)readLocalFileSetting{
    NSString *jigsawFolder = [[PTPPLocalFileManager getRootFolderPathForJigsawTemplate] stringByAppendingPathComponent:[[PTPPLocalFileManager getFileNameFromPackageID:self.selectedJigsawItem.packageID inDownloadedList:[PTPPLocalFileManager getDownloadedJigsawTemplateList]] stringByDeletingPathExtension]];
    NSArray *fileContents = [PTPPLocalFileManager getListOfFilePathAtDirectory:jigsawFolder];
    NSString *xmlFilePath = nil;
    for(NSString *path in fileContents){
        if ([path.pathExtension isEqualToString:@"xml"]) {
            xmlFilePath = [path stringByDeletingPathExtension];
        }
    }
    if (!xmlFilePath) {
        NSLog(@"Cannot locate jigsaw template");
        [SVProgressHUD showErrorWithStatus:@"模板不存在" duration:1.0];
        return NO;
    }
    NSDictionary *resultDict = [PTPPStickerXMLParser dictionaryFromXMLFilePath:xmlFilePath];
    CGFloat width = [[[[resultDict safeObjectForKey:@"jigsaw"] safeObjectForKey:@"width"] safeStringForKey:@"text"] floatValue];
    CGFloat height = [[[[resultDict safeObjectForKey:@"jigsaw"] safeObjectForKey:@"height"] safeStringForKey:@"text"] floatValue];
    CGSize templateSize = CGSizeMake(width, height);
    NSDictionary *parsingDict = [[[resultDict safeObjectForKey:@"jigsaw"] safeObjectForKey:@"maskList"] safeObjectAtIndex:self.images.count-1];
    self.jigsawTemplateModel = [PTPPJigsawTemplateModel initWithDictionary:parsingDict templateSize:templateSize folderPath:jigsawFolder];
    return YES;
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

-(UIView *)canvasView{
    if (!_canvasView) {
        _canvasView = [[UIView alloc] init];
        _canvasView.backgroundColor = [UIColor clearColor];
    }
    return _canvasView;
}

-(UIImageView *)jigsawTemplateView{
    if (!_jigsawTemplateView) {
        _jigsawTemplateView = [[UIImageView alloc] init];
    }
    return _jigsawTemplateView;
}

-(PTPPJigsawView *)jigsawView{
    if (!_jigsawView) {
        _jigsawView = [[PTPPJigsawView alloc] init];
        _jigsawView.originalVC = self;
    }
    return _jigsawView;
}


-(SOImageTextControl *)swapTemplateControl{
    if (!_swapTemplateControl) {
        _swapTemplateControl = [[SOImageTextControl alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _swapTemplateControl.textLabel.text = @"更换模板";
        _swapTemplateControl.textLabel.font = [UIFont systemFontOfSize:14];
        _swapTemplateControl.textLabel.textColor = [UIColor whiteColor];
        _swapTemplateControl.imageView.image = [UIImage imageNamed:@"icon_capture_20_36"];
        _swapTemplateControl.imageSize = CGSizeMake(20, 20);
        _swapTemplateControl.imageAndTextSpace = 10;
        [_swapTemplateControl addTarget:self action:@selector(toggleJigsawTemplate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _swapTemplateControl;
}

@end
