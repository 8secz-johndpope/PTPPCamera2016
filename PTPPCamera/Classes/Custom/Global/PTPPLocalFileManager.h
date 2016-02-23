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

+(NSString *)getRootFolderPathForARStickers;
+(NSString *)getRootFolderPathForStaitcStickers;
+(NSString *)getNSBundlePathForFileName:(NSString *)fileName ofType:(NSString *)fileType;
+(NSArray *)getListOfFilePathAtDirectory :(NSString *)directory;
+(void)printListOfFilesAtDirectory:(NSString *)directory;
@end
