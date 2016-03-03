//
//  PTPPMaterialShopViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "UIScrollView+EmptyDataSet.h"
#import "ELCImagePickerHeader.h"
#import "PTPPLocalFileManager.h"
#import "PTPPMaterialShopViewController.h"
#import "PTPPMaterialManagementListViewController.h"
#import "PTPPMaterialStickerDetailViewController.h"
#import "PTPPJigsawTemplateViewController.h"
#import "PTMaterialShopLoadingCell.h"
#import "PTPPMaterialShopStickerItemCell.h"
#import "PTPPMaterialShopARStickerItemCell.h"
#import "PTPPMaterialShopJigsawItemCell.h"
#import "PTCustomMenuSliderView.h"
#import "PTPPMaterialManagementBottomView.h"
#import "PTPPMaterialShopStaticStickerModel.h"
#import "PTPPMaterialShopARStickerModel.h"
#import "PTPPMaterialShopJigsawTemplateModel.h"
#import "DownloadManager.h"
#import "PTPPStickerXMLParser.h"
#import "AssetHelper.h"

#define kCollectionViewEdgePadding 10
#define kCellSpacing 5

@interface PTPPMaterialShopViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PTCustomMenuSliderViewDelegate, SOModelDelegate,ELCImagePickerControllerDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) PTCustomMenuSliderView *sliderView;
@property (nonatomic, strong) PTPPMaterialManagementBottomView *bottomView;

@property (nonatomic, strong) PTPPMaterialShopStickerItem *staticStickerItem;
@property (nonatomic, strong) PTPPMaterialShopStaticStickerModel *staticStickerModel;
@property (nonatomic, strong) NSMutableArray <PTPPMaterialShopStickerItem*>*staticStickerArray;
@property (nonatomic, strong) PTPPMaterialShopStickerItem *ARStickerItem;
@property (nonatomic, strong) PTPPMaterialShopARStickerModel *ARStickerModel;
@property (nonatomic, strong) NSMutableArray <PTPPMaterialShopStickerItem*>*ARStickerArray;
@property (nonatomic, strong) PTPPMaterialShopStickerItem *jigsawTemplateItem;
@property (nonatomic, strong) PTPPMaterialShopJigsawTemplateModel *jigsawTemplateModel;
@property (nonatomic, strong) NSMutableArray <PTPPMaterialShopStickerItem*>*jigsawTemplateArray;

@property (nonatomic, strong) PTPPMaterialShopStickerItem *selectedJigsawItem;
@property (nonatomic, copy) NSArray *chosenImages;
@property (nonatomic, assign) BOOL loadingStaticSticker;
@property (nonatomic, assign) BOOL loadingARSticker;
@property (nonatomic, assign) BOOL loadingJigsawTemplate;
@property (nonatomic, assign) BOOL staticStickerDataFinished;
@property (nonatomic, assign) BOOL ARStickerDataFinished;
@property (nonatomic, assign) BOOL jigsawTemplateDataFinished;
@property (nonatomic, assign) BOOL selectionMode;
@end

static NSString *PTPPMaterialShopStickerItemCellID = @"PTPPMaterialShopStickerItemCellID";
static NSString *PTPPMaterialShoptARStickerItemCellID = @"PTPPMaterialShoptARStickerItemCellID";
static NSString *PTPPMaterialShopJigsawItemCellID = @"PTPPMaterialShopJigsawItemCellID";
static NSString *PTPPMaterialShopLoadingCellID = @"PTPPMaterialShopLoadingCellID";
@implementation PTPPMaterialShopViewController

