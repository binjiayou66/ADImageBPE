//
//  ADImageBrowserController.h
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

/**
 1. 使用方式分为两种，直接提供图片数据 / 协议代理模式提供图片数据。
 2. 两种使用方式都有带动画过渡版本与无动画过渡版本。直接提供图片数据的方式，初始化方法中提供fromFrame则会带过渡动画，否则没有；协议代理模式提供图片数据方式，如果实现optional协议方法，则会带过渡动画，否则没有。
 */

#import <UIKit/UIKit.h>
@class ADImageBrowserController;

@protocol ADImageBrowserControllerDataSource <NSObject>

- (NSUInteger)imageBrowserControllerNumberOfImages:(ADImageBrowserController *)controller;
- (UIImage *)imageBrowserController:(ADImageBrowserController *)controller imageAtIndex:(NSUInteger)index;

@optional
- (NSInteger)imageBrowserControllerCurrentIndex:(ADImageBrowserController *)controller;
- (CGRect)imageBrowserControllerAnimationFromFrame:(ADImageBrowserController *)controller;
- (CGRect)imageBrowserControllerAnimationToFrame:(ADImageBrowserController *)controller;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ADImageBrowserController : UIViewController

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

#pragma mark - 代理方式浏览图片，优先级更高

@property (nonatomic, weak) id<ADImageBrowserControllerDataSource> delegate;

#pragma mark - 直接提供图片数据方式浏览

/// 图片数组初始化，无过渡动画
- (instancetype)initWithImages:(NSArray<UIImage *> *)images;
/// 图片本地路径数组初始化，无过渡动画
- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths;
/// 图片远程url数组初始化，无过渡动画
- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs;

/// 图片数组初始化，无过渡动画，指定当前展示图片的下标
- (instancetype)initWithImages:(NSArray<UIImage *> *)images currentIndex:(NSUInteger)index;
/// 图片本地路径数组初始化，无过渡动画，指定当前展示图片的下标
- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths currentIndex:(NSUInteger)index;
/// 图片远程url数组初始化，无过渡动画，指定当前展示图片的下标
- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs currentIndex:(NSUInteger)index;

/// 图片数组初始化，有过渡动画，presentViewController时animated参数传NO
- (instancetype)initWithImages:(NSArray<UIImage *> *)images fromFrame:(CGRect)fromFrame;
/// 图片本地路径数组初始化，有过渡动画，presentViewController时animated参数传NO
- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths fromFrame:(CGRect)fromFrame;
/// 图片远程url数组初始化，有过渡动画，presentViewController时animated参数传NO
- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs fromFrame:(CGRect)fromFrame;

/// 图片数组初始化，有过渡动画，指定当前展示图片的下标，presentViewController时animated参数传NO
- (instancetype)initWithImages:(NSArray<UIImage *> *)images fromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index;
/// 图片本地路径数组初始化，有过渡动画，指定当前展示图片的下标，presentViewController时animated参数传NO
- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths fromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index;
/// 图片远程url数组初始化，有过渡动画，指定当前展示图片的下标，presentViewController时animated参数传NO
- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs fromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
