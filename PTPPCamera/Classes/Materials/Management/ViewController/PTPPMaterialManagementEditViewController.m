//
//  PTPPMaterialManagementEditViewController.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 24/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPMaterialManagementEditViewController.h"
#import "PTPPMaterialStickerDetailViewController.h"
#import "PTPPMaterialShopStickerItemCell.h"
#import "PTPPMaterialShopARStickerItemCell.h"
#import "PTPPMaterialShopJigsawItemCell.h"
#import "PTPPMaterialManagementBottomView.h"
#import "PTPPMaterialShopStickerItem.h"
#import "PTPPLocalFileManager.h"

#define kCollectionViewEdgePadding 10
#define kCellSpacing 5

@interface PTPPMaterialManagementEditViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PTPPMaterialManagementBottomViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) PTPPMaterialManagementBottomView *bottomView;

@property (nonatomic, strong) NSDictionary *settingDict;
@property (nonatomic, strong) NSMutableArray <PTPPMaterialShopStickerItem*> *localFileArray;
@property (nonatomic, assign) BOOL selectionMode;
@end

static NSString *PTPPMaterialShopStickerItemCellID = @"PTPPMaterialShopStickerItemCellID";
static NSString *PTPPMaterialShoptARStickerItemCellID = @"PTPPMaterialShoptARStickerItemCellID";
static NSString *PTPPMaterialShopJigsawItemCellID = @"PTPPMaterialShopJigsawItemCellID";
@implementation PTPPMaterialManagementEditViewController

#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self disableAdjustsScrollView];
    [self cleanEdgesForExtendedLayout];
    
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xff5a5d)];
    [self setTitle:@"素材中心" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] selector:nil];
    //[self showRightItemWithText:@"管理" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] selector:@selector(toggleEditMode) animation:NO];
    [self.view addSubview:self.collectionView];
    [self toggleEditMode];
    [self showLeftItemWithImage:[UIImage imageNamed:@"back_white"] selector:@selector(goBack) animation:YES];
    self.collectionView.frame = CGRectMake(0, 0, Screenwidth, Screenheight-HEIGHT_NAV);
    [self readLocalFileSettings];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
-(void)readLocalFileSettings{
    [self.localFileArray removeAllObjects];
    switch (self.activeSection) {
        case 0:
            self.settingDict = [PTPPLocalFileManager getDownloadedStaticStickerList];
            break;
        case 1:
            self.settingDict = [PTPPLocalFileManager getDownloadedARStickerList];
            break;
        case 2:
            self.settingDict = [PTPPLocalFileManager getDownloadedJigsawTemplateList];
            break;
        default:
            break;
    }
    for(NSString *key in [self.settingDict allKeys]){
        NSDictionary *currentFileSetting = [self.settingDict safeObjectForKey:key];
        PTPPMaterialShopStickerItem *item = [[PTPPMaterialShopStickerItem alloc] init];
        item.packageID = key;
        item.packageName = [currentFileSetting safeStringForKey:kLocalThemeName];
        item.packageSize = [currentFileSetting safeStringForKey:kLocalFileSize];
        item.totalNum = [currentFileSetting safeStringForKey:kLocalTotalNum];
        item.coverPic = [currentFileSetting safeStringForKey:kLocalCoverPic];
        [self.localFileArray addObject:item];
    }
    if (self.localFileArray.count == 0) {
        self.bottomView.hidden = YES;
    }else{
        self.bottomView.hidden = NO;
    }
    [self.collectionView reloadData];
}

