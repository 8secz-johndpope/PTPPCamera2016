//
//  PTPPJigsawTemplateViewController.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 26/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPJigsawTemplateViewController.h"
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

}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods
-(void)readLocalFileSetting{
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
        return;
    }
    NSDictionary *resultDict = [PTPPStickerXMLParser dictionaryFromXMLFilePath:xmlFilePath];
    CGFloat width = [[[[resultDict safeObjectForKey:@"jigsaw"] safeObjectForKey:@"width"] safeStringForKey:@"text"] floatValue];
    CGFloat height = [[[[resultDict safeObjectForKey:@"jigsaw"] safeObjectForKey:@"height"] safeStringForKey:@"text"] floatValue];
    CGSize templateSize = CGSizeMake(width, height);
    NSDictionary *parsingDict = [[[resultDict safeObjectForKey:@"jigsaw"] safeObjectForKey:@"maskList"] safeObjectAtIndex:self.images.count-1];
    self.jigsawTemplateModel = [PTPPJigsawTemplateModel initWithDictionary:parsingDict templateSize:templateSize folderPath:jigsawFolder];
    
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
    }
    return _jigsawView;
}

@end