#pragma mark - Life Cycles
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _staticStickerModel = [PTPPMaterialShopStaticStickerModel shareModel];
        [_staticStickerModel setDelegate:self];
        _staticStickerArray = [[NSMutableArray alloc] init];
        
        _ARStickerModel = [PTPPMaterialShopARStickerModel shareModel];
        [_ARStickerModel setDelegate:self];
        _ARStickerArray = [[NSMutableArray alloc] init];
        
        _jigsawTemplateModel= [PTPPMaterialShopJigsawTemplateModel shareModel];
        [_jigsawTemplateModel setDelegate:self];
        _jigsawTemplateArray = [[NSMutableArray alloc] init];
    }
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self disableAdjustsScrollView];
    [self cleanEdgesForExtendedLayout];

    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xff5a5d)];
    if (self.proceedToImageEdit) {
        [self setTitle:@"选择模板" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] selector:nil];
    }else{
        if (self.proceedToSwapTemplate) {
            [self setTitle:@"选择模板" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] selector:nil];
            [self showRightItemWithText:@"返回" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] selector:@selector(dismissMe) animation:NO];
        }else{
            [self setTitle:@"素材中心" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] selector:nil];
            [self showRightItemWithText:@"素材管理" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] selector:@selector(toggleMaterialManagement) animation:NO];
        }
    }
    if (!self.proceedToSwapTemplate) {
        [self showLeftItemWithImage:[UIImage imageNamed:@"back_white"] selector:@selector(goBack) animation:YES];
    }
    
    if (!self.hideMenu) {
        [self.sliderView setAttributeWithItems:@[@"贴纸",@"动态贴图",@"拼图模版"] buttonWidth:Screenwidth/3 themeColor:UIColorFromRGB(0xff5a5d) idleColor:[UIColor grayColor] trackerWidth:20];
        [self.view addSubview:self.sliderView];
        self.collectionView.frame = CGRectMake(0, self.sliderView.bottom, self.collectionView.width, self.collectionView.height);
    }else{
        self.collectionView.frame = CGRectMake(0, 0, self.collectionView.width, Screenheight-HEIGHT_NAV);
    }
    
    [self.view addSubview:self.collectionView];
    [self sliderView:self.sliderView didSelecteAtIndex:self.activeSection];
    [self.sliderView scrollToIndexWithActiveSection:self.activeSection];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidFinishLoading:) name:kDownloadDidFinishLoading object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidReceiveData:) name:kDownloadDidReceiveData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidFail:) name:kDownloadDidFail object:nil];
    [self.collectionView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadDidFinishLoading object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadDidFail object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDownloadDidReceiveData object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSNotifications
- (void)downloadDidFinishLoading:(NSNotification *)notification{
    NSLog(@"download complete");
    Download *download = notification.object;
    NSString *desPath = nil;
    switch (self.activeSection) {
        case 0:
            desPath = [PTPPLocalFileManager getRootFolderPathForStaitcStickers] ;
            [PTPPLocalFileManager unzipFileFromPath:download.filename desPath:[desPath stringByAppendingPathComponent:[[download.filename lastPathComponent] stringByDeletingPathExtension]]];
            [PTPPLocalFileManager writePropertyListTo:StaticStickerPlistFile WithPackageID:download.package.packageID fileName:[download.filename lastPathComponent] themeName:download.package.packageName fileSize:download.package.packageSize totalNum:download.package.totalNum coverPic:download.package.coverPic];
            break;
        case 1:
            desPath = [PTPPLocalFileManager getRootFolderPathForARStickers] ;
            [PTPPLocalFileManager unzipFileFromPath:download.filename desPath:[desPath stringByAppendingPathComponent:[[download.filename lastPathComponent] stringByDeletingPathExtension]]];
            [PTPPLocalFileManager writePropertyListTo:ARStickerPlistFile WithPackageID:download.package.packageID fileName:[download.filename lastPathComponent] themeName:download.package.packageName fileSize:download.package.packageSize totalNum:download.package.totalNum coverPic:download.package.coverPic];
            break;
        case 2:
            desPath = [PTPPLocalFileManager getRootFolderPathForJigsawTemplate] ;
            [PTPPLocalFileManager unzipFileFromPath:download.filename desPath:[desPath stringByAppendingPathComponent:[[download.filename lastPathComponent] stringByDeletingPathExtension]]];
            [PTPPLocalFileManager writePropertyListTo:JigsawTemplatePlistFile WithPackageID:download.package.packageID fileName:[download.filename lastPathComponent] themeName:download.package.packageName fileSize:download.package.packageSize totalNum:download.package.totalNum coverPic:download.package.coverPic];
            break;
            
        default:
            break;
    }
   
    [PTPPLocalFileManager printListOfFilesAtDirectory:[PTPPLocalFileManager getRootFolderPathForStaitcStickers]];
    [PTPPLocalFileManager printListOfFilesAtDirectory:[PTPPLocalFileManager getRootFolderPathForARStickers]];
    [PTPPLocalFileManager printListOfFilesAtDirectory:[PTPPLocalFileManager getRootFolderPathForJigsawTemplate]];
    
    //[PTPPLocalFileManager printListOfFilesAtDirectory:[PTPPLocalFileManager getRootFolderPathForCache]];
    [self.collectionView reloadData];
}

- (void)downloadDidFail:(NSNotification *)notification{
    NSLog(@"download failed");
}

- (void)downloadDidReceiveData:(NSNotification *)notification{
    NSLog(@"download ongoing");
}

#pragma mark - Touch events
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissMe{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)toggleMaterialManagement{
    PTPPMaterialManagementListViewController *manageVC = [[PTPPMaterialManagementListViewController alloc] init];
    [self.navigationController pushViewController:manageVC animated:YES];
}

-(void)startRefresh:(id)sender{
    switch (self.activeSection) {
        case 0:
            [self loadNewStaticStickerData];
            break;
        case 1:
            [self loadNewARStickerData];
            break;
        case 2:
            [self loadNewJigsawTemplateData];
            break;
            
        default:
            break;
    }
}

#pragma mark - Private Methods
-(void)loadNewStaticStickerData{
    if (self.loadingStaticSticker) {
        return;
    }
    self.collectionView.hidden = YES;
    self.loadingStaticSticker = YES;
    [self.staticStickerArray removeAllObjects];
    [self.staticStickerModel cancelAllRequest];
    self.staticStickerModel.pageOffset = 10;
    self.staticStickerModel.materialType = @"sticker_pic";
    [self.staticStickerModel reloadData];
    [SVProgressHUD showWithStatus:@"加载中"];
}

-(void)loadMoreStaticStickerData{
    if (self.loadingStaticSticker || self.staticStickerArray.count == 0) {
        return;
    }
    self.loadingStaticSticker = YES;
    [self.staticStickerModel loadDataAtPageIndex:self.staticStickerModel.pageIndex];
}

-(void)loadNewARStickerData{
    if (self.loadingARSticker) {
        return;
    }
    self.collectionView.hidden = YES;
    self.loadingARSticker = YES;
    [self.ARStickerArray removeAllObjects];
    [self.ARStickerModel cancelAllRequest];
    self.ARStickerModel.pageOffset = 18;
    self.ARStickerModel.materialType = @"dynamic_pic";
    [self.ARStickerModel reloadData];
    [SVProgressHUD showWithStatus:@"加载中"];
}

-(void)loadMoreARStickerData{
    if (self.loadingARSticker || self.ARStickerArray.count == 0) {
        return;
    }
    self.loadingARSticker = YES;
    [self.ARStickerModel loadDataAtPageIndex:self.ARStickerModel.pageIndex];
}

-(void)loadNewJigsawTemplateData{
    if (self.loadingJigsawTemplate) {
        return;
    }
    self.collectionView.hidden = YES;
    self.loadingJigsawTemplate = YES;
    [self.jigsawTemplateArray removeAllObjects];
    [self.jigsawTemplateModel cancelAllRequest];
    self.jigsawTemplateModel.pageOffset = 10;
    self.jigsawTemplateModel.maxNum = self.jigsawTemplateFilter;
    self.jigsawTemplateModel.materialType = @"template_pic";
    [self.jigsawTemplateModel reloadData];
    [SVProgressHUD showWithStatus:@"加载中"];
}

-(void)loadMoreJigsawTemplateData{
    if (self.loadingJigsawTemplate || self.jigsawTemplateArray.count == 0) {
        return;
    }
    self.loadingJigsawTemplate = YES;
    [self.jigsawTemplateModel loadDataAtPageIndex:self.jigsawTemplateModel.pageIndex];
}

-(void)downloadMaterialFromSourceURL:(NSString *)sourceURL saveAtDestPath:(NSString *)destPathURL package:(PTPPMaterialShopStickerItem *)package {
    [[DownloadManager shareManager] addDownloadWithFilename:destPathURL URL:[NSURL URLWithString:sourceURL] package:package];
    [self.collectionView reloadData];
}

- (void)displayMultiPickerForGroup:(ALAssetsGroup *)group maxCount:(NSInteger)maxCount{
    if (group == nil) {
        return;
    }
    ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithStyle:UITableViewStylePlain];
    tablePicker.singleSelection = NO;
    tablePicker.immediateReturn = NO;
    tablePicker.selectionPreviewMode = YES;
    tablePicker.maxCount = maxCount;
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] init];
    elcPicker.imagePickerDelegate = self;
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For single image selection, do not display and return order of selected images
    tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    [self.navigationController pushViewController:tablePicker animated:YES];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];

    if (info.count>0) {
        if (self.proceedToImageEdit) {
            //Go to jigsaw template
            PTPPJigsawTemplateViewController *jigsawTemplateVC = [[PTPPJigsawTemplateViewController alloc] init];
            jigsawTemplateVC.images = info;
            jigsawTemplateVC.selectedJigsawItem = self.selectedJigsawItem;
            [self.navigationController pushViewController:jigsawTemplateVC animated:YES];
        }
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UICollectionViewDataSource / UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger dataCount = 0;
    switch (self.activeSection) {
        case 0:
            dataCount = self.staticStickerArray.count;
            if (!self.staticStickerDataFinished && self.staticStickerArray.count!=0) {
                dataCount += 1;
            }
            break;
        case 1:
            dataCount = self.ARStickerArray.count;
            if (!self.ARStickerDataFinished && self.ARStickerArray.count!=0) {
                dataCount += 1;
            }
            break;
        case 2:
            dataCount = self.jigsawTemplateArray.count;
            if (!self.jigsawTemplateDataFinished && self.jigsawTemplateArray.count!=0) {
                dataCount += 1;
            }
            break;
        default:
            break;
    }

    return dataCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    __weak typeof(self) weakSelf = self;
    switch (self.activeSection) {
        case 0:{
            //贴纸Cell
            PTPPMaterialShopStickerItem *staticStickerItem = [self.staticStickerArray safeObjectAtIndex:indexPath.row];
            NSString *downloadFolder = [PTPPLocalFileManager getRootFolderPathForStaitcStickers];
            NSString *urlString = staticStickerItem.downloadURL;
            NSString *downloadFilename = [downloadFolder stringByAppendingPathComponent:[urlString lastPathComponent]];
            NSString *fileName = [staticStickerItem.downloadURL lastPathComponent];
            BOOL downloaded = [PTPPLocalFileManager checkIfDownloadedList:[PTPPLocalFileManager getDownloadedStaticStickerList] containsFileName:fileName];
            PTPPMaterialDownloadStatus downloadStatus;
            if (downloaded) {
                downloadStatus = PTPPMaterialDownloadStatusFinished;
                staticStickerItem.isDownloading = NO;
            }else{
                if (staticStickerItem.isDownloading) {
                    downloadStatus = PTPPMaterialDownloadStatusInProgress;
                }else{
                    downloadStatus = PTPPMaterialDownloadStatusReady;
                    staticStickerItem.isDownloading = NO;
                }
            }
            if (indexPath.row == self.staticStickerArray.count) {
                NSLog(@"Triggering loading cell...");
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopLoadingCellID forIndexPath:indexPath];
                [((PTMaterialShopLoadingCell *)cell) startAnimating];
                [self loadMoreStaticStickerData];
                
            }else{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopStickerItemCellID forIndexPath:indexPath];
                [((PTPPMaterialShopStickerItemCell *)cell) setAttributeWithImageURL:staticStickerItem.coverPic stickerName:staticStickerItem.packageName stickerCount:staticStickerItem.totalNum binarySize:staticStickerItem.packageSize downloadStatus:downloadStatus isNew:staticStickerItem.isNew];
                ((PTPPMaterialShopStickerItemCell *)cell).downloadAction = ^{
                    staticStickerItem.isDownloading = YES;
                    [weakSelf downloadMaterialFromSourceURL:urlString saveAtDestPath:downloadFilename package:staticStickerItem];
                };
            }
            break;
        }
        case 1:{
            //动态贴图Cell
            PTPPMaterialShopStickerItem *ARStickerItem = [self.ARStickerArray safeObjectAtIndex:indexPath.row];
            NSString *downloadFolder = [PTPPLocalFileManager getRootFolderPathForARStickers];
            NSString *urlString = ARStickerItem.downloadURL;
            NSString *downloadFilename = [downloadFolder stringByAppendingPathComponent:[urlString lastPathComponent]];
            NSString *fileName = [ARStickerItem.downloadURL lastPathComponent];
            BOOL downloaded = [PTPPLocalFileManager checkIfDownloadedList:[PTPPLocalFileManager getDownloadedARStickerList] containsFileName:fileName];
            PTPPMaterialDownloadStatus downloadStatus;
            if (downloaded) {
                downloadStatus = PTPPMaterialDownloadStatusFinished;
                ARStickerItem.isDownloading = NO;
            }else{
                if (ARStickerItem.isDownloading) {
                    downloadStatus = PTPPMaterialDownloadStatusInProgress;
                }else{
                    downloadStatus = PTPPMaterialDownloadStatusReady;
                    ARStickerItem.isDownloading = NO;
                }
            }
            if (indexPath.row == self.ARStickerArray.count) {
                NSLog(@"Triggering loading cell...");
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopLoadingCellID forIndexPath:indexPath];
                [((PTMaterialShopLoadingCell *)cell) startAnimating];
                [self loadMoreARStickerData];
                
            }else{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShoptARStickerItemCellID forIndexPath:indexPath];
                [((PTPPMaterialShopARStickerItemCell *)cell) setAttributeWithImageURL:ARStickerItem.coverPic downloadStatus:downloadStatus isNew:ARStickerItem.isNew];
                ((PTPPMaterialShopStickerItemCell *)cell).downloadAction = ^{
                    ARStickerItem.isDownloading = YES;
                    [weakSelf downloadMaterialFromSourceURL:urlString saveAtDestPath:downloadFilename package:ARStickerItem];
                };
            }
            break;
        }
        case 2:{
            //拼图模版Cell
            PTPPMaterialShopStickerItem *jigsawTemplateItem = [self.jigsawTemplateArray safeObjectAtIndex:indexPath.row];
            NSString *downloadFolder = [PTPPLocalFileManager getRootFolderPathForJigsawTemplate];
            NSString *urlString = jigsawTemplateItem.downloadURL;
            NSString *downloadFilename = [downloadFolder stringByAppendingPathComponent:[urlString lastPathComponent]];
            NSString *fileName = [jigsawTemplateItem.downloadURL lastPathComponent];
            BOOL downloaded = [PTPPLocalFileManager checkIfDownloadedList:[PTPPLocalFileManager getDownloadedJigsawTemplateList] containsFileName:fileName];
            PTPPMaterialDownloadStatus downloadStatus;
            if (downloaded) {
                downloadStatus = PTPPMaterialDownloadStatusFinished;
                jigsawTemplateItem.isDownloading = NO;
            }else{
                if (jigsawTemplateItem.isDownloading) {
                    downloadStatus = PTPPMaterialDownloadStatusInProgress;
                }else{
                    downloadStatus = PTPPMaterialDownloadStatusReady;
                    jigsawTemplateItem.isDownloading = NO;
                }
            }
            if (indexPath.row == self.jigsawTemplateArray.count) {
                NSLog(@"Triggering loading cell...");
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopLoadingCellID forIndexPath:indexPath];
                [((PTMaterialShopLoadingCell *)cell) startAnimating];
                [self loadMoreJigsawTemplateData];
                
            }else{
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopJigsawItemCellID forIndexPath:indexPath];
                [((PTPPMaterialShopJigsawItemCell *)cell) setAttributeWithImageURL:jigsawTemplateItem.coverPic downloadStatus:downloadStatus isNew:jigsawTemplateItem.isNew];
                ((PTPPMaterialShopStickerItemCell *)cell).downloadAction = ^{
                    jigsawTemplateItem.isDownloading = YES;
                    [weakSelf downloadMaterialFromSourceURL:urlString saveAtDestPath:downloadFilename package:jigsawTemplateItem];
                };
            }
            break;
        }
        default:
            break;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.activeSection == 0) {
        PTPPMaterialShopStickerItem *stickerItem = [self.staticStickerArray safeObjectAtIndex:indexPath.row];
        PTPPMaterialStickerDetailViewController *stickerDetailVC = [[PTPPMaterialStickerDetailViewController alloc] init];
        stickerDetailVC.materialType = @"sticker_pic";
        stickerDetailVC.packageID = stickerItem.packageID;
        [self.navigationController pushViewController:stickerDetailVC animated:YES];
    }
    if (self.activeSection == 2) {
        self.selectedJigsawItem = [self.jigsawTemplateArray safeObjectAtIndex:indexPath.row];
        if (self.proceedToImageEdit) {
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
            NSArray *parsingDictArray = [[resultDict safeObjectForKey:@"jigsaw"] safeObjectForKey:@"maskList"];
            [self displayMultiPickerForGroup:[ASSETHELPER.assetArray objectAtIndex:0] maxCount:parsingDictArray.count];
        }
        if (self.proceedToSwapTemplate) {
            if (self.templateSwap) {
                self.templateSwap(self.selectedJigsawItem);
            }
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kCollectionViewEdgePadding, 0, kCollectionViewEdgePadding);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.activeSection == 1) {
        return (CGSize){.width = Screenwidth/3-(kCollectionViewEdgePadding+kCellSpacing), .height = Screenwidth/3-(kCollectionViewEdgePadding+kCellSpacing)};
    }
    return (CGSize){.width = Screenwidth/2-(kCollectionViewEdgePadding+kCellSpacing), .height = (Screenwidth/2-(kCollectionViewEdgePadding+kCellSpacing))/290*406};
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kCellSpacing*2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kCellSpacing;
}

