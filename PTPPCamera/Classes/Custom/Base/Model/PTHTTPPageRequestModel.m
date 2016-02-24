//
//  PTHTTPPageRequestModel.m
//  kidsPlay
//
//  Created by so on 15/9/14.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "PTHTTPPageRequestModel.h"
#import "NSObject+SOObject.h"
#import "AFHTTPRequestOperation+SOHTTPRequestOperation.h"

@implementation PTHTTPPageRequestModel

- (instancetype)initWithPageOffset:(NSUInteger)pageOffset {
    self = [super initWithPageOffset:pageOffset];
    if(self) {
        self.pageIndex = 1;
        self.totalPage = 1;
    }
    return (self);
}

#pragma mark - getter
- (AFHTTPRequestOperationManager *)requestOperationManager {
    AFHTTPRequestOperationManager *manager = [super requestOperationManager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:
                                                         @"application/json",
                                                         @"application/soap+xml",
                                                         @"text/html",
                                                         @"text/xml",
                                                         @"text/json",
                                                         @"text/javascript", nil];
    return (manager);
}
#pragma mark -

- (void)appendOtherParameters {
    [super appendOtherParameters];
    [self.parameters safeSetObject:[PTUtilTool getDeviceID] forKey:@"device_id"];
    [self.parameters safeSetObject:[PTUtilTool getDeviceName] forKey:@"device_name"];
    [self.parameters safeSetObject:PTPPAppID forKey:@"appid"];
}

#pragma mark - <SOHTTPPageModelProtocol>
- (void)cancelAllRequest {
    [super cancelAllRequest];
}

- (AFHTTPRequestOperation *)startLoad {
    [self appendOtherParameters];
    
    NSLog(@"%@\n%@",self.baseURLString,self.parameters);
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:self.parameters];
    [mutableParameters setObject:[@(self.pageIndex) stringValue] forKey:_KEY_SOHTTP_PAGEINDEX];
    
    AFHTTPRequestOperation *operation = [super startLoad];
    [operation setPageOffset:self.pageOffset];
    [operation setPageIndex:self.pageIndex];
    return (operation);
}

- (AFHTTPRequestOperation *)reloadData {
    self.pageIndex = 1;
    return ([self startLoad]);
}

- (AFHTTPRequestOperation *)loadDataAtPageIndex:(NSUInteger)pageIndex {
    self.pageIndex = pageIndex;
    return ([self startLoad]);
}

- (void)request:(AFHTTPRequestOperation *)request didReceived:(id)responseObject {
    self.pageIndex = ([request pageIndex] + 1);
    NSError * error;
    responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
    if(self.delegate && [self.delegate respondsToSelector:@selector(model:didReceivedData:userInfo:)]) {
        [self.delegate model:self didReceivedData:responseObject userInfo:nil];
    }
}
#pragma mark -

@end
