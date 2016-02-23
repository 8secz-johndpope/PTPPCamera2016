//
//  PTPPMaterialManagementViewController.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 14/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPMaterialManagementViewController.h"
#import "PTPPMaterialShopViewController.h"
#import "PTMacro.h"

@interface PTPPMaterialManagementViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PTPPMaterialManagementViewController

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
        case 0:
            cell.textLabel.text = @"贴纸";
            cell.detailTextLabel.text = @"2套(共2.4 MB)";
            break;
        case 1:
            cell.textLabel.text = @"动态贴图";
            cell.detailTextLabel.text = @"2张(共2.4 MB)";
            break;
        case 2:
            cell.textLabel.text = @"拼图模版";
            cell.detailTextLabel.text = @"2张(共2.4 MB)";
            break;
        default:
            break;
    }
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIView *splitter = [[UIView alloc] initWithFrame:CGRectMake(20, 60, Screenwidth, 0.5)];
    splitter.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [cell.contentView addSubview:splitter];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PTPPMaterialShopViewController *libraryManagementVC = [[PTPPMaterialShopViewController alloc] init];
    libraryManagementVC.managementMode = YES;
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

@end
