//
//  PTHTTPRequestManager.m
//  PTPaiPaiCamera
//
//  Created by shenzhou on 15/4/2.
//  Copyright (c) 2015年 putao. All rights reserved.
//

#import "PTPPVideoUploadManager.h"

#import "NSObject+Swizzle.h"
@implementation PTPPVideoUploadManager

@synthesize httpDelegate;
@synthesize httpOperation;

#pragma mark - private method


//统一请求接口--普通post带参数请求
- (AFHTTPRequestOperationManager *)startRequestDelegate:(id<HTTPRequestDelegate>)delegate WithUrl:(NSString *)url withParameters:(NSDictionary *)parameters withTag:(NSString *)tag{

    NSString    *targetUrl = url;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:targetUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (httpDelegate && [httpDelegate respondsToSelector:@selector(request:finshAction:withURLTag:)]) {
            [httpDelegate request:operation finshAction:(NSDictionary *)responseObject withURLTag:tag];
        }else{
            [operation cancel];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (httpDelegate && [httpDelegate respondsToSelector:@selector(request:failAction:withURLTag:)]) {
            [httpDelegate request:operation failAction:error withURLTag:tag];
        }else{
            [operation cancel];
        }
        
    }];
    
    return manager;

}

//上传视频Token
-(AFHTTPRequestOperationManager *)api_getVideoUploadTokenWithDelegate:(id<HTTPRequestDelegate>)delegate
{
    httpDelegate = delegate;
    
    NSString    *targetUrl = [NSString stringWithFormat:@"%@%@",PTPP_BASE_URL,API_GET_VIDEO_UPLOAD_TOKEN];
    Common_add_parameter
    
    return [self startRequestDelegate:httpDelegate WithUrl:targetUrl withParameters:t_dic withTag:API_GET_VIDEO_UPLOAD_TOKEN];
}

//上传视频Data
- (AFHTTPRequestOperationManager *)video_upload:(id<HTTPRequestDelegate>)delegate withUploadToken:(NSString *)token withPhotoFileName:(NSString *)fileName withVideoPath:(NSURL *)videoURL withVideoSHA_1:(NSString *)sha_1 withTag:(int)tag{
    
    httpDelegate = delegate;
    
    Common_add_parameter
    [t_dic safeSetObject:@"1010" forKey:@"appid"];      //孩子玩默认 1000
    [t_dic safeSetObject:token forKey:@"uploadToken"];
    [t_dic safeSetObject:fileName forKey:@"filename"];
    
    //真文件上传
    
    NSString *targetUrl = [NSString stringWithFormat:@"%@%@", PTPP_CLOUD_URL, VIDEO_UPLOAD_PATH];
    NSData *videoData = [[NSFileManager defaultManager] contentsAtPath:[videoURL path]];
 
    return [self startUploadWithDelegate:httpDelegate withRequestURl:targetUrl withParameters:t_dic withFileURL:nil withFileData:videoData withFileKey:@"file" withFileExtension:@"mp4" withMimeType:@"video/mp4" withTag:tag];
    
}

//生成视频链接
-(AFHTTPRequestOperationManager *)api_getVideoLinkWithDelegate:(id<HTTPRequestDelegate>)delegate hash:(NSString *)hash ext:(NSString *)ext
{
    httpDelegate = delegate;
    
    NSString    *targetUrl = [NSString stringWithFormat:@"%@%@",PTPP_BASE_URL,API_VIDEO_WEB_SHARE];
    Common_add_parameter
    [t_dic safeSetObject:hash forKey:@"hash"];
    [t_dic safeSetObject:ext forKey:@"ext"];
    [t_dic safeSetObject:@"VIDEO" forKey:@"media_type"];
    return [self startRequestDelegate:httpDelegate WithUrl:targetUrl withParameters:t_dic withTag:API_VIDEO_WEB_SHARE];
}

- (AFHTTPRequestOperationManager *)startUploadWithDelegate:(id<HTTPRequestDelegate>)delegate withRequestURl:(NSString *)url withParameters:(NSDictionary *)parameters withFileURL:(NSString *)fileURL withFileData:(NSData *)fileData withFileKey:(NSString *)key withFileExtension:(NSString *)fileExtension withMimeType:(NSString *)mimeType withTag:(int)tag{
    
    //下载请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/json",@"text/html", @"text/xml",@"text/json", nil];
    manager.requestSerializer.timeoutInterval = TIME_NET_TIMEOUT;
    
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSString *key in [parameters allKeys]) {
            NSString *value = [parameters safeObjectForKey:key];
            [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:key];
            
            /**
             *  Debug 上传服务器
             */
            //            if ([key isEqualToString:@"uploadToken"]) {
            //                [formData appendPartWithFormData:[@"69025f5e6c7dd0c1157e0daf94e9cef5:Cs0CwAf9DKb99_ZKMiFDkhVyk0E=:eyJkZWFkbGluZSI6MTQ0MTYxOTcyNCwiY2FsbGJhY2tCb2R5IjpbXX0=" dataUsingEncoding:NSUTF8StringEncoding] name:@"uploadToken"];
            //            }
        }
        
        if (fileData) {
            [formData appendPartWithFileData:fileData
                                        name:key
                                    fileName:[NSString stringWithFormat:@"%@.%@",key,fileExtension]
                                    mimeType:mimeType];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (httpDelegate && [httpDelegate respondsToSelector:@selector(request:finshAction:withURLTag:)]) {
            [httpDelegate request:operation finshAction:(NSDictionary *)responseObject withURLTag:[NSString stringWithFormat:@"%d",tag]];
        }else{
            [operation cancel];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] rangeOfString:@"The request timed out."].length > 0) {
            NSLog(@"Video upload time out");
        }
        
        if (httpDelegate && [httpDelegate respondsToSelector:@selector(request:failAction:withURLTag:)]) {
            [httpDelegate request:operation failAction:error withURLTag:[NSString stringWithFormat:@"%d",tag]];
        }else{
            [operation cancel];
        }
        
    }];
    
    return manager;
}


@end
