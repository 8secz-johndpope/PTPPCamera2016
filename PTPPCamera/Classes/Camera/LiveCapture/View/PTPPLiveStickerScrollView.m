//
//  PTPPLiveStickerScrollView.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 21/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPLiveStickerScrollView.h"
#import "PTLiveStickerPickerCell.h"
#import "PTPPLocalFileManager.h"
#import "PTPPMaterialShopARStickerModel.h"

#import "PTMaterialShopLoadingCell.h"

#define kCollectionViewEdgePadding 0
#define kCellSpacing 0

@interface PTPPLiveStickerScrollView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SOModelDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIView *splitter;
@property (nonatomic, strong) NSArray *preinstalledSet; //Stickers from default package
@property (nonatomic, strong) NSMutableArray *stickerSet;
@property (nonatomic, strong) NSMutableArray *stickerControlSet;

@property (nonatomic, strong) PTPPMaterialShopStickerItem *ARStickerItem;
@property (nonatomic, strong) PTPPMaterialShopARStickerModel *ARStickerModel;
@property (nonatomic, strong) NSMutableArray <PTPPMaterialShopStickerItem*>*ARStickerArray; //Stickers packages from server
@property (nonatomic, assign) BOOL loadingARSticker;
@property (nonatomic, assign) BOOL ARStickerDataFinished;

@end

static NSString *PTPPMaterialShopLoadingCellID = @"PTPPMaterialShopLoadingCellID";
static NSString *PTLiveStickerPickerCellID = @"PTLiveStickerPickerCellID";
@implementation PTPPLiveStickerScrollView 

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.collectionView];
        [self addSubview:self.dismissButton];
        [self addSubview:self.clearButton];
        [self addSubview:self.splitter];
        
        _ARStickerModel = [PTPPMaterialShopARStickerModel shareModel];
        [_ARStickerModel setDelegate:self];
        _ARStickerArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setAttributeWithLocalCacheWithPreinstalledSet:(NSArray *)preinstalledSet{
    self.preinstalledSet = preinstalledSet;
    self.stickerSet = [[NSMutableArray alloc] initWithArray:preinstalledSet];
    [self setNeedsLayout];
    [self.collectionView reloadData];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.dismissButton.frame = CGRectMake(0, self.height-40, self.dismissButton.width, self.dismissButton.height);
    self.clearButton.frame = CGRectMake(self.dismissButton.right, self.dismissButton.top, self.clearButton.width, self.clearButton.height);
    self.splitter.frame = CGRectMake(self.clearButton.left, self.clearButton.top+5, self.splitter.width, self.splitter.height);
}

#pragma mark - Private methods
-(void)loadNewARStickerData{
    if (self.loadingARSticker) {
        return;
    }
    self.loadingARSticker = YES;
    [self.ARStickerArray removeAllObjects];
    [self.ARStickerModel cancelAllRequest];
    self.ARStickerModel.pageOffset = 18;
    self.ARStickerModel.materialType = @"dynamic_pic";
    [self.ARStickerModel reloadData];
}

-(void)loadMoreARStickerData{
    if (self.loadingARSticker || self.ARStickerArray.count == 0) {
        return;
    }
    self.loadingARSticker = YES;
    [self.ARStickerModel loadDataAtPageIndex:self.ARStickerModel.pageIndex];
}

#pragma mark - Touch Events
-(void)dismissMe{
    if (self.finishBlock) {
        self.finishBlock();
    }
}

-(void)clearSticker{
    self.selectedStickerName = nil;
    [self.collectionView reloadData];
    if (self.stickerSelected) {
        self.stickerSelected(nil, YES);
    }
}

#pragma mark - <SOModelDelegate>

-(void)model:(SOBaseModel *)model didReceivedData:(id)data userInfo:(id)info{

    if (model == self.ARStickerModel) {
        NSLog(@"Success");
        self.loadingARSticker = NO;
        if(!data || ![data isKindOfClass:[NSArray class]] || [data count] < self.ARStickerModel.pageOffset) {
            self.ARStickerDataFinished = YES;
        } else {
            
        }
        [self.ARStickerArray addObjectsFromArray:data];
        [self.collectionView reloadData];
    }

}

