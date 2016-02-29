//
//  PTPPLocalFileManager.m
//  PTPPCamera
//
//  Created by CHEN KAIDI on 22/2/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

#import "PTPPLocalFileManager.h"
#import "ZipArchive.h"


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
+(BOOL)unzipAllFilesForARStickers:(NSArray *)fileNameArray{
    
    NSString *downloadFolder = [self getRootFolderPathForARStickers];
    for(NSString *fileName in fileNameArray){
        
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        [zipArchive UnzipOpenFile:[self getNSBundlePathForFileName:fileName ofType:@"zip"]];
        BOOL unZipSuccess = [zipArchive UnzipFileTo:[downloadFolder stringByAppendingPathComponent:fileName] overWrite:YES];
        [zipArchive UnzipCloseFile];
        if (unZipSuccess) {
            NSLog(@"File %@ unzip successful",fileName);
        }else{
            NSLog(@"File %@ unzip failed",fileName);
            return NO;
        }
        //[fileManager removeItemAtPath:[downloadFolder stringByAppendingPathComponent:filename] error:NULL];
    }
    return YES;
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

+(BOOL)removeItemAtPath:(NSString *)filePath{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:NULL];
}

+(void)removeItemFromPlist:(NSString *)plistFileName withPackageID:(NSString *)packageID{
    NSString *xmlFilePath = [[self getRootFolderPathForCache] stringByAppendingPathComponent:plistFileName];
    NSMutableDictionary *xmlDict = [[NSMutableDictionary alloc] initWithContentsOfFile:xmlFilePath];
    if (xmlDict == nil) {
        return;
    }
    [xmlDict removeObjectForKey:packageID];
    [xmlDict writeToFile:xmlFilePath atomically:YES];
}

+(BOOL)writePropertyListTo:(NSString *)plistFileName WithPackageID:(NSString *)packageID fileName:(NSString *)fileName themeName:(NSString *)themeName fileSize:(NSString *)fileSize totalNum:(NSString *)totalNum coverPic:(NSString *)coverPic{
    NSString *xmlFilePath = [[self getRootFolderPathForCache] stringByAppendingPathComponent:plistFileName];
    NSMutableDictionary *xmlDict = [[NSMutableDictionary alloc] initWithContentsOfFile:xmlFilePath];
    if (!xmlDict) {
        xmlDict = [[NSMutableDictionary alloc] init];
    }
    NSDictionary *fileSettingDict = [[NSDictionary alloc] initWithObjectsAndKeys:fileName, kLocalFileName, themeName, kLocalThemeName, fileSize, kLocalFileSize, totalNum, kLocalTotalNum, coverPic, kLocalCoverPic,nil];
    [xmlDict safeSetObject:fileSettingDict forKey:packageID];
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
        NSDictionary *currentFile = [downloadedList safeObjectForKey:key];
        if ([[currentFile safeStringForKey:kLocalFileName] isEqualToString:targetFileName]) {
            return YES;
        }
    }
    return NO;
}

+(NSString *)getFileNameFromPackageID:(NSString *)packageID inDownloadedList:(NSDictionary *)downloadedList{
    return [[downloadedList safeObjectForKey:packageID] safeStringForKey:kLocalFileName];
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

+(NSString *)folderSize:(NSString *)folderPath {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
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