#pragma mark - PTCustomMenuSliderViewDelegate
-(void)sliderView:(PTCustomMenuSliderView *)sliderView didSelecteAtIndex:(NSInteger)index{
    self.activeSection = index;
    switch (index) {
        case 0:
            if (self.staticStickerArray.count == 0) {
                [self loadNewStaticStickerData];
            }
            
            break;
        case 1:
            if (self.ARStickerArray.count == 0) {
                [self loadNewARStickerData];
            }
            
            break;
        case 2:
            if (self.jigsawTemplateArray.count == 0) {
                [self loadNewJigsawTemplateData];
            }
            
            break;
        default:
            break;
    }
    [self.collectionView setContentOffset:CGPointZero];
    [self.collectionView reloadData];
}

#pragma mark - <SOModelDelegate>

-(void)model:(SOBaseModel *)model didReceivedData:(id)data userInfo:(id)info{
    [SVProgressHUD dismiss];
    [self.refreshControl endRefreshing];
    self.collectionView.hidden = NO;
    if (model == self.staticStickerModel) {
        NSLog(@"Success");
        self.loadingStaticSticker = NO;
        if(!data || ![data isKindOfClass:[NSArray class]] || [data count] < self.staticStickerModel.pageOffset) {
            self.staticStickerDataFinished = YES;
        } else {

        }
        [self.staticStickerArray addObjectsFromArray:data];
        if (self.staticStickerArray.count == 0) {
            [self.collectionView setContentOffset:CGPointZero];
        }
        [self.collectionView reloadData];
    }
    if (model == self.ARStickerModel) {
        NSLog(@"Success");
        self.loadingARSticker = NO;
        if(!data || ![data isKindOfClass:[NSArray class]] || [data count] < self.ARStickerModel.pageOffset) {
            self.ARStickerDataFinished = YES;
        } else {
            
        }
        [self.ARStickerArray addObjectsFromArray:data];
        if (self.ARStickerArray.count == 0) {
            [self.collectionView setContentOffset:CGPointZero];
        }
        [self.collectionView reloadData];
    }
    if (model == self.jigsawTemplateModel) {
        NSLog(@"Success");
        self.loadingJigsawTemplate = NO;
        if(!data || ![data isKindOfClass:[NSArray class]] || [data count] < self.jigsawTemplateModel.pageOffset) {
            self.jigsawTemplateDataFinished = YES;
        } else {
            
        }
        [self.jigsawTemplateArray addObjectsFromArray:data];
        if (self.jigsawTemplateArray.count == 0) {
            [self.collectionView setContentOffset:CGPointZero];
        }
        [self.collectionView reloadData];
    }
}