#pragma mark - Touch events
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toggleEditMode{
    if (!self.selectionMode) {
        //[self showRightItemWithText:@"取消" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] selector:@selector(toggleEditMode) animation:NO];
        [self.view addSubview:self.bottomView];
    }else{
        //[self showRightItemWithText:@"管理" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] selector:@selector(toggleEditMode) animation:NO];
        [self.bottomView removeFromSuperview];
    }
    self.selectionMode = !self.selectionMode;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.localFileArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    PTPPMaterialShopStickerItem* item = [self.localFileArray safeObjectAtIndex:indexPath.row];
    PTPPMaterialEditStatus editStatus;
    if (item.isSelected) {
        editStatus = PTPPMaterialEditStatusItemSelected;
    }else{
        editStatus = PTPPMaterialEditStatusItemDeselected;
    }
    switch (self.activeSection) {
        case 0:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopStickerItemCellID forIndexPath:indexPath];
                [((PTPPMaterialShopStickerItemCell *)cell)  setAttributeWithImageURL:item.coverPic stickerName:item.packageName stickerCount:item.totalNum binarySize:item.packageSize editStatus:editStatus isNew:NO];
            
            ((PTPPMaterialShopStickerItemCell *)cell).selectionMode = self.selectionMode;
            break;
        case 1:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShoptARStickerItemCellID forIndexPath:indexPath];
            [((PTPPMaterialShopARStickerItemCell *)cell) setAttributeWithImageURL:item.coverPic editStatus:editStatus isNew:NO];
           
            ((PTPPMaterialShopARStickerItemCell *)cell).selectionMode = self.selectionMode;
            break;
        case 2:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopJigsawItemCellID forIndexPath:indexPath];
            
            [((PTPPMaterialShopJigsawItemCell *)cell) setAttributeWithImageURL:item.coverPic editStatus:editStatus isNew:YES];
            ((PTPPMaterialShopJigsawItemCell *)cell).selectionMode = self.selectionMode;
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PTPPMaterialShopStickerItem* item = [self.localFileArray safeObjectAtIndex:indexPath.row];
    [item setSelected:!item.isSelected];
    [self.collectionView reloadData];
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

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self confirmDeleteSelected];
    }
}

#pragma mark - PTPPMaterialManagementBottomViewDelegate
-(void)didToggleSelectAll:(PTPPMaterialManagementBottomView *)bottomView{
    for(PTPPMaterialShopStickerItem* item in self.localFileArray){
        [item setSelected:YES];
    }
    [self.collectionView reloadData];
}

-(void)didToggleDelete:(PTPPMaterialManagementBottomView *)bottomView{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除选中项吗" message:nil delegate:self cancelButtonTitle:@"不" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)confirmDeleteSelected{
    for(PTPPMaterialShopStickerItem* item in self.localFileArray){
        if (item.isSelected) {
            NSString *rootFolder = nil;
            NSString *plistName = nil;
            switch (self.activeSection) {
                case 0:
                    rootFolder = [PTPPLocalFileManager getRootFolderPathForStaitcStickers];
                    plistName = StaticStickerPlistFile;
                    break;
                case 1:
                    rootFolder = [PTPPLocalFileManager getRootFolderPathForARStickers];
                    plistName = ARStickerPlistFile;
                    break;
                case 2:
                    rootFolder = [PTPPLocalFileManager getRootFolderPathForJigsawTemplate];
                    plistName = JigsawTemplatePlistFile;
                    break;
                    
                default:
                    break;
            }
            [PTPPLocalFileManager removeItemAtPath:[rootFolder stringByAppendingPathComponent:[[[self.settingDict safeObjectForKey:item.packageID] safeStringForKey:kLocalFileName] stringByDeletingPathExtension]]];
            [PTPPLocalFileManager removeItemFromPlist:plistName withPackageID:item.packageID];
            
        }
    }
    [self readLocalFileSettings];
}

-(PTPPMaterialManagementBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[PTPPMaterialManagementBottomView alloc] initWithFrame:CGRectMake(0, Screenheight-HEIGHT_NAV-HEIGHT_NAV, Screenwidth, HEIGHT_NAV)];
        _bottomView.viewDelegate = self;
    }
    return _bottomView;
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
        [_collectionView registerClass:[PTPPMaterialShopStickerItemCell class] forCellWithReuseIdentifier:PTPPMaterialShopStickerItemCellID];
        [_collectionView registerClass:[PTPPMaterialShopARStickerItemCell class] forCellWithReuseIdentifier:PTPPMaterialShoptARStickerItemCellID];
        [_collectionView registerClass:[PTPPMaterialShopJigsawItemCell class] forCellWithReuseIdentifier:PTPPMaterialShopJigsawItemCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10+HEIGHT_NAV, 0);
    }
    return _collectionView;
}

-(NSMutableArray *)localFileArray{
    if (!_localFileArray) {
        _localFileArray = [[NSMutableArray alloc] init];
    }
    return _localFileArray;
}

@end
