//
//  PTPPMaterialShopViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialShopViewController.h"
#import "PTPPMaterialManagementListViewController.h"
#import "PTPPMaterialStickerDetailViewController.h"
#import "PTPPMaterialShopStickerItemCell.h"
#import "PTPPMaterialShopARStickerItemCell.h"
#import "PTPPMaterialShopJigsawItemCell.h"
#import "PTCustomMenuSliderView.h"
#import "PTPPMaterialManagementBottomView.h"
#import "PTPPMaterialShopStickerItem.h"
#import "PTPPMaterialShopStickerModel.h"

#define kCollectionViewEdgePadding 10
#define kCellSpacing 5

@interface PTPPMaterialShopViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PTCustomMenuSliderViewDelegate, PTPPMaterialManagementBottomViewDelegate, SOModelDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) PTCustomMenuSliderView *sliderView;
@property (nonatomic, strong) PTPPMaterialManagementBottomView *bottomView;

@property (nonatomic, strong) PTPPMaterialShopStickerItem *staticStickerItem;
@property (nonatomic, strong) PTPPMaterialShopStickerModel *staticStickerModel;
@property (nonatomic, strong) NSMutableArray *staticStickerArray;
@property (nonatomic, strong) PTPPMaterialShopStickerItem *ARStickerItem;
@property (nonatomic, strong) PTPPMaterialShopStickerModel *ARStickerModel;
@property (nonatomic, strong) NSMutableArray *ARStickerArray;
@property (nonatomic, strong) PTPPMaterialShopStickerItem *jigsawTemplateItem;
@property (nonatomic, strong) PTPPMaterialShopStickerModel *jigsawTemplateModel;
@property (nonatomic, strong) NSMutableArray *jigsawTemplateArray;

@property (nonatomic, assign) BOOL selectionMode;
@end

static NSString *PTPPMaterialShopStickerItemCellID = @"PTPPMaterialShopStickerItemCellID";
static NSString *PTPPMaterialShoptARStickerItemCellID = @"PTPPMaterialShoptARStickerItemCellID";
static NSString *PTPPMaterialShopJigsawItemCellID = @"PTPPMaterialShopJigsawItemCellID";
@implementation PTPPMaterialShopViewController

#pragma mark - Life Cycles
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _staticStickerModel = [PTPPMaterialShopStickerModel shareModel];
        [_staticStickerModel setDelegate:self];
        _staticStickerArray = [[NSMutableArray alloc] init];
        
        _ARStickerModel = [PTPPMaterialShopStickerModel shareModel];
        [_ARStickerModel setDelegate:self];
        _ARStickerArray = [[NSMutableArray alloc] init];
        
        _jigsawTemplateModel= [PTPPMaterialShopStickerModel shareModel];
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
    [self setTitle:@"素材中心" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] selector:nil];
    [self showRightItemWithText:@"素材管理" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] selector:@selector(toggleMaterialManagement) animation:NO];
    [self showLeftItemWithImage:[UIImage imageNamed:@"back_white"] selector:@selector(goBack) animation:YES];
    [self.sliderView setAttributeWithItems:@[@"贴纸",@"动态贴图",@"拼图模版"] buttonWidth:Screenwidth/3 themeColor:UIColorFromRGB(0xff5a5d) idleColor:[UIColor grayColor] trackerWidth:20];
    [self.view addSubview:self.sliderView];
    self.collectionView.frame = CGRectMake(0, self.sliderView.bottom, self.collectionView.width, self.collectionView.height);
    [self.view addSubview:self.collectionView];
    [self sliderView:self.sliderView didSelecteAtIndex:self.activeSection];
    
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
    PTPPMaterialManagementListViewController *manageVC = [[PTPPMaterialManagementListViewController alloc] init];
    [self.navigationController pushViewController:manageVC animated:YES];
}

#pragma mark - Private Methods
-(void)loadNewStaticStickerData{
    [self.staticStickerArray removeAllObjects];
    [self.staticStickerModel cancelAllRequest];
    self.staticStickerModel.materialType = @"sticker_pic";
    [self.staticStickerModel reloadData];
    [SVProgressHUD showWithStatus:@"加载中"];
}

-(void)loadMoreStaticStickerData{
    [self.staticStickerModel loadDataAtPageIndex:self.staticStickerModel.pageIndex];
}

-(void)loadNewARStickerData{
    [self.ARStickerArray removeAllObjects];
    [self.ARStickerModel cancelAllRequest];
    self.ARStickerModel.materialType = @"dynamic_pic";
    [self.ARStickerModel reloadData];
    [SVProgressHUD showWithStatus:@"加载中"];
}

