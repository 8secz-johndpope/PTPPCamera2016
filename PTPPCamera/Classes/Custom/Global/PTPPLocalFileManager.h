//
//  PTPPLocalFileManager.h
//  PTPPCamera
//
//  Created by CHEN KAIDI on 22/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTPPLocalFileManager : NSObject
+(NSString *)getFolderPathForARStickerName:(NSString *)ARStickerName;

+(void)unzipAllFilesForARStickers;
+(BOOL)unzipFileFromPath:(NSString *)filePath desPath:(NSString *)despath;

+(BOOL)updateDownloadedStaticStickerListWithPackageID:(NSString *)packageID fileName:(NSString *)fileName;
+(BOOL)updateDownloadedARStickerListWithPackageID:(NSString *)packageID fileName:(NSString *)fileName;
+(BOOL)updateDownloadedJigsawTemplateListWithPackageID:(NSString *)packageID fileName:(NSString *)fileName;
+(NSDictionary *)getDownloadedStaticStickerList;
+(NSDictionary *)getDownloadedARStickerList;
+(NSDictionary *)getDownloadedJigsawTemplateList;
+(BOOL)checkIfDownloadedList:(NSDictionary *)downloadedList containsFileName:(NSString *)targetFileName;

+(NSString *)getRootFolderPathForCache;
+(NSString *)getRootFolderPathForARStickers;
+(NSString *)getRootFolderPathForStaitcStickers;
+(NSString *)getRootFolderPathForJigsawTemplate;
+(NSString *)getNSBundlePathForFileName:(NSString *)fileName ofType:(NSString *)fileType;

+(NSArray *)getListOfFilePathAtDirectory :(NSString *)directory;
+(void)printListOfFilesAtDirectory:(NSString *)directory;
@end
