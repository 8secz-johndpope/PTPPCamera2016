//
//  PTHTTPRequestModel.m
//  kidsPlay
//
//  Created by so on 15/9/14.
//  Copyright (c) 2015年 so. All rights reserved.
//

#import "PTHTTPRequestModel.h"

@implementation PTHTTPRequestModel

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

#pragma mark - <SOBaseModelProtocol>
- (AFHTTPRequestOperation *)startLoad {
    [self appendOtherParameters];
    AFHTTPRequestOperation *operation = [super startLoad];
    return (operation);
}
#pragma mark -

@end
