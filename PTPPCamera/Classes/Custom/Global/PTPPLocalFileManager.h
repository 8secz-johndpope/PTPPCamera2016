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
+(void)printListOfFilesAtDirectory:(NSString *)directory;
+(void)unzipAllFilesForARStickers;
@end
