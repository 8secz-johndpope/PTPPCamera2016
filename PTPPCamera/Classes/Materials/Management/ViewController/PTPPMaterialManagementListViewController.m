//
//  PTPPMaterialManagementViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialManagementListViewController.h"
#import "PTPPMaterialManagementEditViewController.h"
#import "PTPPLocalFileManager.h"
#import "PTMacro.h"

@interface PTPPMaterialManagementListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *staticStickerArray;
@property (nonatomic, strong) NSArray *ARStickerArray;
@property (nonatomic, strong) NSArray *jigsawTemplateArray;
@end

@implementation PTPPMaterialManagementListViewController

#pragma mark - Life Cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self disableAdjustsScrollView];
    [self cleanEdgesForExtendedLayout];
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xff5a5d)];
    [self setTitle:@"素材管理" color:[UIColor whiteColor] font:[UIFont systemFontOfSize:18] selector:nil];
    [self showLeftItemWithImage:[UIImage imageNamed:@"back_white"] selector:@selector(goBack) animation:YES];

    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.staticStickerArray = nil;
    self.ARStickerArray = nil;
    self.jigsawTemplateArray = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate/UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"贴纸";
            NSString *folderSize = [PTPPLocalFileManager folderSize:[PTPPLocalFileManager getRootFolderPathForStaitcStickers]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu套(共%@)",(unsigned long)self.staticStickerArray.count,folderSize];
            break;
        }
        case 1:{
            cell.textLabel.text = @"动态贴图";
            NSString *folderSize = [PTPPLocalFileManager folderSize:[PTPPLocalFileManager getRootFolderPathForARStickers]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu张(共%@)",(unsigned long)self.ARStickerArray.count,folderSize];
            break;
        }
        case 2:{
            cell.textLabel.text = @"拼图模版";
            NSString *folderSize = [PTPPLocalFileManager folderSize:[PTPPLocalFileManager getRootFolderPathForJigsawTemplate]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu张(共%@)",(unsigned long)self.jigsawTemplateArray.count,folderSize];
            break;
        }
        default:
            break;
    }
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIView *splitter = [[UIView alloc] initWithFrame:CGRectMake(20, 60, Screenwidth, 0.5)];
    splitter.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [cell addSubview:splitter];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger count;
    switch (indexPath.row) {
        case 0:{
            count = self.staticStickerArray.count;
            break;
        }
        case 1:{
            count = self.ARStickerArray.count;
            break;
        }
        case 2:{
            count = self.jigsawTemplateArray.count;
            break;
        }
        default:
            break;
    }
    if (count == 0) {
        return;
    }
    
    PTPPMaterialManagementEditViewController *libraryManagementVC = [[PTPPMaterialManagementEditViewController alloc] init];
    libraryManagementVC.activeSection = indexPath.row;
    [self.navigationController pushViewController:libraryManagementVC animated:YES];
}

#pragma mark - Touch Events
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screenwidth, Screenheight) style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
        _tableView.layer.borderWidth = 0.5;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSArray *)staticStickerArray{
    if (!_staticStickerArray) {
        _staticStickerArray = [PTPPLocalFileManager getListOfFilePathAtDirectory:[PTPPLocalFileManager getRootFolderPathForStaitcStickers]];
    }
    return _staticStickerArray;
}

-(NSArray *)ARStickerArray{
    if (!_ARStickerArray) {
        _ARStickerArray = [PTPPLocalFileManager getListOfFilePathAtDirectory:[PTPPLocalFileManager getRootFolderPathForARStickers]];
    }
    return _ARStickerArray;
}

-(NSArray *)jigsawTemplateArray{
    if (!_jigsawTemplateArray) {
        _jigsawTemplateArray = [PTPPLocalFileManager getListOfFilePathAtDirectory:[PTPPLocalFileManager getRootFolderPathForJigsawTemplate]];
    }
    return _jigsawTemplateArray;
}

@end
