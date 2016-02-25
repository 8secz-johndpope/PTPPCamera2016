//
//  PTPPLocalFileManager.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 22/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPLocalFileManager.h"
#import "ZipArchive.h"

static NSString *StaticStickerPlistFile = @"StaticStickers.plist";
static NSString *ARStickerPlistFile = @"ARStickers.plist";
static NSString *JigsawTemplatePlistFile = @"JigsawTemplate.plist";
@implementation PTPPLocalFileManager

//Retreive local cache folder path given a particular sticker file name
+(NSString *)getFolderPathForARStickerName:(NSString *)ARStickerName{
    NSString *downloadFolder = nil;
    if (ARStickerName.length>0) {
        downloadFolder = [[self getRootFolderPathForARStickers] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",ARStickerName]];
        if (!downloadFolder){
            NSLog(@"Sticker not existed");
        }
    }
        return downloadFolder;
}

#pragma mark - Unzip, write/read plist
+(void)unzipAllFilesForARStickers{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSString *downloadFolder = [self getRootFolderPathForARStickers];
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:downloadFolder
                                                                        error:NULL];
    
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"zip"]) {
            ZipArchive *zipArchive = [[ZipArchive alloc] init];
            [zipArchive UnzipOpenFile:[downloadFolder stringByAppendingPathComponent:filename]];
            BOOL unZipSuccess = [zipArchive UnzipFileTo:downloadFolder overWrite:YES];
            [zipArchive UnzipCloseFile];
            if (unZipSuccess) {
                NSLog(@"File %@ unzip successful",filename);
            }else{
                NSLog(@"File %@ unzip failed",filename);
            }
            [fileManager removeItemAtPath:[downloadFolder stringByAppendingPathComponent:filename] error:NULL];
        }
    }];
}

+(BOOL)unzipFileFromPath:(NSString *)filePath desPath:(NSString *)despath{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSString *extension = [[filePath pathExtension] lowercaseString];
    if ([extension isEqualToString:@"zip"]) {
        ZipArchive *zipArchive  = [[ZipArchive alloc] init];
        [zipArchive UnzipOpenFile:filePath];
        BOOL unZipSuccess = [zipArchive UnzipFileTo:despath overWrite:YES];
        [zipArchive UnzipCloseFile];
        if (unZipSuccess) {
            NSLog(@"File %@ unzip successful",filePath);
        }else{
            NSLog(@"File %@ unzip failed",filePath);
        }
        [fileManager removeItemAtPath:filePath error:NULL];
        return unZipSuccess;
    }
    return NO;
}

+(BOOL)updateDownloadedStaticStickerListWithPackageID:(NSString *)packageID fileName:(NSString *)fileName{
    return  [self writePropertyListTo:StaticStickerPlistFile WithPackageID:packageID fileName:fileName];
}

+(BOOL)updateDownloadedARStickerListWithPackageID:(NSString *)packageID fileName:(NSString *)fileName{
    return  [self writePropertyListTo:ARStickerPlistFile WithPackageID:packageID fileName:fileName];
}

+(BOOL)updateDownloadedJigsawTemplateListWithPackageID:(NSString *)packageID fileName:(NSString *)fileName{
    return  [self writePropertyListTo:JigsawTemplatePlistFile WithPackageID:packageID fileName:fileName];
}

+(BOOL)writePropertyListTo:(NSString *)plistFileName WithPackageID:(NSString *)packageID fileName:(NSString *)fileName{
    NSString *xmlFilePath = [[self getRootFolderPathForCache] stringByAppendingPathComponent:plistFileName];
    NSMutableDictionary *xmlDict = [[NSMutableDictionary alloc] initWithContentsOfFile:xmlFilePath];
    if (!xmlDict) {
        xmlDict = [[NSMutableDictionary alloc] init];
    }
    [xmlDict safeSetObject:fileName forKey:packageID];
    return  [xmlDict writeToFile:xmlFilePath atomically:YES];
}

+(NSDictionary *)getDownloadedStaticStickerList{
    return [[NSMutableDictionary alloc] initWithContentsOfFile:[[self getRootFolderPathForCache] stringByAppendingPathComponent:StaticStickerPlistFile]];
}

+(NSDictionary *)getDownloadedARStickerList{
    return [[NSMutableDictionary alloc] initWithContentsOfFile:[[self getRootFolderPathForCache] stringByAppendingPathComponent:ARStickerPlistFile]];
}

+(NSDictionary *)getDownloadedJigsawTemplateList{
    return [[NSMutableDictionary alloc] initWithContentsOfFile:[[self getRootFolderPathForCache] stringByAppendingPathComponent:JigsawTemplatePlistFile]];
}

+(BOOL)checkIfDownloadedList:(NSDictionary *)downloadedList containsFileName:(NSString *)targetFileName{
    for(NSString *key in [downloadedList allKeys]){
        NSString *currentFileName = [downloadedList safeStringForKey:key];
        if ([currentFileName isEqualToString:targetFileName]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Fast access to root folder paths
+(NSString *)getRootFolderPathForCache{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *cacheFolder = [documentsPath stringByAppendingPathComponent:@"Caches"];
    return cacheFolder;
}

+(NSString *)getRootFolderPathForARStickers{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"ARStickers"];
    return downloadFolder;
}

+(NSString *)getRootFolderPathForStaitcStickers{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"StaticStickers"];
    return downloadFolder;
}

+(NSString *)getRootFolderPathForJigsawTemplate{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"JigsawTemplate"];
    return downloadFolder;
}

+(NSString *)getNSBundlePathForFileName:(NSString *)fileName ofType:(NSString *)fileType{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
}

#pragma mark - ls
+(NSArray *)getListOfFilePathAtDirectory :(NSString *)directory{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:NULL];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        NSString *filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",filename]];
        if(extension.length>0){
            filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@".%@",extension]];
        }
        [tempArray safeAddObject:filePath];
    }];
    return tempArray;
}

//Print list of files with given path
+(void)printListOfFilesAtDirectory:(NSString *)directory{
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:NULL];
    NSLog(@"*********************************START***********************************");
    NSLog(@"%@",directory);
    NSLog(@"*************************************************************************");
    if (dirs.count == 0) {
        NSLog(@"%@:Empty folder",directory);
    }
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if (extension.length > 0) {
            NSLog(@"%@ (File Type:%@)",filename,extension);
        }else{
            NSLog(@"%@",filename);
        }
        
    }];
     NSLog(@"********************************END**************************************");
}

@end
