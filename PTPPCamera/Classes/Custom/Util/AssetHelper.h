//
//  AssetHelper.m
//  DoImagePickerController
//
//  Created by Donobono on 2014. 1. 23..
//
/*
 AssetsLibrary.framework 通过这个框架，我们可以读取到相册中所有的照片资源。这个框架主要提供了这么几个类：
 
 ALAssetsLibrary     指的是整个相册库
 ALAssetsGroup       指的是相册中的文件夹
 ALAsset             指的是文件夹中的照片、视频
 
 以上三个类的使用 ：
 先通过  ALAssetsLibrary 类创建相册对象，再通过此相册对象循环遍历相册中得文件夹对象：ALAssetsGroup  。再通过每一个文件夹对象，循环遍历此文件夹中的所有的相册、视频对象：ALAsset。此对象中包含了相册、视频数据，通过这样几次遍历，我们就能获取到相册中所有的照片、视频数据。
 */

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>

#define ASSETHELPER    [AssetHelper sharedAssetHelper]

/*
 从ALAsset对象可获取缩略图 thumbnail 或 aspectRatioThumbnail ；
 从 ALAssetRepresentation 对象可获取全尺寸图片（ fullResolutionImage ），
 全屏图片（ fullScreenImage ）
 及图片的各种属性: orientation ， dimensions ， scale ， url ， metadata 等。
 */
#define ASSET_PHOTO_THUMBNAIL           0    //ALAsset 缩略图
#define ASSET_PHOTO_ASPECT_THUMBNAIL    1    //ALAsset 宽高比
#define ASSET_PHOTO_SCREEN_SIZE         2    //ALAsset 全屏
#define ASSET_PHOTO_FULL_RESOLUTION     3    //ALAsset 全尺寸

@interface AssetHelper : NSObject

- (void)initAsset;

@property (nonatomic, strong)   ALAssetsLibrary			*assetsLibrary;
@property (nonatomic, strong)   NSMutableArray          *assetPhotos;
@property (nonatomic, strong)   NSMutableArray          *assetGroups;
@property (nonatomic, strong)   NSMutableArray          *assetArray;

@property (readwrite)           BOOL                    bReverse;

+ (AssetHelper *)sharedAssetHelper;

// get album list from asset
- (void)getGroupList:(void (^)(NSArray *))result;
// get photos from specific album with ALAssetsGroup object
- (void)getPhotoListOfGroup:(ALAssetsGroup *)alGroup result:(void (^)(NSArray *))result;
// get photos from specific album with index of album array
- (void)getPhotoListOfGroupByIndex:(NSInteger)nGroupIndex result:(void (^)(NSArray *))result;
// get photos from camera roll
- (void)getSavedPhotoList:(void (^)(NSArray *))result error:(void (^)(NSError *))error;

- (NSInteger)getGroupCount;
- (NSInteger)getPhotoCountOfCurrentGroup;
- (NSDictionary *)getGroupInfo:(NSInteger)nIndex;

- (void)clearData;

// utils
- (UIImage *)getCroppedImage:(NSURL *)urlImage;
- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType;
- (UIImage *)getImageAtIndex:(NSInteger)nIndex type:(NSInteger)nType;
- (ALAsset *)getAssetAtIndex:(NSInteger)nIndex;
- (ALAssetsGroup *)getGroupAtIndex:(NSInteger)nIndex;
// 保存图片到指定名称相册，该相册，只新建一次
- (void)saveToAlbumWithMetadata:(NSDictionary*)metadata
                      imageData:(NSData*)imageData
                customAlbumName:(NSString*)customAlbumName
                completionBlock:(void(^)(void))completionBlock
                   failureBlock:(void(^)(NSError*error))failureBlock;
- (void)saveImageInAlbumName:(NSString *)albumName;

// 优化相册读取速度
//- (void)readAlbumList;
//- (NSMutableDictionary *) copyPhotoArrays:(NSArray *)aPhotos;  //获取整个相册对象拷贝
//- (NSMutableArray *) photoDataArrays:(NSMutableDictionary *)dataMArr;  //获取相册的日期分类
//- (NSMutableArray *) photoUrlArrays:(NSMutableArray *)newDateArray inDataMArr:(NSMutableDictionary *)dataMArr;   //获取一个日期分类内的照片


@end

