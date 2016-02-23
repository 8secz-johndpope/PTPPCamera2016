//
//  PTPPMaterialStickerDetailViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 15/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialStickerDetailViewController.h"
#import "PTPPMaterialStickerDetailCell.h"
#import "PTPPMaterialStickerDetailHeaderView.h"
#import "SOKit.h"
#import "PTMacro.h"
#define kCollectionViewEdgePadding 10
#define kCellSpacing 5

@interface PTPPMaterialStickerDetailViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

static NSString *PTPPMaterialStickerDetailCellID = @"PTPPMaterialStickerDetailCellID";
static NSString *PTPPMaterialStickerDetailHeaderViewID = @"PTPPMaterialStickerDetailHeaderViewID";
@implementation PTPPMaterialStickerDetailViewController

#pragma mark - Life Cycles
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 15;
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
    NSString *imageURL = @"http://pic25.nipic.com/20121128/2457331_222533059344_2.jpg";
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialStickerDetailCellID forIndexPath:indexPath];
    [((PTPPMaterialStickerDetailCell *)cell) setAttributeWithImageURL:imageURL];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PTPPMaterialStickerDetailHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PTPPMaterialStickerDetailHeaderViewID forIndexPath:indexPath];
        [headerView setAttributeWithBannerImgURL:@"http://pic25.nipic.com/20121128/2457331_222533059344_2.jpg" stickerName:@"这里显示贴纸包的名称" stickerDetail:@"这里显示的是这个贴纸包的简介最多不会超过两行，这里显示的是这个贴纸包的简介最多不会超过两行。" isDownloaded:NO];
        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.width, [PTPPMaterialStickerDetailHeaderView getHeightWithStickerDetailText:@"这里显示的是这个贴纸包的简介最多不会超过两行，这里显示的是这个贴纸包的简介最多不会超过两行。" constraintWidth:collectionView.width-20]);
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
