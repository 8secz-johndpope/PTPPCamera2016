//
//  AssetHelper.m
//  DoImagePickerController
//
//  Created by Donobono on 2014. 1. 23..
//

#import "AssetHelper.h"

#import "PTMacro.h"

@implementation AssetHelper


+ (AssetHelper *)sharedAssetHelper
{
    static AssetHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AssetHelper alloc] init];
        [_sharedInstance initAsset];
    });
    
    return _sharedInstance;
}


- (void)initAsset
{
    if (self.assetsLibrary == nil)
    {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
        
        NSString *strVersion = [[UIDevice alloc] systemVersion];
        if ([strVersion compare:@"5"] >= 0)
            [_assetsLibrary writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            }];
    }
}

- (void)setCameraRollAtFirst
{
    for (ALAssetsGroup *group in _assetGroups)
    {
        if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos)
        {
            // send to head
            [_assetGroups removeObject:group];
            [_assetGroups insertObject:group atIndex:0];
            
            return;
        }
    }
}

- (void)getGroupList:(void (^)(NSArray *))result
{
    [self initAsset];
    
    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];

        if (group == nil)
        {
            if (_bReverse)
                _assetGroups = [[NSMutableArray alloc] initWithArray:[[_assetGroups reverseObjectEnumerator] allObjects]];
            
            [self setCameraRollAtFirst];
            
            // end of enumeration
            result(_assetGroups);
            return;
        }
        
        [_assetGroups addObject:group];
    };
    
    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error)
    {
        //NSLog(@"Error : %@", [error description]);
    };
    
    _assetGroups = [[NSMutableArray alloc] init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                  usingBlock:assetGroupEnumerator
                                failureBlock:assetGroupEnumberatorFailure];
}

- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup result:(void (^)(NSArray *))result
{
    [self initAsset];
    
    _assetPhotos = [[NSMutableArray alloc] init];
    [alGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    [alGroup enumerateAssetsUsingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
        
        if(alPhoto == nil)
        {
            if (_bReverse)
                _assetPhotos = [[NSMutableArray alloc] initWithArray:[[_assetPhotos reverseObjectEnumerator] allObjects]];
            
            result(_assetPhotos);
            return;
        }
        
        [_assetPhotos addObject:alPhoto];
    }];
}

- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex result:(void (^)(NSArray *))result
{
    [self getPhotoListOfGroup:_assetGroups[nGroupIndex] result:^(NSArray *aResult) {

        result(_assetPhotos);
        
    }];
}

- (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error
{
    [self initAsset];
    
    dispatch_async(dispatch_get_main_queue(), ^{

        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if ([[group valueForProperty:@"ALAssetsGroupPropertyType"] intValue] == ALAssetsGroupSavedPhotos)
            {
                [group setAssetsFilter:[ALAssetsFilter allPhotos]];

                [group enumerateAssetsUsingBlock:^(ALAsset *alPhoto, NSUInteger index, BOOL *stop) {
                    
                    if(alPhoto == nil)
                    {
                        if (_bReverse)
                            _assetPhotos = [[NSMutableArray alloc] initWithArray:[[_assetPhotos reverseObjectEnumerator] allObjects]];
                        
                        result(_assetPhotos);
                        return;
                    }
                    
                    [_assetPhotos addObject:alPhoto];
                }];
            }
        };
        
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *err)
        {
            //NSLog(@"Error : %@", [err description]);
            error(err);
        };
        
        _assetPhotos = [[NSMutableArray alloc] init];
        [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:assetGroupEnumerator
                                    failureBlock:assetGroupEnumberatorFailure];
    });
}

- (NSInteger)getGroupCount
{
    return _assetGroups.count;
}

- (NSInteger)getPhotoCountOfCurrentGroup
{
    return _assetPhotos.count;
}

- (NSDictionary *)getGroupInfo:(NSInteger)nIndex
{
    return @{@"name" : [_assetGroups[nIndex] valueForProperty:ALAssetsGroupPropertyName],
             @"count" : @([_assetGroups[nIndex] numberOfAssets])};
}

- (void)clearData
{
	_assetGroups = nil;
	_assetPhotos = nil;
}

#pragma mark - utils
- (UIImage *)getCroppedImage:(NSURL *)urlImage
{
    __block UIImage *iImage = nil;
    __block BOOL bBusy = YES;
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        NSString *strXMP = rep.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]])
        {
            CGImageRef iref = [rep fullResolutionImage];
            if (iref)
                iImage = [UIImage imageWithCGImage:iref scale:1.0 orientation:(UIImageOrientation)rep.orientation];
            else
                iImage = nil;
        }
        else
        {
            // to get edited photo by photo app
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:rep.fullResolutionImage];
            
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error) {
                //NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            
            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            
            iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)rep.orientation];
        }
        
		bBusy = NO;
    };
    
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        //NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
    
    [_assetsLibrary assetForURL:urlImage
                    resultBlock:resultblock
                   failureBlock:failureblock];
    
	while (bBusy)
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
    return iImage;
}

- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType
{
    CGImageRef iRef = nil;

    if (nType == ASSET_PHOTO_THUMBNAIL)
        iRef = [asset thumbnail];
    else if (nType == ASSET_PHOTO_ASPECT_THUMBNAIL)
        iRef = [asset aspectRatioThumbnail];
    else if (nType == ASSET_PHOTO_SCREEN_SIZE)
        iRef = [asset.defaultRepresentation fullScreenImage];
    else if (nType == ASSET_PHOTO_FULL_RESOLUTION)
    {
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]])
        {
            
            iRef = [asset.defaultRepresentation fullResolutionImage];
            
            
            return [UIImage imageWithCGImage:iRef scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        }
        else
        {
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
            
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error) {
                //NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            
            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            
            UIImage *iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            return iImage;
        }
    }
    
    return [UIImage imageWithCGImage:iRef];
}

- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType
{
    //NSLog(@"~~~~~~~~~ AssetHelper getImageAtIndex  nIndex :%ld  , nType : %ld",nIndex,nType);
    return [self getImageFromAsset:(ALAsset *)_assetPhotos[nIndex] type:nType];
}

- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex
{
    return _assetPhotos[nIndex];
}

- (ALAssetsGroup *)getGroupAtIndex:(NSInteger)nIndex
{
    return _assetGroups[nIndex];
}

//
//保存图片到指定名称相册，该相册，只新建一次
//
- (void)saveToAlbumWithMetadata:(NSDictionary*)metadata
                      imageData:(NSData*)imageData
                customAlbumName:(NSString*)customAlbumName
                completionBlock:(void(^)(void))completionBlock
                   failureBlock:(void(^)(NSError*error))failureBlock
{
    [self initAsset];
    //接下来是疯狂的 block
    void(^AddAsset)(ALAssetsLibrary *, NSURL*) = ^(ALAssetsLibrary *assetsLibrary, NSURL*assetURL) {
        //1 遍历 AssetsLibrary 整个相册库
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            //2 遍历 ALAssetsGroup 相册库中文件夹
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL*stop) {
                //3 找到 customAlbumName 对应的相册库文件夹
                if([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if(completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError*error) {
                if(failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError*error) {
            if(failureBlock) {
                failureBlock(error);
            }
        }];
    };
    
    //把照片写入相册
    [_assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL*assetURL, NSError*error) {
        if(customAlbumName) {
            [_assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if(group) {
                    [_assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if(completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError*error) {
                        if(failureBlock) {
                            failureBlock(error);
                        }
                    }];
                }else{
                    AddAsset(_assetsLibrary, assetURL);
                }
            } failureBlock:^(NSError*error) {
                AddAsset(_assetsLibrary, assetURL);
            }];
        }else{
            if(completionBlock) {
                completionBlock();
            }
        }
    }];
    
}




- (void)saveImageInAlbumName:(NSString *)albumName{
    [self initAsset];
    
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        else
        {
            BOOL haveHDRGroup = NO;
            
            for (ALAssetsGroup *gp in groups)
            {
                //获取相册名称
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                //比较相册名称
                if ([name isEqualToString:albumName])
                {
                    haveHDRGroup = YES;
                }
            }
            //NSLog(@"===== 是否找到同名相册 : %@ ",haveHDRGroup?@"是":@"否");
            if (!haveHDRGroup)
            {
                //DONOT REMOVE NEXT LINE: temporary solution
                UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                // if user delete putao paipai folder, create it again
                //Attention: ios 8 and 7 is different
                //iOS 8.x. . code that has to be called dynamically at runtime and will not link on iOS 7.x.
                Class PHPhotoLibrary_class = NSClassFromString(@"PHPhotoLibrary");
                if (PHPhotoLibrary_class) {
                    //from project ALAssetsLibrary-CustomPhotoAlbum
                    // dynamic runtime code for code chunk listed above
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    id sharedPhotoLibrary = [PHPhotoLibrary_class performSelector:NSSelectorFromString(@"sharedPhotoLibrary")];
#pragma clang diagnostic pop
                    
                    SEL performChanges = NSSelectorFromString(@"performChanges:completionHandler:");
                    NSMethodSignature *methodSig = [sharedPhotoLibrary methodSignatureForSelector:performChanges];
                    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:methodSig];
                    [inv setTarget:sharedPhotoLibrary];
                    [inv setSelector:performChanges];
                    
                    void(^firstBlock)() = ^void() {
                        Class PHAssetCollectionChangeRequest_class = NSClassFromString(@"PHAssetCollectionChangeRequest");
                        SEL creationRequestForAssetCollectionWithTitle = NSSelectorFromString(@"creationRequestForAssetCollectionWithTitle:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        [PHAssetCollectionChangeRequest_class performSelector:creationRequestForAssetCollectionWithTitle withObject:albumName];
#pragma clang diagnostic pop
                    };
                    
                    void (^secondBlock)(BOOL success, NSError *error) = ^void(BOOL success, NSError *error) {
                        if (success) {
                            [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                if (group) {
                                    NSString *name =[group valueForProperty:ALAssetsGroupPropertyName];
                                    if ([name isEqualToString:albumName]) {
                                        [groups addObject:group];
                                    }
                                }
                            } failureBlock:^(NSError *error) {
                                // NSLog(@"create folder failed");
                            }];
                        }
                    };
                    
                    // Set the first and second blocks.
                    [inv setArgument:&firstBlock atIndex:2];
                    [inv setArgument:&secondBlock atIndex:3];
                    [inv invoke];
                }else{
                    //创建一个相册到相册资源中，并通过block返回创建成功的相册ALAssetsGroup
                    [_assetsLibrary addAssetsGroupAlbumWithName:albumName
                                                    resultBlock:^(ALAssetsGroup *group){
                         if (group!=nil) {
                             [groups addObject:group];
                         }
                     }failureBlock:^(NSError *error) {
                         //NSLog(@"===== 新建相册失败 ");
                     }];
                }
            }
            haveHDRGroup = YES;
        }
        
    };
    
    
    //创建相簿
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
}


