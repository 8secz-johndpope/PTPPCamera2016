//
//  PTUtilTool.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/12/4.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTUtilTool.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserDefaultsHelper.h"

@implementation PTUtilTool

+(NSString *)getAppVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return  version;
}


+(NSString *)getDeviceID{
    NSUUID *deviceID = [[UIDevice currentDevice] identifierForVendor]; //设备id
    return [deviceID UUIDString];
}


+(NSString *)getDeviceName{
    return [UIDevice currentDevice].name;
}

// iphone 4 5 6 6p
+(NSString *)getCurrentDrive{
    NSString *drive = @"";
    CGFloat mainHeight = [UIScreen mainScreen].bounds.size.height;
    if (mainHeight == 480) {
        drive = @"4";
    }
    
    if (mainHeight == 568) {
        drive = @"5";
    }
    
    if (mainHeight == 667) {
        drive = @"6";
    }
    
    if (mainHeight == 736) {
        drive = @"6p";
    }
    
    return drive;
}


+ (BOOL) isIntrodShown{
    BOOL flag = NO;
    
    //判断当前App版本号码,有更新,存储新版本号并显示欢迎页面
    NSString *appVersion = [self getAppVersion];
    float newVersion = [appVersion floatValue];
    
    NSString *currentVersion = [UserDefaultsHelper getStringForKey:CURRENT_APP_VERSION];
    
    if (currentVersion != nil && [currentVersion isEqualToString:@""]) {
        flag  = YES;
        [UserDefaultsHelper setStringForKey:appVersion key:CURRENT_APP_VERSION];
    }else{
        float oldVersion = [currentVersion floatValue];
        if (newVersion > oldVersion) {
            flag = YES;
            [UserDefaultsHelper setStringForKey:appVersion key:CURRENT_APP_VERSION];
        }
    }
    
    return flag;
}


+ (BOOL)isMobileNumber:(NSString *)mobileNum{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    
    //为了一官网一致，这里只对号码第一位做验证。
    NSString *FIRSTChar = @"^1\\d{10}$";
    NSPredicate *regextestFirstChar = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", FIRSTChar];
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
//    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
//    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
//    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    /*
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
     */
    if ([regextestFirstChar evaluateWithObject:mobileNum] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}


//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


//判读是否为空或输入只有空格
+ (BOOL)isEmpty:(NSString *)str{
    
    if (!str) {
        return YES;
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

//获取 App Document 目录
+ (NSString *)applicationDocumentsFileDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths safeObjectAtIndex:0] : nil;
    return basePath;
}

+ (NSString *)applicationLibraryFileDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths safeObjectAtIndex:0] : nil;
    return basePath;
}


//对image按照width缩放剪裁
+ (UIImage *)reSizeImage:(UIImage *)originImage WithWidth:(float)width{
    
    float   scaleSize = width/originImage.size.width;
    
    if (scaleSize < 1) {
        
        UIGraphicsBeginImageContext(CGSizeMake(originImage.size.width * scaleSize, originImage.size.height * scaleSize));
        [originImage drawInRect:CGRectMake(0, 0, originImage.size.width * scaleSize, originImage.size.height * scaleSize)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        return scaledImage;
        
    }
    return originImage;
}


#pragma mark - 判断相册是否允许使用
//返回 1(YES) 表示相册可用。返回 0(NO) 表示相册不可用
+ (BOOL)checkALAssetsLibraryCanUse{
    
    BOOL flag = NO;
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    switch (author) {
        case ALAuthorizationStatusRestricted:     //此应用无法访问照片数据，如家长限制
        case ALAuthorizationStatusDenied:         //用户已拒绝此应用访问相册数据
            break;
        case ALAuthorizationStatusNotDetermined:  //用户尚未作出关于此应用程序的选择
        case ALAuthorizationStatusAuthorized:     //用户已授权该应用可以访问照片数据
            flag = YES;
            break;
        default:
            break;
    }
    
    return flag;
}


#pragma mark - 确认相机是否允许访问
//返回 1(YES) 表示相机可用。返回 0(NO) 表示相机不可用
+ (BOOL)checkCameraCanUse{
    BOOL flag = NO;
    
    //Capture 捕捉器,Video 视频
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusAuthorized:{//批准
            flag = YES;
            break;
        }
        case AVAuthorizationStatusRestricted: //Restricted 收限制
        case AVAuthorizationStatusDenied://拒绝
        case AVAuthorizationStatusNotDetermined:{ //不确定
            break;
        }
    }
    
    return flag;
}

@end
