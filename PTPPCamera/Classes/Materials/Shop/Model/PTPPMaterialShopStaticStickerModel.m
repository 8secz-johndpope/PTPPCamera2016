//
//  PTPPMaterialShopStickerModel.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 24/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPMaterialShopStaticStickerModel.h"
#import "PTPPMaterialShopStickerItem.h"

@implementation PTPPMaterialShopStaticStickerModel

+ (instancetype)shareModel {
    static PTPPMaterialShopStaticStickerModel *_model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _model = [[PTPPMaterialShopStaticStickerModel alloc] init];
    });
    return (_model);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.baseURLString = [NSString stringWithFormat:@"%@%@",PTPP_BASE_URL,API_MATERIAL_LIST];
        self.method = SOHTTPRequestMethodGET;
    }
    return (self);
}

- (void)appendOtherParameters {
    [super appendOtherParameters];
    [self.parameters safeSetObject:self.materialType forKey:@"type"];
}

- (void)parseResponseData:(NSArray *)data {
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *dict in data){
        PTPPMaterialShopStickerItem *myOrderSummaryItem = [PTPPMaterialShopStickerItem itemWithDict:dict];
        [items addObject:myOrderSummaryItem];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(model:didReceivedData:userInfo:)]) {
        [self.delegate model:self didReceivedData:items userInfo:nil];
    }
}

- (void)request:(AFHTTPRequestOperation *)request didReceived:(id)responseObject {

    if(!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(model:didFailedInfo:error:)]) {
            [self.delegate model:self didFailedInfo:responseObject error:nil];
        }
        return;
    }
    NSInteger status = [[responseObject safeNumberForKey:KEY_PTDEFAULT_STATUS] integerValue];
    if(status != 200) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(model:didFailedInfo:error:)]) {
            [self.delegate model:self didFailedInfo:responseObject error:nil];
        }
        return;
    }
    self.pageIndex = ([request pageIndex] + 1);
    //返回的数组
    NSArray *data = [responseObject safeObjectForKey:KEY_PTDEFAULT_DATA];
    
    //请求成功,把数据缓存到本地
    [self cacheObject:data atDisk:YES];
    
    [self parseResponseData:data];
}

- (void)request:(AFHTTPRequestOperation *)request didFailed:(NSError *)error {
    //请求失败,从本地缓存取出数据
    NSArray *arr = [self cachedObjectAtDisk:YES];
    if(arr && [arr isKindOfClass:[NSArray class]] && arr.count > 0) {
        [self parseResponseData:arr];
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(model:didFailedInfo:error:)]) {
        [self.delegate model:self didFailedInfo:nil error:error];
    }
}



@end
