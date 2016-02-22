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
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *downloadFolder = nil;
    if (ARStickerName.length>0) {
        downloadFolder = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ARStickers/%@",ARStickerName]];
        if (!downloadFolder){
            NSLog(@"Sticker not existed");
        }
    }
        return downloadFolder;
}

+(void)unzipAllFilesForARStickers{
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"ARStickers"];
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

//Print list of files with given path
+(void)printListOfFilesAtDirectory:(NSString *)directory{
    NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:NULL];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        NSLog(@"%@.%@",filename,extension);
    }];
}

@end
