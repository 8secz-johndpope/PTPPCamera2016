//
//  PTAPI.h
//  PTLatitude
//
//  Created by so on 15/11/27.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PTPPAppID                       @"1200"
#define SECRETKEY                       @"c8789e2f57f541489a2d253c7f212b28"
#define DEBUG_APP                       1       // 0-外网 1-内网

//新地址 －－ 内网
#if DEBUG_APP

#define PTPP_BASE_URL                   @"http://api-paipai.start.wang"
#define PTPP_CLOUD_URL                  @"http://upload.dev.putaocloud.com"

#else

#define PTPP_BASE_URL                   @""
#define PTPP_CLOUD_URL                  @"http://upload.putaocloud.com"

#endif

//分享视频
#define API_GET_VIDEO_UPLOAD_TOKEN      @"/get/upload/token"
#define VIDEO_UPLOAD_PATH               @"/videoupload"
#define API_VIDEO_WEB_SHARE             @"/relation/media"
#define API_VIDEO_H5                    @"/share/media?media_url="

//素材中心
#define API_MATERIAL_LIST               @"/material/list"
#define API_MATERIAL_DETAILS            @"/material/details"