//#pragma mark --
//#pragma mark -- 优化相册读取速度
//- (void)readAlbumList
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        ASSETHELPER.bReverse = YES;
//        [ASSETHELPER getGroupList:^(NSArray *assetsGroup){
//            
//            [ASSETHELPER getPhotoListOfGroupByIndex:0 result:^(NSArray *aPhotos) {
//                NSMutableDictionary * dataMArr = [self copyPhotoArrays:aPhotos];
//                NSMutableArray * newDateArray = [self photoDataArrays:dataMArr];
//                NSMutableArray * photoURLArray = [self photoUrlArrays:newDateArray inDataMArr:dataMArr];
//            }];
//            
//            
//        }];
//    });
//}
//
////获取整个相册对象拷贝
//- (NSMutableDictionary *) copyPhotoArrays:(NSArray *)aPhotos
//{
//    NSMutableDictionary *dicImages= [[NSMutableDictionary alloc]init];
//    if (aPhotos) {
//        for (ALAsset *  assetPhotos in aPhotos) {
//            //类型， Location , 时长，方向，日期，格式 ， URL地址
//            NSDate * nsALAssetPropertyDate = [ assetPhotos valueForProperty:ALAssetPropertyDate ] ;
//            
//            NSString * strDate = [NDDateTools stringFromDateToDay:nsALAssetPropertyDate];
//            NSMutableArray *arrayGroup = [dicImages objectForKey:strDate];
//            if (arrayGroup == nil) {
//                arrayGroup = [[NSMutableArray alloc] init];
//            }
//            [arrayGroup addObject:assetPhotos];
//            [dicImages setValue:arrayGroup forKey:strDate];
//        }
//    }
//    
//    return dicImages;
//}
//
////获取相册的日期分类
//- (NSMutableArray *) photoDataArrays:(NSMutableDictionary *)dataMArr
//{
//    //这里是所有的 日期 key
//    NSMutableArray * newDateArray = [[dataMArr allKeys] mutableCopy];
//    [newDateArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        NSDate *date1 = [dateFormatter dateFromString:obj1];
//        NSDate *date2 = [dateFormatter dateFromString:obj2];
//        
//        double a = date1.timeIntervalSince1970;
//        double b = date2.timeIntervalSince1970;
//        if (a < b) {
//            return NSOrderedDescending;
//        } else if (a > b) {
//            return NSOrderedAscending;
//        } else {
//            return NSOrderedSame;
//        }
//    }];
//    
//    return newDateArray;
//}
//
//
////获取一个日期分类内的照片
//- (NSMutableArray *) photoUrlArrays:(NSMutableArray *)newDateArray inDataMArr:(NSMutableDictionary *)dataMArr
//{
//    NSMutableArray * photoURLArray = [[NSMutableArray alloc]init];
//    for (NSInteger i=0; i<[newDateArray count]; i++) {
//        NSString *strDate =[newDateArray objectAtIndex:i];
//        NSMutableArray *arrayGroup = [dataMArr objectForKey:strDate];
//        if (photoURLArray) {
//            [photoURLArray addObjectsFromArray:arrayGroup];
//        }
//    }
//    return photoURLArray;
//}



@end
