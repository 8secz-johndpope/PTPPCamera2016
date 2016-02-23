//
//  PTPPMaterialShopViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialShopViewController.h"
#import "PTPPMaterialManagementViewController.h"
#import "PTPPMaterialStickerDetailViewController.h"
#import "PTPPMaterialShopStickerItemCell.h"
#import "PTPPMaterialShopARStickerItemCell.h"
#import "PTPPMaterialShopJigsawItemCell.h"
#import "PTCustomMenuSliderView.h"
#import "PTPPMaterialManagementBottomView.h"
#import "PTMacro.h"

#define kCollectionViewEdgePadding 10
#define kCellSpacing 5

@interface PTPPMaterialShopViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PTCustomMenuSliderViewDelegate, PTPPMaterialManagementBottomViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) PTCustomMenuSliderView *sliderView;
@property (nonatomic, strong) PTPPMaterialManagementBottomView *bottomView;

@property (nonatomic, assign) BOOL selectionMode;
@end

static NSString *PTPPMaterialShopStickerItemCellID = @"PTPPMaterialShopStickerItemCellID";
static NSString *PTPPMaterialShoptARStickerItemCellID = @"PTPPMaterialShoptARStickerItemCellID";
static NSString *PTPPMaterialShopJigsawItemCellID = @"PTPPMaterialShopJigsawItemCellID";
@implementation PTPPMaterialShopViewController

#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    [self disableAdjustsScrollView];
    [self cleanEdgesForExtendedLayout];

    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xff5a5d)];
    [self setTitle:@"素材中心" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] selector:nil];
    if (self.managementMode) {
        [self showRightItemWithText:@"管理" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] selector:@selector(toggleEditMode) animation:NO];
    }else{
        [self showRightItemWithText:@"素材管理" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] selector:@selector(toggleMaterialManagement) animation:NO];
    }
    
    [self showLeftItemWithImage:[UIImage imageNamed:@"back_white"] selector:@selector(goBack) animation:YES];
    [self.sliderView setAttributeWithItems:@[@"贴纸",@"动态贴图",@"拼图模版"] buttonWidth:Screenwidth/3 themeColor:UIColorFromRGB(0xff5a5d) idleColor:[UIColor grayColor] trackerWidth:20];
    if (!self.managementMode) {
        [self.view addSubview:self.sliderView];
        self.collectionView.frame = CGRectMake(0, self.sliderView.bottom, self.collectionView.width, self.collectionView.height);
    }else{
        self.collectionView.frame = CGRectMake(0, 0, Screenwidth, Screenheight-HEIGHT_NAV);
    }
    
    [self.view addSubview:self.collectionView];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Touch events
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toggleMaterialManagement{
    PTPPMaterialManagementViewController *manageVC = [[PTPPMaterialManagementViewController alloc] init];
    [self.navigationController pushViewController:manageVC animated:YES];
}

-(void)toggleEditMode{
    if (!self.selectionMode) {
        [self showRightItemWithText:@"取消" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] selector:@selector(toggleEditMode) animation:NO];
        [self.view addSubview:self.bottomView];
    }else{
        [self showRightItemWithText:@"管理" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] selector:@selector(toggleEditMode) animation:NO];
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
    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    NSString *imageURL = @"http://pic25.nipic.com/20121128/2457331_222533059344_2.jpg";
    switch (self.activeSection) {
        case 0:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopStickerItemCellID forIndexPath:indexPath];
            if (self.managementMode) {
                [((PTPPMaterialShopStickerItemCell *)cell)  setAttributeWithImageURL:imageURL stickerName:@"贴纸的名称" stickerCount:@"13" binarySize:@"1.2MB" editStatus:PTPPMaterialEditStatusItemDeselected isNew:NO];
            }else{
                [((PTPPMaterialShopStickerItemCell *)cell) setAttributeWithImageURL:imageURL stickerName:@"贴纸的名称" stickerCount:@"13" binarySize:@"1.2MB" downloadStatus:PTPPMaterialDownloadStatusReady isNew:YES];
            }
            ((PTPPMaterialShopStickerItemCell *)cell).selectionMode = self.selectionMode;
            break;
        case 1:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShoptARStickerItemCellID forIndexPath:indexPath];
            if (self.managementMode) {
                [((PTPPMaterialShopARStickerItemCell *)cell) setAttributeWithImageURL:imageURL editStatus:PTPPMaterialEditStatusItemDeselected isNew:NO];
            }else{
                [((PTPPMaterialShopARStickerItemCell *)cell) setAttributeWithImageURL:imageURL downloadStatus:PTPPMaterialDownloadStatusReady isNew:YES];
            }
            ((PTPPMaterialShopARStickerItemCell *)cell).selectionMode = self.selectionMode;
            break;
        case 2:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopJigsawItemCellID forIndexPath:indexPath];
            if (self.managementMode) {
                [((PTPPMaterialShopJigsawItemCell *)cell) setAttributeWithImageURL:imageURL editStatus:PTPPMaterialEditStatusItemDeselected isNew:YES];
            }else{
                [((PTPPMaterialShopJigsawItemCell *)cell) setAttributeWithImageURL:imageURL downloadStatus:PTPPMaterialDownloadStatusReady isNew:YES];
            }
            ((PTPPMaterialShopJigsawItemCell *)cell).selectionMode = self.selectionMode;
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.activeSection == 1) {
        PTPPMaterialStickerDetailViewController *stickerDetailVC = [[PTPPMaterialStickerDetailViewController alloc] init];
        [self.navigationController pushViewController:stickerDetailVC animated:YES];
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
    [self.collectionView reloadData];
}

#pragma mark - PTPPMaterialManagementBottomViewDelegate
-(void)didToggleSelectAll:(PTPPMaterialManagementBottomView *)bottomView{
    
}

-(void)didToggleDelete:(PTPPMaterialManagementBottomView *)bottomView{

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
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, Screenheight-HEIGHT_NAV*2) collectionViewLayout:self.layout];
        [_collectionView registerClass:[PTPPMaterialShopStickerItemCell class] forCellWithReuseIdentifier:PTPPMaterialShopStickerItemCellID];
        [_collectionView registerClass:[PTPPMaterialShopARStickerItemCell class] forCellWithReuseIdentifier:PTPPMaterialShoptARStickerItemCellID];
        [_collectionView registerClass:[PTPPMaterialShopJigsawItemCell class] forCellWithReuseIdentifier:PTPPMaterialShopJigsawItemCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        if (self.managementMode) {
             _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10+HEIGHT_NAV, 0);
        }else{
             _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        }
       

    }
    return _collectionView;
}

@end
