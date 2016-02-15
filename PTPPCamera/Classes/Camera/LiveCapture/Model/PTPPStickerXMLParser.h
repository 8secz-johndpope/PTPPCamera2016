//
//  PTPPStickerXMLParser.h
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 19/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ResultDict)(NSDictionary *resultDictionary);
@interface PTPPStickerXMLParser : NSObject
+(NSDictionary *)dictionaryFromXMLFilePath:(NSString *)filePath;
@end
