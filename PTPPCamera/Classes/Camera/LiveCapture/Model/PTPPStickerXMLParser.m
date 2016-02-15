//
//  PTPPStickerXMLParser.m
//  PTPaiPaiCamera
//
//  Created by CHEN KAIDI on 19/1/2016.
//  Copyright © 2016 putao. All rights reserved.
//

#import "PTPPStickerXMLParser.h"
#define kMouth @"mouth"
#define kEar @"ear"
NSString *const kXMLReaderTextNodeKey = @"text";

@interface PTPPStickerXMLParser () <NSXMLParserDelegate>
@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSMutableArray *dictionaryStack;
@property (nonatomic, strong) NSMutableString *textInProgress;

@end

@implementation PTPPStickerXMLParser

+(NSDictionary *)dictionaryFromXMLFilePath:(NSString *)filePath{
    PTPPStickerXMLParser *parser = [[PTPPStickerXMLParser alloc] initWithFilePath:filePath];
    return [parser getDictionary];
}

-(instancetype)initWithFilePath:(NSString *)filePath{
    self = [super init];
    if (self) {
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        self.parser = [[NSXMLParser alloc] initWithData:fileData];
        [self.parser setDelegate:self];
        self.dictionaryStack = [[NSMutableArray alloc] init];
        self.textInProgress = [[NSMutableString alloc] init];
        [self.dictionaryStack addObject:[NSMutableDictionary dictionary]];
    }
    return self;
}

-(NSDictionary *)getDictionary{
    BOOL parseSuccess = [self.parser parse];
    if (!parseSuccess) {
        NSLog(@"Parse Error");
    }else{
        NSDictionary *resultDict = [self.dictionaryStack objectAtIndex:0];
        return resultDict;
    }
    return nil;
}

#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [self.dictionaryStack lastObject];
    
    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there’s already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn’t exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [self.dictionaryStack addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [self.dictionaryStack lastObject];
    
    // Set the text property
    if ([self.textInProgress length] > 0)
    {
        // Get rid of leading + trailing whitespace
        [dictInProgress setObject:self.textInProgress forKey:kXMLReaderTextNodeKey];
        
        // Reset the text
        self.textInProgress = [[NSMutableString alloc] init];
    }
    
    // Pop the current dict
    [self.dictionaryStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.textInProgress appendString:string];
}


@end