-(void)model:(SOBaseModel *)model didFailedInfo:(id)info error:(id)error{
    self.loadingARSticker = NO;
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (!self.ARStickerDataFinished) {
        return self.stickerSet.count+self.ARStickerArray.count+1;
    }
    return self.stickerSet.count+self.ARStickerArray.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kCollectionViewEdgePadding, 0, kCollectionViewEdgePadding);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return (CGSize){.width = self.height-40-(kCollectionViewEdgePadding+kCellSpacing), .height = self.height-40-(kCollectionViewEdgePadding+kCellSpacing)};
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kCellSpacing*2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kCellSpacing;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    // Path example: /var/mobile/Containers/Data/Application/0EB932B8-8541-432B-8C96-2977F2968B7C/Library/ARStickers/XXXXX
    // Use [PTPPLocalFileManager getRootFolderPathForARStickers] to access "ARStickers" folder, then append path component with
    // file name.
    UICollectionViewCell *cell;
    if (indexPath.row<self.preinstalledSet.count) {
        //Cell configurations for preinstalled stickers
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTLiveStickerPickerCellID forIndexPath:indexPath];
        BOOL selected = [self.selectedStickerName isEqualToString:[self.stickerSet safeObjectAtIndex:indexPath.row]];
        UIImage *primaryIcon = nil;
        NSString *contentFilePathList = [self.stickerSet safeObjectAtIndex:indexPath.row];
        NSArray *contentFilePathArray = [PTPPLocalFileManager getListOfFilePathAtDirectory:contentFilePathList];
        for(NSString *contentFileURL in contentFilePathArray){
            if ([contentFileURL rangeOfString:@"_icon"].location != NSNotFound) {
                primaryIcon = [[UIImage alloc] initWithContentsOfFile:contentFileURL];
            }
        }
        [((PTLiveStickerPickerCell *)cell) setAttributeWithImage:primaryIcon selected:selected];
    }else{
        //Cell configurations for online stickers
        if (indexPath.row == self.ARStickerArray.count+self.preinstalledSet.count) {
            NSLog(@"Triggering loading cell...");
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopLoadingCellID forIndexPath:indexPath];
            [((PTMaterialShopLoadingCell *)cell) startAnimating];
            cell.backgroundColor = [UIColor clearColor];
            ((PTMaterialShopLoadingCell *)cell).loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [self loadMoreARStickerData];
            
        }else{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTLiveStickerPickerCellID forIndexPath:indexPath];
            PTPPMaterialShopStickerItem *item = [self.ARStickerArray safeObjectAtIndex:(indexPath.row-self.preinstalledSet.count)];
            BOOL selected = [self.selectedStickerName isEqualToString:[[PTPPLocalFileManager getRootFolderPathForARStickers] stringByAppendingPathComponent:[[item.downloadURL lastPathComponent] stringByDeletingPathExtension]]];
            BOOL downloaded = [PTPPLocalFileManager checkIfDownloadedList:[PTPPLocalFileManager getDownloadedARStickerList] containsFileName:[item.downloadURL lastPathComponent]];
            PTLiveStickerDownloadStatus downloadStatus;
            if (downloaded) {
                downloadStatus = PTLiveStickerDownloadStatusDownloaded;
            }else{
                if (item.isDownloading) {
                    downloadStatus = PTLiveStickerDownloadStatusDownloading;
                }else{
                    downloadStatus = PTLiveStickerDownloadStatusNotDownloaded;
                }
            }
            [((PTLiveStickerPickerCell *)cell) setAttributeWithImageURL:item.coverPic selected:selected downloadStatus:downloadStatus];
        }
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<self.stickerSet.count) {
        self.selectedStickerName = [self.stickerSet safeObjectAtIndex:indexPath.row];
        if (self.stickerSelected) {
            self.stickerSelected([self.stickerSet safeObjectAtIndex:indexPath.row],NO);
        }
        [self.collectionView reloadData];
    }else{
        PTPPMaterialShopStickerItem *item = [self.ARStickerArray safeObjectAtIndex:(indexPath.row-self.preinstalledSet.count)];
        BOOL downloaded = [PTPPLocalFileManager checkIfDownloadedList:[PTPPLocalFileManager getDownloadedARStickerList] containsFileName:[item.downloadURL lastPathComponent]];
        if (downloaded) {
            self.selectedStickerName = [[PTPPLocalFileManager getRootFolderPathForARStickers] stringByAppendingPathComponent:[[item.downloadURL lastPathComponent] stringByDeletingPathExtension]];
            if (self.stickerSelected) {
                self.stickerSelected(self.selectedStickerName,NO);
            }
            [self.collectionView reloadData];
        }else{
            
            NSString *downloadFolder = [PTPPLocalFileManager getRootFolderPathForARStickers];
            NSString *urlString = item.downloadURL;
            NSString *downloadFilename = [downloadFolder stringByAppendingPathComponent:[urlString lastPathComponent]];
            if (self.actionDownload) {
                item.isDownloading = YES;
                [self.collectionView reloadData];
                self.actionDownload(urlString, downloadFilename, item);
            }
        }
    }
}

#pragma mark - Getters/Setters
//-(DownloadManager *)downloadManager{
//    if (!_downloadManager) {
//        _downloadManager = [[DownloadManager alloc] initWithDelegate:self];
//    }
//    return _downloadManager;
//}

-(NSMutableArray *)filterControlSet{
    if (!_stickerControlSet) {
        _stickerControlSet = [[NSMutableArray alloc] init];
    }
    return _stickerControlSet;
}

-(UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _layout;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-40) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        [_collectionView registerClass:[PTLiveStickerPickerCell class] forCellWithReuseIdentifier:PTLiveStickerPickerCellID];
        [_collectionView registerClass:[PTMaterialShopLoadingCell class] forCellWithReuseIdentifier:PTPPMaterialShopLoadingCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    }
    return _collectionView;
}

-(UIButton *)dismissButton{
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width-60, 40)];
        [_dismissButton setImage:[UIImage imageNamed:@"btn_spread_down"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissMe) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

-(UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        [_clearButton setTitle:@"清除" forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearSticker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

-(UIView *)splitter{
    if (!_splitter) {
        _splitter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 30)];
        _splitter.backgroundColor = [UIColor grayColor];
    }
    return _splitter;
}

@end
