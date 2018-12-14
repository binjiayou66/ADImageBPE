//
//  ADAssetPickerDataSource.m
//  ADImageBPE
//
//  Created by Andy on 2018/12/3.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADAssetPickerDataSource.h"
#import "ADImageBPEDefinition.h"

@interface ADAssetPickerDataSource ()

/// PHAsset集合
@property (nonatomic, strong) NSMutableArray<PHAsset *> *data;
/// 已选图片的Index合集
@property (nonatomic, strong) NSMutableArray<NSNumber *> *pickedIndexArray;
/// 缩略图合集
@property (nonatomic, strong) NSMutableArray<UIImage *> *thumbnailImages;
/// 已选图片的原图合集
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, UIImage *> *originImages;

@end

@implementation ADAssetPickerDataSource

- (void)loadData
{
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    switch (authStatus) {
        case PHAuthorizationStatusAuthorized:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _initializePhotos];
            });
            break;
        }
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status != PHAuthorizationStatusAuthorized) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先允许访问照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                } else {
                    [self _initializePhotos];
                }
            }];
            break;
        }
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先允许访问照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        default:
            break;
    }
}

- (void)requestImageAtIndex:(NSInteger)index contentMode:(PHImageContentMode)contentMode resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler
{
    if (index >= self.data.count) {
        return;
    }
    PHAsset *asset = self. data[index];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:contentMode options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (resultHandler) {
            resultHandler(result, info);
        }
    }];
}

- (NSInteger)pickedImageCount
{
    return self.pickedIndexArray.count;
}

- (BOOL)hasPickedImageAtIndex:(NSInteger)index
{
    return [self.pickedIndexArray containsObject:@(index)];
}

- (NSInteger)pickedIndexOfImageAtIndex:(NSInteger)index
{
    return [self.pickedIndexArray indexOfObject:@(index)];
}

- (void)pickImageAtIndex:(NSInteger)index
{
    if (index >= self.data.count) {
        return;
    }
    [self.pickedIndexArray addObject:@(index)];
    PHAsset *asset = self. data[index];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            [self.originImages setObject:result forKey:@(index)];
        }
    }];
}

- (void)unpickImageAtIndex:(NSInteger)index
{
    [self.pickedIndexArray removeObject:@(index)];
    [self.originImages removeObjectForKey:@(index)];
}

- (NSArray<UIImage *> *)pickedImages
{
    NSMutableArray *rt = [[NSMutableArray alloc] init];
    for (NSNumber *index in self.pickedIndexArray) {
        UIImage *originImage = [self.originImages objectForKey:index];
        if (originImage) { [rt addObject:originImage]; }
    }
    return rt;
}

#pragma mark - private method

- (void)_initializePhotos
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.data removeAllObjects];
        [self.thumbnailImages removeAllObjects];
        // 所有智能相册
        CGFloat width = ADImagePickerCollectionViewItemWidth();
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
            PHCollection *collection = smartAlbums[i];
            //遍历获取相册
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                for (int j = 0; j < fetchResult.count; j++) {
                    PHAsset *asset = fetchResult[j];
                    [self.data addObject:asset];
                    PHImageManager *imageManager = [PHImageManager defaultManager];
                    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
                    opt.synchronous = YES;
                    [imageManager requestImageForAsset:asset targetSize:CGSizeMake(width, width) contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        if (result) {
                            [self.thumbnailImages addObject:result];
                        } else {
                            [self.thumbnailImages addObject:[UIImage imageNamed:@"ADAssetPickerPlaceholder"]];
                        }
                    }];
                }
            }
        }
        if ([self.delegate respondsToSelector:@selector(assetPickerDataSourceLoadDataSuccess:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate assetPickerDataSourceLoadDataSuccess:self];
            });
        }
    });
}

#pragma mark - getter and setter

- (NSMutableArray<PHAsset *> *)data
{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (NSMutableArray *)pickedIndexArray
{
    if (!_pickedIndexArray) {
        _pickedIndexArray = [[NSMutableArray alloc] init];
    }
    return _pickedIndexArray;
}

- (NSMutableArray<UIImage *> *)thumbnailImages
{
    if (!_thumbnailImages) {
        _thumbnailImages = [[NSMutableArray alloc] init];
    }
    return _thumbnailImages;
}

- (NSMutableDictionary<NSNumber *,UIImage *> *)originImages
{
    if (!_originImages) {
        _originImages = [[NSMutableDictionary alloc] init];
    }
    return _originImages;
}

@end
