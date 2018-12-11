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

@property (nonatomic, strong) NSMutableArray<PHAsset *> *data;
@property (nonatomic, strong) NSMutableArray<UIImage *> *thumbnailData;

@end

@implementation ADAssetPickerDataSource

- (void)loadData
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先允许访问照片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        } else {
            [self _initializePhotos];
        }
    }];
    
}

- (void)requestImageAtIndex:(NSInteger)index targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler
{
    if (index >= self.data.count) {
        return;
    }
    PHAsset *asset = self. data[index];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
    [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (resultHandler) {
            resultHandler(result, info);
        }
    }];
}

#pragma mark - private method

- (void)_initializePhotos
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.data removeAllObjects];
        [self.thumbnailData removeAllObjects];
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
                            [self.thumbnailData addObject:result];
                        } else {
                            [self.thumbnailData addObject:[UIImage imageNamed:@"ADAssetPickerPlaceholder"]];
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

- (NSMutableArray<UIImage *> *)thumbnailData
{
    if (!_thumbnailData) {
        _thumbnailData = [[NSMutableArray alloc] init];
    }
    return _thumbnailData;
}

@end
