//
//  PTDebugTextView.h
//  PTRequestDebugManager
//
//  Created by so on 15/12/31.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTDebugTextView : UIView
@property (strong, nonatomic, readonly) UITextView *textView;
@property (strong, nonatomic, readonly) UIButton *closeButton;
@property (copy, nonatomic) void(^closeBlock)(void);
@end