-(void)model:(SOBaseModel *)model didFailedInfo:(id)info error:(id)error{
    [SVProgressHUD dismissWithError:@"网络不太给力" afterDelay:1.0];
    self.collectionView.hidden = NO;
    [self.refreshControl endRefreshing];
    self.loadingStaticSticker = NO;
    self.loadingARSticker = NO;
    self.loadingJigsawTemplate = NO;
}

#pragma mark - DZNEmptyDataSetDelegate / DZNEmptyDataSetSource
//主提示标题

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    //隐藏上拉刷新
    
    text = @"网络不给力 :(";
    font = [UIFont boldSystemFontOfSize:16.0];
    textColor = [UIColor grayColor];
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 40.0;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorWithHexString:@"e1e1e1"];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    //需要圆形图片
    return [UIImage imageNamed:@"img_page_empty"];
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    //点击空白 重新请求
    [self startRefresh:self.refreshControl];
}


#pragma mark - getters/setters
-(PTCustomMenuSliderView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[PTCustomMenuSliderView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, HEIGHT_NAV)];
        _sliderView.layer.borderWidth = 1;
        _sliderView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
        _sliderView.delegate = self;
    }
    return _sliderView;
}

-(UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

-(UIRefreshControl *)refreshControl{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(startRefresh:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, Screenheight-HEIGHT_NAV*2) collectionViewLayout:self.layout];
        [_collectionView registerClass:[PTPPMaterialShopStickerItemCell class] forCellWithReuseIdentifier:PTPPMaterialShopStickerItemCellID];
        [_collectionView registerClass:[PTPPMaterialShopARStickerItemCell class] forCellWithReuseIdentifier:PTPPMaterialShoptARStickerItemCellID];
        [_collectionView registerClass:[PTPPMaterialShopJigsawItemCell class] forCellWithReuseIdentifier:PTPPMaterialShopJigsawItemCellID];
        [_collectionView registerClass:[PTMaterialShopLoadingCell class] forCellWithReuseIdentifier:PTPPMaterialShopLoadingCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        [_collectionView addSubview:self.refreshControl];
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

@end
