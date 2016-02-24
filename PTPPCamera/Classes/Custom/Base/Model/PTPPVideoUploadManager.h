//
//  PTHTTPRequestManager.h
//  PTPaiPaiCamera
//
//  Created by shenzhou on 15/4/2.
//  Copyright (c) 2015年 putao. All rights reserved.
//

/**
 *  api接口管理类
 */

#import <Foundation/Foundation.h>

#import "AFNetworking.h"


@protocol HTTPRequestDelegate <NSObject>

@optional

//普通请求使用
- (void)request:(AFHTTPRequestOperation *)myRequest finshAction:(NSDictionary *)dic withURLTag:(NSString *)url;
- (void)request:(AFHTTPRequestOperation *)myRequest failAction:(NSError *)error withURLTag:(NSString *)url;

//下载类使用
- (void)request:(AFHTTPRequestOperation *)myRequest downFinshAction:(NSDictionary *)dic withTag:(int)tag;
- (void)request:(AFHTTPRequestOperation *)myRequest downfailAction:(NSError *)error withTag:(int)tag;
- (void)request:(AFHTTPRequestOperation *)myRequest downloadProgress:(CGFloat)progress withTag:(int)tag;

@end

@interface PTPPVideoUploadManager : NSObject

@property (nonatomic,assign)id<HTTPRequestDelegate>httpDelegate;
@property (nonatomic,strong)AFHTTPRequestOperation *httpOperation;


//获取上传Token
-(AFHTTPRequestOperationManager *)api_getVideoUploadTokenWithDelegate:(id<HTTPRequestDelegate>)delegate;
//上传视频
- (AFHTTPRequestOperationManager *)video_upload:(id<HTTPRequestDelegate>)delegate withUploadToken:(NSString *)token withPhotoFileName:(NSString *)fileName withVideoPath:(NSURL *)videoURL withVideoSHA_1:(NSString *)sha_1 withTag:(int)tag;
//生成视频链接
-(AFHTTPRequestOperationManager *)api_getVideoLinkWithDelegate:(id<HTTPRequestDelegate>)delegate hash:(NSString *)hash ext:(NSString *)ext;
@end
