//
//  ADAssetPickerDataSource.h
//  ADImageBPE
//
//  Created by Andy on 2018/12/3.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class ADAssetPickerDataSource;

@protocol ADAssetPickerDataSourceDelegate <NSObject>

- (void)assetPickerDataSourceLoadDataSuccess:(ADAssetPickerDataSource *)dataSource;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ADAssetPickerDataSource : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<UIImage *> *thumbnailImages;
@property (nonatomic, weak) id<ADAssetPickerDataSourceDelegate> delegate;

- (void)loadData;
- (void)requestImageAtIndex:(NSInteger)index contentMode:(PHImageContentMode)contentMode resultHandler:(void (^)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;

- (NSInteger)pickedImageCount;
- (BOOL)hasPickedImageAtIndex:(NSInteger)index;
- (NSInteger)pickedIndexOfImageAtIndex:(NSInteger)index;
- (void)pickImageAtIndex:(NSInteger)index;
- (void)unpickImageAtIndex:(NSInteger)index;

- (NSArray<UIImage *> *)pickedImages;

@end

NS_ASSUME_NONNULL_END
