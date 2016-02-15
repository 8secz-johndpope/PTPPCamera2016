//
//  PTBaseTableViewController.m
//  kidsPlay
//
//  Created by so on 15/9/24.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "PTBaseTableViewController.h"

@interface PTBaseTableViewController () {
    NSLock *_lock;
}
@end

@implementation PTBaseTableViewController
@synthesize tableView = _tableView;

#pragma mark - lifeCycle
- (void)dealloc {
    SORELEASE(_tableView);
    SOSUPERDEALLOC();
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _tableView = nil;
        _lock = [[NSLock alloc] init];
    }
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - Overwrite
-(BOOL)prefersStatusBarHidden {
    return NO;
}
#pragma mark -

#pragma mark - actions
- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = CGRectGetHeight(_keyboardBenginFrame);
    [self.tableView setContentInset:insets];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = 0;
    [self.tableView setContentInset:insets];
}
#pragma mark -

#pragma mark - getter
- (UITableView *)tableView {
    if(!_tableView) {
        [_lock lock];
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView clearExtendCellLine];
        [_lock unlock];
    }
    return (_tableView);
}
#pragma mark -

//#pragma mark - <UIScrollViewDelegate>
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.tableView && self.tableView.header) {
//        /*   解决正在加载时tableviewheader停留位置受contentInset的影响，往上滑动时header停在cell的下方了   */
//        CGFloat cty = scrollView.contentOffset.y;
//        if([self.tableView.header isRefreshing] && cty > -MJRefreshHeaderHeight) {
//            UIEdgeInsets insets = scrollView.contentInset;
//            insets.top = MAX(0, MIN(MJRefreshHeaderHeight, -cty));
//            scrollView.contentInset = insets;
//        }
//    }
//}
//#pragma mark -

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ([[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]);
}
#pragma mark -

#pragma mark - DZNEmptyDataSetSource Methods
//主提示标题
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"网络不给力,点击屏幕重试"
                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0],
                                                        NSForegroundColorAttributeName:UIColorFromRGB(0x959595)}];
}

//详细描述、子标题
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return nil;
}

//占位图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"img_default_pinwheel"];
}

//底部 按钮 样式
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}

//底部按钮背景样式
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return nil;
}

//表格整体的背景颜色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return (UIColorFromRGB(0xebebeb));
}

//调整 提示在内部的位置
- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView {
    return CGPointMake(0, -50.0);
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 40.0;
}
#pragma mark -

#pragma mark - DZNEmptyDataSetDelegate Methods
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView {
    
}
#pragma mark -

#pragma mark - <SOViewControllerProtocol>
- (void)setParameters:(id)parameters {
    [super setParameters:parameters];
    
}
#pragma mark -

@end
