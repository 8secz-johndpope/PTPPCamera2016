//
//  PTDebugManager.m
//  PTRequestDebugManager
//
//  Created by so on 15/12/31.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTDebugManager.h"
#import "PTDebugTextView.h"
#import "AFHTTPRequestOperation.h"

static NSUInteger const PTDebugLogMaxCount      = 10;   //最大记录10条

@interface PTDebugManager () {
    NSMutableArray *_logs;
}
@property (strong, nonatomic, readonly) PTDebugTextView *textView;
@end

@implementation PTDebugManager
@synthesize textView = _textView;

+ (void)show {
    [[self manager] show];
}

+ (void)dismiss {
    [[self manager] dismiss];
}

+ (instancetype)manager {
    static PTDebugManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PTDebugManager alloc] init];
    });
    return (_manager);
}

- (void)dealloc {
    [self removeNotifications];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _logs = [[NSMutableArray alloc] init];
        [self addNotifications];
    }
    return (self);
}

#pragma mark - getter
- (PTDebugTextView *)textView {
    if(!_textView) {
        _textView = [[PTDebugTextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _textView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
        __weak typeof(self) weak_self = self;
        _textView.closeBlock = ^(void){
            [weak_self dismiss];
        };
    }
    return (_textView);
}
#pragma mark -

#pragma mark - actions
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(!window) {
        return;
    }
    self.textView.frame = window.bounds;
    [window addSubview:self.textView];
}

- (void)dismiss {
    if(!self.textView.superview) {
        return;
    }
    [self.textView removeFromSuperview];
}

- (void)addLog:(NSAttributedString *)log {
    if(!log) {
        return;
    }
    [_logs addObject:log];
    if([_logs count] > PTDebugLogMaxCount) {
        [_logs removeObjectAtIndex:0];
    }
    NSMutableAttributedString *logAttributedString = [[NSMutableAttributedString alloc] init];
    for(NSInteger index = _logs.count - 1; index >= 0; index --) {
        NSAttributedString *att = [_logs objectAtIndex:index];
        [logAttributedString appendAttributedString:att];
    }
    self.textView.textView.attributedText = logAttributedString;
}
#pragma mark -

#pragma mark - notification
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AFNetworkingOperationDidStart:) name:AFNetworkingOperationDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AFNetworkingOperationDidFinish:) name:AFNetworkingOperationDidFinishNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingOperationDidStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingOperationDidFinishNotification object:nil];
}

- (void)AFNetworkingOperationDidStart:(NSNotification *)notfication {
    AFHTTPRequestOperation *operation = notfication.object;
    if(!operation || ![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
        return;
    }
    if(!operation.request) {
        return;
    }
    NSURL *url = operation.request.URL;
    NSString *HTTPMethod = operation.request.HTTPMethod;
    NSString *requestLog = [NSString stringWithFormat:@"\n请求:\nURL:%@, \nMethod:%@\n", url, HTTPMethod];
    [self addLog:[[NSAttributedString alloc] initWithString:requestLog attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor blueColor]}]];
}

- (void)AFNetworkingOperationDidFinish:(NSNotification *)notfication {
    AFHTTPRequestOperation *operation = notfication.object;
    if(!operation || ![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
        return;
    }
    NSURL *url = operation.request.URL;
    NSString *HTTPMethod = operation.request.HTTPMethod;
    NSString *responseString = operation.responseString;
    NSString *responseLog = [NSString stringWithFormat:@"\n返回:\nURL:%@, \nMethod:%@, \nResponse:%@\n", url, HTTPMethod, responseString];
    UIColor *color = (1 == operation.response.statusCode / 200) ? [UIColor greenColor] : [UIColor redColor];
    [self addLog:[[NSAttributedString alloc] initWithString:responseLog attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14], NSForegroundColorAttributeName:color}]];
}
#pragma mark -

@end
