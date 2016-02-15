//
//  PTAPI.m
//  PTLatitude
//
//  Created by so on 15/11/27.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTAPI.h"

NSString * const _Nonnull PTLatitudeAppID           = @"1108";

NSString * const _Nonnull PTLatitudePlatformID      = @"9";

NSString * const _Nonnull PTLatitudeSecretKey       = @"c58908e3fa2647a2801fe5417cbcfd8f";

NSString * const _Nonnull PTAbsoluteURLString(NSString * _Nonnull baseURLString, NSString * _Nullable  relativeURLString) {
    return ([baseURLString stringByAppendingString:relativeURLString]);
}


NSString * const _Nonnull PTLatitudeDataSourceSecretKey     = @"d3159867d3525452773206e189ef6966";
NSString * const _Nonnull PTLatitudeDataSourceUpdateURL     = @"http://source.start.wang/client/resource/";


/***********************************************************************************/
/****************************         BaseURL        *******************************/

/**
 *  @brief  0:内网测试
 */
#if (PT_API_TYPE == 0)
NSString * const _Nonnull PTLatitudeBaiduMapKey     = @"Dm647YF56UMO4fqY2AdATFXG";
NSString * const _Nonnull PTLatitudeWxKey           = @"wx46c90751eea478fe";
NSTimeInterval PTLatitudeDebugMenuTimeInt           = 10;

NSString * const _Nonnull PTLatitudePassportServiceBaseURL      = @"https://account-api-dev.putao.com";

#warning todo 这里上架要修改
NSString * const _Nonnull PTLatitudeStoreServiceBaseURL     = @"http://api.store.test.putao.com";
//NSString * const _Nonnull PTLatitudeStoreServiceBaseURL     = @"http://api-store.putao.com";

NSString * const _Nonnull PTLatitudeUserServiceBaseURL = @"http://api.weidu.start.wang";
NSString * const _Nonnull PTLatitudeEventStarWangServiceBaseURL = @"http://api.event.start.wang";
NSString * const _Nonnull PTLatitudeH5ServiceBaseURL = @"http://static.uzu.wang/weidu_event";
NSString * const _Nonnull PTLatitudeUploadBaseURL           = @"http://upload.dev.putaocloud.com"; //图片服务器
//NSString * const _Nonnull PTLatitudeGetUploadImageBaseURL   = @"http://weidu.file.dev.putaocloud.com/file/";//获取图片接口
NSString * const _Nonnull PTLatitudeCreatorBaseURL            = @"http://api-bbs-ng-test.start.wang";

/**
 *  @brief  1.外网测试
 */
#elif (PT_API_TYPE == 1)
NSString * const _Nonnull PTLatitudeBaiduMapKey     = @"Dm647YF56UMO4fqY2AdATFXG";
NSString * const _Nonnull PTLatitudeWxKey           = @"wx46c90751eea478fe";

NSTimeInterval PTLatitudeDebugMenuTimeInt           = 10;
NSString * const _Nonnull PTLatitudePassportServiceBaseURL      = @"https://account-api.putao.com/";
NSString * const _Nonnull PTLatitudeStoreServiceBaseURL     = @"http://api-store.putao.com";
NSString * const _Nonnull PTLatitudeUserServiceBaseURL      = @"http://api-weidu.putao.com";
NSString * const _Nonnull PTLatitudeEventStarWangServiceBaseURL = @"http://api-event.putao.com";
NSString * const _Nonnull PTLatitudeH5ServiceBaseURL = @"http://static.putaocdn.com/weidu";
NSString * const _Nonnull PTLatitudeUploadBaseURL           = @"http://upload.putaocloud.com"; //图片服务器
//NSString * const _Nonnull PTLatitudeGetUploadImageBaseURL   = @"http://weidu.file.putaocloud.com/file/"; //获取图片接口
NSString * const _Nonnull PTLatitudeCreatorBaseURL            = @"http://api-bbs.putao.com";


/**
 *  @brief  2.发布AppStore
 */
#elif (PT_API_TYPE == 2)
NSString * const _Nonnull PTLatitudeBaiduMapKey     = @"VjYMh3eX9ymcYkX7g3RXivbA";
NSString * const _Nonnull PTLatitudeWxKey           = @"wx46c90751eea478fe";
NSTimeInterval PTLatitudeDebugMenuTimeInt           = 30;
NSString * const _Nonnull PTLatitudePassportServiceBaseURL      = @"https://account-api.putao.com/";
NSString * const _Nonnull PTLatitudeStoreServiceBaseURL     = @"http://api-store.putao.com";
NSString * const _Nonnull PTLatitudeUserServiceBaseURL      = @"http://api-weidu.putao.com";
NSString * const _Nonnull PTLatitudeEventStarWangServiceBaseURL = @"http://api-event.putao.com";
NSString * const _Nonnull PTLatitudeH5ServiceBaseURL = @"http://static.putaocdn.com/weidu";
NSString * const _Nonnull PTLatitudeUploadBaseURL           = @"http://upload.putaocloud.com"; //图片服务器
//NSString * const _Nonnull PTLatitudeGetUploadImageBaseURL   = @"http://weidu.file.putaocloud.com/file/";//获取图片接口
NSString * const _Nonnull PTLatitudeCreatorBaseURL            = @"http://api-bbs.putao.com";

#endif
/***********************************************************************************/



NSString * const _Nonnull PTLatitudePassportAppID               = @"1108";
NSString * const _Nonnull PTLatitudePassportAppSecretKey        = @"c58908e3fa2647a2801fe5417cbcfd8f";


