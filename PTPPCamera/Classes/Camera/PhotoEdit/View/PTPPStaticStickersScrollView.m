//
//  PTPPStaticStickersScrollView.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 23/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPStaticStickersScrollView.h"
#import "PTStaticStickerPickerCell.h"
#import "PTPPLocalFileManager.h"
#define kCollectionViewEdgePadding 0
#define kCellSpacing 0

@interface PTPPStaticStickersScrollView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionViewPrimary;
@property (nonatomic, strong) UICollectionView *collectionViewSecondary;
@property (nonatomic, strong) UICollectionViewFlowLayout *layoutPrimary;
@property (nonatomic, strong) UICollectionViewFlowLayout *layoutSecondary;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) NSArray *filePathSet;
@property (nonatomic, strong) NSMutableArray *stickerIconPrimaryList;
@property (nonatomic, strong) NSMutableArray *stickerFilePathArray;
@end

static NSString *PTStaticStickerPickerPrimaryCellID = @"PTStaticStickerPickerPrimaryCellID";
static NSString *PTStaticStickerPickerSecondaryCellID = @"PTStaticStickerPickerSecondaryCellID";

@implementation PTPPStaticStickersScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.dismissButton];
        [self addSubview:self.collectionViewPrimary];
        [self addSubview:self.collectionViewSecondary];
    }
    return self;
}


-(void)setAttributeWithFilePathSet:(NSArray *)filePathSet{
    self.filePathSet = filePathSet;
    [self updatePrimaryTheme];
    [self.collectionViewPrimary reloadData];
}

#pragma mark - Touch Events
-(void)dismissMe{
    if (self.finishBlock) {
        self.finishBlock();
    }
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.collectionViewPrimary) {
        return self.filePathSet.count;
    }else{
        NSString *contentFilePathList = [self.filePathSet safeObjectAtIndex:self.activeID];
        NSArray *contentFilePathArray = [PTPPLocalFileManager getListOfFilePathAtDirectory:contentFilePathList];
        return contentFilePathArray.count-1;
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kCollectionViewEdgePadding, 0, kCollectionViewEdgePadding);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return (CGSize){.width = collectionView.height+5-(kCollectionViewEdgePadding+kCellSpacing), .height = collectionView.height-(kCollectionViewEdgePadding+kCellSpacing)};
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kCellSpacing*2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kCellSpacing;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    if (collectionView == self.collectionViewPrimary) {
        UIImage *primaryIcon = nil;
        NSString *contentFilePathList = [self.filePathSet safeObjectAtIndex:indexPath.row];
        NSArray *contentFilePathArray = [PTPPLocalFileManager getListOfFilePathAtDirectory:contentFilePathList];
        for(NSString *contentFileURL in contentFilePathArray){
            if ([contentFileURL rangeOfString:@"_icon"].location != NSNotFound) {
                primaryIcon = [[UIImage alloc] initWithContentsOfFile:contentFileURL];
            }
        }
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTStaticStickerPickerPrimaryCellID forIndexPath:indexPath];
        BOOL selected = (self.activeID == indexPath.row);
        [((PTStaticStickerPickerCell *)cell) setAttributeWithImage:primaryIcon framePadding:5 selected:selected];
    }else{
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[self.stickerFilePathArray safeObjectAtIndex:indexPath.row]];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTStaticStickerPickerSecondaryCellID forIndexPath:indexPath];
        [((PTStaticStickerPickerCell *)cell) setAttributeWithImage:image framePadding:5 selected:YES];
    }
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.collectionViewPrimary) {
        self.activeID = indexPath.row;
        [self updatePrimaryTheme];
        [self.collectionViewPrimary reloadData];
        [self.collectionViewSecondary reloadData];
        [self.collectionViewSecondary setContentOffset:CGPointZero];
    }else{
        if (self.stickerSelected) {
            self.stickerSelected([self.stickerFilePathArray safeObjectAtIndex:indexPath.row],NO);
        }
    }
}

-(void)updatePrimaryTheme{
    NSString *contentFilePathList = [self.filePathSet safeObjectAtIndex:self.activeID];
    NSArray *contentFilePathArray = [PTPPLocalFileManager getListOfFilePathAtDirectory:contentFilePathList];
    [self.stickerFilePathArray removeAllObjects];
    for(NSString *contentFileURL in contentFilePathArray){
        if ([contentFileURL rangeOfString:@"_icon"].location == NSNotFound) {
            [self.stickerFilePathArray safeAddObject:contentFileURL];
        }
    }

}

#pragma mark - Getters/Setters
-(UICollectionViewFlowLayout *)layoutPrimary{
    if (!_layoutPrimary) {
        _layoutPrimary = [[UICollectionViewFlowLayout alloc] init];
        [_layoutPrimary setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _layoutPrimary;
}

-(UICollectionViewFlowLayout *)layoutSecondary{
    if (!_layoutSecondary) {
        _layoutSecondary = [[UICollectionViewFlowLayout alloc] init];
        [_layoutSecondary setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _layoutSecondary;
}

-(UICollectionView *)collectionViewPrimary{
    if (!_collectionViewPrimary) {
        _collectionViewPrimary = [[UICollectionView alloc] initWithFrame:CGRectMake(60, kSecondaryCollectionViewHeight, self.width, kPrimaryCollectionViewHeight) collectionViewLayout:self.layoutPrimary];
        _collectionViewPrimary.backgroundColor = [UIColor clearColor];
        [_collectionViewPrimary registerClass:[PTStaticStickerPickerCell class] forCellWithReuseIdentifier:PTStaticStickerPickerPrimaryCellID];
        _collectionViewPrimary.delegate = self;
        _collectionViewPrimary.dataSource = self;
   
    }
    return _collectionViewPrimary;
}

-(UICollectionView *)collectionViewSecondary{
    if (!_collectionViewSecondary) {
        _collectionViewSecondary = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, kSecondaryCollectionViewHeight) collectionViewLayout:self.layoutSecondary];
        _collectionViewSecondary.backgroundColor = [UIColor clearColor];
        [_collectionViewSecondary registerClass:[PTStaticStickerPickerCell class] forCellWithReuseIdentifier:PTStaticStickerPickerSecondaryCellID];
        _collectionViewSecondary.delegate = self;
        _collectionViewSecondary.dataSource = self;
  
    }
    return _collectionViewSecondary;
}

-(UIButton *)dismissButton{
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kSecondaryCollectionViewHeight, 60, kPrimaryCollectionViewHeight)];
        [_dismissButton setImage:[UIImage imageNamed:@"btn_spread_down"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissMe) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

-(NSMutableArray *)stickerIconPrimaryList{
    if (!_stickerIconPrimaryList) {
        _stickerIconPrimaryList = [[NSMutableArray alloc] init];
    }
    return _stickerIconPrimaryList;
}

-(NSMutableArray *)stickerFilePathArray{
    if (!_stickerFilePathArray) {
        _stickerFilePathArray = [[NSMutableArray alloc] init];
    }
    return _stickerFilePathArray;
}

@end
