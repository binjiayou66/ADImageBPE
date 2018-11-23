//
//  ADImageBrowserController.h
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADImageBrowserController : UIViewController

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images;
- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths;
- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images currentIndex:(NSUInteger)index;
- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths currentIndex:(NSUInteger)index;
- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs currentIndex:(NSUInteger)index;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images fromFrame:(CGRect)fromFrame;
- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths fromFrame:(CGRect)fromFrame;
- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs fromFrame:(CGRect)fromFrame;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images fromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index;
- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths fromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index;
- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs fromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
