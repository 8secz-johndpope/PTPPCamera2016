//
//  PTNavigationController.m
//  PTLatitude
//
//  Created by so on 15/11/26.
//  Copyright (c) 2015年 PT. All rights reserved.
//

#import "PTNavigationController.h"
#import "PTBaseViewController.h"

@interface PTNavigationController ()

@end

@implementation PTNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if(!self.viewControllers || self.viewControllers.count <= 1 || !viewController.navigationItem) {
        return;
    }
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 20)];
    [backButton setImage:[UIImage imageNamed:@"btn_20_back_p_nor"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_20_back_p_sel"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:(UIView *)backButton];
    [viewController.navigationItem setLeftBarButtonItem:item animated:animated];
}

- (void)backButtonTouched:(id)sender {
    PTBaseViewController *topViewController = (PTBaseViewController *)[self topViewController];
    if(topViewController && [topViewController respondsToSelector:@selector(leftItemTouched:)]) {
        [topViewController leftItemTouched:nil];
        return;
    }
    [self popViewControllerAnimated:YES];
}



#pragma mark - Orientations
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (self.supportPortraitOnly) {
        return UIInterfaceOrientationPortrait == toInterfaceOrientation;
    }else {
        return [self.topViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.supportPortraitOnly) {
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return [self.topViewController supportedInterfaceOrientations];
    }
}

// New Autorotation support.
- (BOOL)shouldAutorotate {
    if (self.supportPortraitOnly) {
        return NO;
    }else{
        return [self.topViewController shouldAutorotate];
    }
}
*/
#pragma mark -

@end
