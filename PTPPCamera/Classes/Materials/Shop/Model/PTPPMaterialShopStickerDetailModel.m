//
//  PTPPMaterialShopStickerDetailModel.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 24/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPMaterialShopStickerDetailModel.h"
#import "PTPPMaterialShopStickerDetailItem.h"

@implementation PTPPMaterialShopStickerDetailModel

+ (instancetype)shareModel {
    static PTPPMaterialShopStickerDetailModel *_model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _model = [[PTPPMaterialShopStickerDetailModel alloc] init];
    });
    return (_model);
}

- (instancetype)init {
    self = [super init];
    if(self) {
        self.baseURLString = [NSString stringWithFormat:@"%@%@",PTPP_BASE_URL,API_MATERIAL_DETAILS];
        self.method = SOHTTPRequestMethodGET;
    }
    return (self);
}

- (void)appendOtherParameters {
    [super appendOtherParameters];
    [self.parameters safeSetObject:self.materialType forKey:@"type"];
    [self.parameters safeSetObject:self.packageID forKey:@"material_id"];
}

- (void)parseResponseData:(NSDictionary *)data {
    
    PTPPMaterialShopStickerDetailItem *detailItem = [PTPPMaterialShopStickerDetailItem itemWithDict:data];

    if(self.delegate && [self.delegate respondsToSelector:@selector(model:didReceivedData:userInfo:)]) {
        [self.delegate model:self didReceivedData:detailItem userInfo:nil];
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
    //返回的数组
    NSDictionary *data = [responseObject safeObjectForKey:KEY_PTDEFAULT_DATA];
    
    //请求成功,把数据缓存到本地
    [self cacheObject:data atDisk:YES];
    
    [self parseResponseData:data];
}

- (void)request:(AFHTTPRequestOperation *)request didFailed:(NSError *)error {
    //请求失败,从本地缓存取出数据
    NSDictionary *dict = [self cachedObjectAtDisk:YES];
    if(dict && [dict isKindOfClass:[NSDictionary class]]){
        [self parseResponseData:dict];
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(model:didFailedInfo:error:)]) {
        [self.delegate model:self didFailedInfo:nil error:error];
    }
}


@end
