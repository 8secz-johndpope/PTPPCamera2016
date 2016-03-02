//
//  AppDelegate.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 15/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//
#import "UMFeedback.h"
#import "UMessage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "AppDelegate.h"
#import "PTPPLiveCameraViewController.h"
#import "PTPPLocalFileManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self preloading];
    [self Setupumeng];
    [self speendUpShowKeyBoard];
    PTPPLiveCameraViewController *liveCameraVC = [[PTPPLiveCameraViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:liveCameraVC];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)preloading{
    BOOL stickersPreinstalled = [[NSUserDefaults standardUserDefaults] boolForKey:@"stickersPreinstalled"];
    if (!stickersPreinstalled) {
        BOOL installedSuccessful = [PTPPLocalFileManager unzipAllFilesForARStickers:@[@"hz",@"cn", @"mhl", @"xm", @"fd", @"kq", @"xhx",@"hy"]];
        if (installedSuccessful) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"stickersPreinstalled"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)Setupumeng {

    // Umeng social
    [UMSocialData setAppKey:UmengAppkey];
    //[UMSocialData openLog:YES];
    [UMSocialWechatHandler setWXAppId:@"wx1f67f2c75acfaf0c" appSecret:@"ce6c4b8b94e35d5a0fb16a839baeb0d8" url:@"http://putao.im/forum.php"];
    //TODO reset share with real paramters
    [UMSocialQQHandler setQQWithAppId:@"1104521316" appKey:@"agD4YVpzNFVS39s3" url:@"http://putao.im/forum.php"];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://putao.im/forum.php"];
    
    [UMFeedback setAppkey:UmengAppkey];
    //   [UMFeedback setLogEnabled:NO];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
#endif
    
    //UMeng Push 测试
    //[UMessage setLogEnabled:YES];
    //----------------------------------------------------
}


//初始化键盘，加速启动后键盘弹出速度
-(void) speendUpShowKeyBoard {
    // http://stackoverflow.com/questions/9357026/super-slow-lag-delay-on-initial-keyboard-animation-of-uitextfield
    UITextField *lagFreeField = [[UITextField alloc] init];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    //这里判断是否下载
    //    [[PTPaiPaiDownLoad sharedInstance] downloadJSON:KVersionJsonDownloadURL];
    //
    // 这里增加调用系统设置的判断
    //
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //UMeng Push
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
