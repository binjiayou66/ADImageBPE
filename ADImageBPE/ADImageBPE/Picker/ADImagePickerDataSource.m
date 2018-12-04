//
//  ADImagePickerDataSource.m
//  ADImageBPE
//
//  Created by Andy on 2018/12/3.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADImagePickerDataSource.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface ADImagePickerDataSource ()

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;

@end

@implementation ADImagePickerDataSource

- (void)loadData
{
    
}

- (NSArray *)getCameraRollAlbumContentImage:(BOOL)contentImage contentVideo:(BOOL)contentVideo
{
    NSMutableArray *arr = [NSMutableArray array];
    // 所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        PHCollection *collection = smartAlbums[i];
        //遍历获取相册
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            PHAsset *asset = nil;
            if (fetchResult.count != 0) {
                for (NSInteger j = 0; j < fetchResult.count; j++) {
                    //从相册中取出照片
                    asset = fetchResult[j];
                    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
                    opt.synchronous = YES;
                    PHImageManager *imageManager = [[PHImageManager alloc] init];
                    [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        if (result) {
                            [arr addObject:result];
                        }
                    }];
                }
            }
        }
    }
    //返回所有照片
    return arr;
}

#pragma mark - getter and setter

- (NSMutableArray *)data
{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (ALAssetsLibrary *)assetsLibrary {
    if (!_assetsLibrary) {
        static dispatch_once_t pred = 0;
        static ALAssetsLibrary *library = nil;
        dispatch_once(&pred, ^{
            library = [[ALAssetsLibrary alloc] init];
        });
        _assetsLibrary = library;
    }
    return _assetsLibrary;
}

@end
