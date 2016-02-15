//
//  PTAPI.h
//  PTLatitude
//
//  Created by so on 15/11/27.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PT_API
#define PT_API

#define PT_HTTP_SUCCESS_CODE    200


/**
 *  @brief  打包类型, 0:内网测试  1.外网测试  2.发布AppStore
 */
#define PT_API_TYPE         (0)
/**
 * @brief  打点和推送功能开关变量 0-内网 1-外网
 */
#define DEBUG_APP           (0)


/**
 *  @brief  应用ID
 */
extern NSString * const _Nonnull PTLatitudeAppID;

/**
 *  @brief  平台ID
 */
extern NSString * const _Nonnull PTLatitudePlatformID;

/**
 *  @brief  secret key
 */
extern NSString * const _Nonnull PTLatitudeSecretKey;

/**
 *  @brief  baidu map key
 */
extern NSString * const _Nonnull PTLatitudeBaiduMapKey;

/**
 *  @brief  wx key
 */
extern NSString * const _Nonnull PTLatitudeWxKey;

/**
 *  @brief  触发接口调试界面的时长
 */
extern NSTimeInterval PTLatitudeDebugMenuTimeInt;


/**
 *  @brief  资源更新secret key
 */
extern NSString * const _Nonnull PTLatitudeDataSourceSecretKey;

/**
 *  @brief  资源更新地址
 */
extern NSString * const _Nonnull PTLatitudeDataSourceUpdateURL;



/**
 *  @brief  通过基本路径和相对路径，获取绝对路径
 *
 *  @return 返回绝对路径
 */
extern NSString * const _Nonnull PTAbsoluteURLString(NSString * _Nonnull baseURLString, NSString * _Nullable  relativeURLString);


/***********************************************************************************/
/****************************         BaseURL        *******************************/

/**
 *  @brief  Passport 服务地址
 */
extern NSString * const _Nonnull PTLatitudePassportServiceBaseURL;

/**
 *  @brief  葡萄探索号地址
 */
extern NSString * const _Nonnull PTLatitudeStoreServiceBaseURL;

extern NSString * const _Nonnull PTLatitudeUserServiceBaseURL;

/**
 *  @brief  H5地址
 */
extern NSString * const _Nonnull PTLatitudeH5ServiceBaseURL;

/***********************************************************************************/
/***********************************************************************************/



/**
 *  @brief  Passport AppID
 *          线上线下相同
 */
extern NSString * const _Nonnull PTLatitudePassportAppID;
/**
 *  @brief  Passport SecretKey
 */
extern NSString * const _Nonnull PTLatitudePassportAppSecretKey;




#endif

