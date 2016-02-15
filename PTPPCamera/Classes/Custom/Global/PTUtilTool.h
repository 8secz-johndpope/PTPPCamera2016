//
//  PTUtilTool.h
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/4.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

//////////////////////////////
// 欢迎页面信息本地保存
/////////////////////////////
#define CURRENT_APP_VERSION @"currentAppVersion"
#define IS_WELCOME_INTRODSHOW @"IsWelcomeIntrodShow"
#define ISNEEDREFRESH @"IsNeedRefresh"


@interface PTUtilTool : NSObject

/////////////////////////////
//  获取系统及设备相关信息方法
/////////////////////////////
/**
 *  获取系统版本号
 */
+(NSString *)getAppVersion;


/**
 *  获取设备 ID
 */
+(NSString *)getDeviceID;


/**
 *  获取设备 Name
 */
+(NSString *)getDeviceName;

//判断当前设备
// iphone 4 5 6 6p
+(NSString *)getCurrentDrive;


/////////////////////////////
//  初次安装欢迎页面
/////////////////////////////
+ (BOOL) isIntrodShown;



/////////////////////////////
//  实用工具方法
/////////////////////////////
//判读是否为空或输入只有空格
+ (BOOL)isEmpty:(NSString *)str;


//获取 App Document 目录
//应用中用户数据可以放在这里，iTunes备份和恢复的时候会包括此目录
+ (NSString *)applicationDocumentsFileDirectory;

//获取 App Library 目录
//存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
+ (NSString *)applicationLibraryFileDirectory;


/**
 *  对image按照width缩放剪裁
 */
+ (UIImage *)reSizeImage:(UIImage *)originImage WithWidth:(float)width;


//正则表达式验证
/**
 *  验证是否是手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//邮箱
+ (BOOL) validateEmail:(NSString *)email;

//用户名
+ (BOOL) validateUserName:(NSString *)name;

//密码
+ (BOOL) validatePassword:(NSString *)passWord;

//昵称
+ (BOOL) validateNickname:(NSString *)nickname;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;


/**
 * 返回 1(YES) 表示相册可用。返回 0(NO) 表示相册不可用
 */
+ (BOOL)checkALAssetsLibraryCanUse;

/**
 * 返回 1(YES) 表示相机可用。返回 0(NO) 表示相机不可用
 */
+ (BOOL)checkCameraCanUse;


@end
