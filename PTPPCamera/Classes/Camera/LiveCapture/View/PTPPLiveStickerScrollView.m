//
//  PTPPLiveStickerScrollView.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 21/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "DownloadManager.h"
#import "PTPPLiveStickerScrollView.h"
#import "PTLiveStickerPickerCell.h"
#import "PTPPLocalFileManager.h"

#define kCollectionViewEdgePadding 0
#define kCellSpacing 0

@interface PTPPLiveStickerScrollView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DownloadManagerDelegate>
@property (strong, nonatomic) DownloadManager *downloadManager;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIView *splitter;
@property (nonatomic, strong) NSArray *stickerSet;
@property (nonatomic, strong) NSMutableArray *stickerControlSet;
@end

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
        //[self initiateDownloadProcess];
        //[self unzipAllFiles];
    }
    return self;
}

-(void)setAttributeWithFilterSet:(NSArray *)stickerSet{
    self.stickerSet = stickerSet;
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
-(void)initiateDownloadProcess{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"ARStickers"];
    NSArray *urlStrings = @[@"http://123.56.159.214/downloads/demo2.zip"];
    for (NSString *urlString in urlStrings)
    {
        NSString *downloadFilename = [downloadFolder stringByAppendingPathComponent:[urlString lastPathComponent]];
        NSURL *url = [NSURL URLWithString:urlString];
        
        [self.downloadManager addDownloadWithFilename:downloadFilename URL:url];
    }
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

#pragma mark - DownloadManager Delegate Methods
-(void)didFinishLoadingAllForManager:(DownloadManager *)downloadManager{
   
    NSLog(@"Download All Finish");
    [PTPPLocalFileManager unzipAllFilesForARStickers];
}

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFail:(Download *)download;
{
    NSLog(@"%s %@ error=%@", __FUNCTION__, download.filename, download.error);
}

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidReceiveData:(Download *)download;
{
    for (NSInteger row = 0; row < [downloadManager.downloads count]; row++)
    {
        if (download == downloadManager.downloads[row])
        {
            //[self updateProgressViewForIndexPath:[NSIndexPath indexPathForRow:row inSection:0] download:download];
            NSLog(@"File %ld Download Progress:%.2f", (long)row,(double) download.progressContentLength / (double) download.expectedContentLength);
            break;
        }
    }
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.stickerSet.count;
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
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTLiveStickerPickerCellID forIndexPath:indexPath];
    BOOL selected = [self.selectedStickerName isEqualToString:[self.stickerSet safeObjectAtIndex:indexPath.row]];
    [((PTLiveStickerPickerCell *)cell) setAttributeWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_icon",[self.stickerSet safeObjectAtIndex:indexPath.row]]] selected:selected];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedStickerName = [self.stickerSet safeObjectAtIndex:indexPath.row];
    if (self.stickerSelected) {
        self.stickerSelected([self.stickerSet safeObjectAtIndex:indexPath.row],YES);
    }
    [self.collectionView reloadData];
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