-(void)loadMoreARStickerData{
    [self.ARStickerModel loadDataAtPageIndex:self.ARStickerModel.pageIndex];
}

-(void)loadNewJigsawTemplateData{
    [self.jigsawTemplateArray removeAllObjects];
    [self.jigsawTemplateModel cancelAllRequest];
    self.jigsawTemplateModel.materialType = @"template_pic";
    [self.jigsawTemplateModel reloadData];
    [SVProgressHUD showWithStatus:@"加载中"];
}

-(void)loadMoreJigsawTemplateData{
    [self.jigsawTemplateModel loadDataAtPageIndex:self.jigsawTemplateModel.pageIndex];
}

#pragma mark - UICollectionViewDataSource / UICollectionViewDelegateFlowLayout
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (self.activeSection) {
        case 0:
            return self.staticStickerArray.count;
            break;
        case 1:
            return self.ARStickerArray.count;
            break;
        case 2:
            return self.jigsawTemplateArray.count;
            break;
        default:
            break;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;

    switch (self.activeSection) {
        case 0:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopStickerItemCellID forIndexPath:indexPath];
            PTPPMaterialShopStickerItem *staticStickerItem = [self.staticStickerArray safeObjectAtIndex:indexPath.row];
            [((PTPPMaterialShopStickerItemCell *)cell) setAttributeWithImageURL:staticStickerItem.coverPic stickerName:staticStickerItem.packageName stickerCount:staticStickerItem.totalNum binarySize:staticStickerItem.packageSize downloadStatus:PTPPMaterialDownloadStatusReady isNew:YES];

            break;
        }
        case 1:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShoptARStickerItemCellID forIndexPath:indexPath];
            PTPPMaterialShopStickerItem *ARStickerItem = [self.ARStickerArray safeObjectAtIndex:indexPath.row];
            [((PTPPMaterialShopARStickerItemCell *)cell) setAttributeWithImageURL:ARStickerItem.coverPic downloadStatus:PTPPMaterialDownloadStatusReady isNew:YES];
            break;
        }
        case 2:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:PTPPMaterialShopJigsawItemCellID forIndexPath:indexPath];
            PTPPMaterialShopStickerItem *jigsawTemplateItem = [self.jigsawTemplateArray safeObjectAtIndex:indexPath.row];
            [((PTPPMaterialShopJigsawItemCell *)cell) setAttributeWithImageURL:jigsawTemplateItem.coverPic downloadStatus:PTPPMaterialDownloadStatusReady isNew:YES];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.activeSection == 0) {
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
    [self.collectionView reloadData];
}

#pragma mark - PTPPMaterialManagementBottomViewDelegate
-(void)didToggleSelectAll:(PTPPMaterialManagementBottomView *)bottomView{
    
}

-(void)didToggleDelete:(PTPPMaterialManagementBottomView *)bottomView{

}

#pragma mark - <SOModelDelegate>

-(void)model:(SOBaseModel *)model didReceivedData:(id)data userInfo:(id)info{
    [SVProgressHUD dismiss];
    if ([[(PTPPMaterialShopStickerModel *)model materialType] isEqualToString:@"sticker_pic"]) {
        NSLog(@"Success");
        if(!data || ![data isKindOfClass:[NSArray class]] || [data count] < self.staticStickerModel.pageOffset) {
            
        } else {

        }
        [self.staticStickerArray addObjectsFromArray:data];
        [self.collectionView reloadData];
    }
    if ([[(PTPPMaterialShopStickerModel *)model materialType] isEqualToString:@"dynamic_pic"]) {
        NSLog(@"Success");
        if(!data || ![data isKindOfClass:[NSArray class]] || [data count] < self.ARStickerModel.pageOffset) {
            
        } else {
            
        }
        [self.ARStickerArray addObjectsFromArray:data];
        [self.collectionView reloadData];
    }
    if ([[(PTPPMaterialShopStickerModel *)model materialType] isEqualToString:@"template_pic"]) {
        NSLog(@"Success");
        if(!data || ![data isKindOfClass:[NSArray class]] || [data count] < self.jigsawTemplateModel.pageOffset) {
            
        } else {
            
        }
        [self.jigsawTemplateArray addObjectsFromArray:data];
        [self.collectionView reloadData];
    }
}

-(void)model:(SOBaseModel *)model didFailedInfo:(id)info error:(id)error{
    [SVProgressHUD dismiss];
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
        _collectionView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    }
    return _collectionView;
}

@end
