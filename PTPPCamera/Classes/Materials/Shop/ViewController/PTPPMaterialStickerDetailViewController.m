//
//  PTPPMaterialStickerDetailViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 15/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//
#import "DownloadManager.h"
#import "PTPPLocalFileManager.h"
#import "PTPPMaterialStickerDetailViewController.h"
#import "PTPPMaterialStickerDetailCell.h"
#import "PTPPMaterialStickerDetailHeaderView.h"
#import "PTPPMaterialShopStickerDetailItem.h"
#import "PTPPMaterialShopStickerDetailModel.h"

#define kCollectionViewEdgePadding 10
#define kCellSpacing 5

@interface PTPPMaterialStickerDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SOModelDelegate, DownloadManagerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) PTPPMaterialShopStickerDetailItem *stickerDetailItem;
@property (nonatomic, strong) PTPPMaterialShopStickerDetailModel *stickerDetailModel;

@end

static NSString *PTPPMaterialStickerDetailCellID = @"PTPPMaterialStickerDetailCellID";
static NSString *PTPPMaterialStickerDetailHeaderViewID = @"PTPPMaterialStickerDetailHeaderViewID";
@implementation PTPPMaterialStickerDetailViewController

#pragma mark - Life Cycles
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _stickerDetailModel = [PTPPMaterialShopStickerDetailModel shareModel];
        [_stickerDetailModel setDelegate:self];
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
    [self setTitle:@"贴纸详情" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] selector:nil];
    [self showLeftItemWithImage:[UIImage imageNamed:@"back_white"] selector:@selector(goBack) animation:YES];
    [self.view addSubview:self.collectionView];
    [self loadStickerDetailData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidFinishLoading:) name:kDownloadDidFinishLoading object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidReceiveData:) name:kDownloadDidReceiveData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDidFail:) name:kDownloadDidFail object:nil];
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


#pragma mark - Private Methods
-(void)loadStickerDetailData{
    [self.stickerDetailModel cancelAllRequest];
    self.stickerDetailModel.materialType = self.materialType;
    self.stickerDetailModel.packageID = self.packageID;
    [self.stickerDetailModel startLoad];
}

-(void)initiateDownload{
    
    NSString *downloadFolder = [PTPPLocalFileManager getRootFolderPathForStaitcStickers];
    NSString *urlString = self.stickerDetailItem.downloadURL;

    NSString *downloadFilename = [downloadFolder stringByAppendingPathComponent:[urlString lastPathComponent]];
    NSURL *url = [NSURL URLWithString:urlString];
        
    [[DownloadManager shareManager] addDownloadWithFilename:downloadFilename URL:url package:self.stickerDetailItem];
    
}

#pragma mark - NSNotifications
- (void)downloadDidFinishLoading:(NSNotification *)notification{
    NSLog(@"download complete");
    [SVProgressHUD dismissWithSuccess:@"下载完成" afterDelay:0.6];
    Download *download = notification.object;
    
    [PTPPLocalFileManager unzipFileFromPath:download.filename desPath:[[PTPPLocalFileManager getRootFolderPathForStaitcStickers] stringByAppendingPathComponent:[[download.filename lastPathComponent] stringByDeletingPathExtension]]];
    [PTPPLocalFileManager printListOfFilesAtDirectory:[PTPPLocalFileManager getRootFolderPathForStaitcStickers]];
    [PTPPLocalFileManager writePropertyListTo:StaticStickerPlistFile WithPackageID:self.packageID fileName:[download.filename lastPathComponent] themeName:self.stickerDetailItem.packageName fileSize:self.stickerDetailItem.packageSize totalNum:self.stickerDetailItem.totalNum coverPic:self.stickerDetailItem.coverPic];
    [PTPPLocalFileManager printListOfFilesAtDirectory:[PTPPLocalFileManager getRootFolderPathForCache]];
    [self.collectionView reloadData];
}

- (void)downloadDidFail:(NSNotification *)notification{
    NSLog(@"download failed");
}

- (void)downloadDidReceiveData:(NSNotification *)notification{
    NSLog(@"download ongoing");
}

#pragma mark - Touch Events
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.stickerDetailItem.thunbmailList.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kCollectionViewEdgePadding, 0, kCollectionViewEdgePadding);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return (CGSize){.width = Screenwidth/3-(kCollectionViewEdgePadding+kCellSpacing), .height = Screenwidth/3-(kCollectionViewEdgePadding+kCellSpacing)};
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kCellSpacing*2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kCellSpacing;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialStickerDetailCellID forIndexPath:indexPath];
    [((PTPPMaterialStickerDetailCell *)cell) setAttributeWithImageURL:[self.stickerDetailItem.thunbmailList safeObjectAtIndex:indexPath.row]];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PTPPMaterialStickerDetailHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PTPPMaterialStickerDetailHeaderViewID forIndexPath:indexPath];
        NSString *fileName = [self.stickerDetailItem.downloadURL lastPathComponent];
        BOOL downloaded = [PTPPLocalFileManager checkIfDownloadedList:[PTPPLocalFileManager getDownloadedStaticStickerList] containsFileName:fileName];
        [headerView setAttributeWithBannerImgURL:self.stickerDetailItem.bannerPic stickerName:self.stickerDetailItem.packageName stickerDetail:self.stickerDetailItem.storeDescription isDownloaded:downloaded];
        __weak typeof(self) weakSelf = self;
        headerView.downloadAciton = ^{
            [weakSelf initiateDownload];
            [SVProgressHUD showWithStatus:@"下载中"];
        };
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.width, [PTPPMaterialStickerDetailHeaderView getHeightWithStickerDetailText:self.stickerDetailItem.storeDescription constraintWidth:collectionView.width-20]);
}

#pragma mark - <SOModelDelegate>

-(void)model:(SOBaseModel *)model didReceivedData:(id)data userInfo:(id)info{
    [SVProgressHUD dismiss];
    if (model == self.stickerDetailModel) {
        self.stickerDetailItem = data;
        [self.collectionView reloadData];
    }
}

-(void)model:(SOBaseModel *)model didFailedInfo:(id)info error:(id)error{
    [SVProgressHUD dismiss];
}

-(UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, Screenheight-HEIGHT_NAV) collectionViewLayout:self.layout];
        [_collectionView registerClass:[PTPPMaterialStickerDetailCell class] forCellWithReuseIdentifier:PTPPMaterialStickerDetailCellID];
        [_collectionView registerClass:[PTPPMaterialStickerDetailHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PTPPMaterialStickerDetailHeaderViewID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    }
    return _collectionView;
}

@end
