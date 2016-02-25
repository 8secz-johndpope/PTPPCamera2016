//
//  PTPPLocalFileManager.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 22/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kLocalFileName   @"kLocalFileName"
#define kLocalThemeName  @"kLocalThemeName"
#define kLocalFileSize   @"kLocalFileSize"
#define kLocalTotalNum   @"kLocalTotalNum"
#define kLocalCoverPic   @"kLocalCoverPic"

static NSString *StaticStickerPlistFile = @"StaticStickers.plist";
static NSString *ARStickerPlistFile = @"ARStickers.plist";
static NSString *JigsawTemplatePlistFile = @"JigsawTemplate.plist";

@interface PTPPLocalFileManager : NSObject
+(NSString *)getFolderPathForARStickerName:(NSString *)ARStickerName;

+(void)unzipAllFilesForARStickers;
+(BOOL)unzipFileFromPath:(NSString *)filePath desPath:(NSString *)despath;
+(BOOL)removeItemAtPath:(NSString *)filePath;
+(void)removeItemFromPlist:(NSString *)plistFileName withPackageID:(NSString *)packageID;

+(BOOL)writePropertyListTo:(NSString *)plistFileName WithPackageID:(NSString *)packageID fileName:(NSString *)fileName themeName:(NSString *)themeName fileSize:(NSString *)fileSize totalNum:(NSString *)totalNum coverPic:(NSString *)coverPic;
+(NSDictionary *)getDownloadedStaticStickerList;
+(NSDictionary *)getDownloadedARStickerList;
+(NSDictionary *)getDownloadedJigsawTemplateList;
+(BOOL)checkIfDownloadedList:(NSDictionary *)downloadedList containsFileName:(NSString *)targetFileName;

+(NSString *)getRootFolderPathForCache;
+(NSString *)getRootFolderPathForARStickers;
+(NSString *)getRootFolderPathForStaitcStickers;
+(NSString *)getRootFolderPathForJigsawTemplate;
+(NSString *)getNSBundlePathForFileName:(NSString *)fileName ofType:(NSString *)fileType;
+(NSString *)folderSize:(NSString *)folderPath;

+(NSArray *)getListOfFilePathAtDirectory :(NSString *)directory;
+(void)printListOfFilesAtDirectory:(NSString *)directory;
@end
