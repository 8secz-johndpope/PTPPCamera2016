//
//  PTBaseTableViewController.h
//  kidsPlay
//
//  Created by so on 15/9/24.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "PTBaseViewController.h"
#import "UITableView+SOAdditions.h"
#import "UIScrollView+EmptyDataSet.h"
#import "SOGlobal.h"

@interface PTBaseTableViewController : PTBaseViewController <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    UITableView *_tableView;
}
@property (strong, nonatomic, readonly) UITableView *tableView;
@end
