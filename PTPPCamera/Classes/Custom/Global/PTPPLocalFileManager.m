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
        return unZipSuccess;
    }
    return NO;
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

+(NSString *)getNSBundlePathForFileName:(NSString *)fileName ofType:(NSString *)fileType{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
}

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
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if (extension.length > 0) {
            NSLog(@"%@.%@",filename,extension);
        }else{
            NSLog(@"%@",filename);
        }
        
    }];
}

@end
