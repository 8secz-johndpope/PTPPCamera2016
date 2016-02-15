//
//  PTGloba.h
//  PTLatitude
//
//  Created by so on 15/12/10.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, LDTPChannelID) {
    LDTPChannelIDAppStore           = 11001,        //APP商店
    LDTPChannelIDXYHelper           = 11002,        //XY苹果助手
    LDTPChannelIDTongBuTui          = 11003,        //同步推
    LDTPChannelIDPingGuoKuaiYong    = 11004,        //苹果快用
    LDTPChannelID91Helper           = 11005         //91助手
};

NSString * PTBundleVersion();
NSString * PTBundleShortVersion();
NSString * PTChannelNameWithChannelID(LDTPChannelID channelID);
NSString * PTChannelWithTPChannelID(LDTPChannelID channelID);

//当前渠道ID
static LDTPChannelID PTCurrentTPChannelID   = LDTPChannelIDAppStore;




//通过原图链接取得对应尺寸的切图
typedef NS_OPTIONS(NSUInteger, PTImageURLStringScale) {
    PTImageURLStringScaleNone       = 0,    //原图
    PTImageURLStringScale255x255,           //255 x 255 像素
    PTImageURLStringScale264x264,           //
    PTImageURLStringScale720x450,           //
    PTImageURLStringScale96x96,             //
    PTImageURLStringScale192x192,           //
    
    PTImageURLStringScale1200x1200,
    PTImageURLStringScale1200x750,
    PTImageURLStringScale1200x600,
    PTImageURLStringScale1200x400,
    PTImageURLStringScale960x400,
    PTImageURLStringScale720x720,
    PTImageURLStringScale480x400,
    PTImageURLStringScale280x280,
    PTImageURLStringScale250x0,
};

NSString *PTImageURLScaleWithScale(NSString *URLString, PTImageURLStringScale scale);

