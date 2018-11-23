//
//  ADImageBrowserController.h
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADImageBrowserController;

@protocol ADImageBrowserControllerDataSource <NSObject>

- (NSUInteger)imageBrowserControllerNumberOfImages:(ADImageBrowserController *)controller;
- (UIImage *)imageBrowserController:(ADImageBrowserController *)controller imageAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ADImageBrowserController : UIViewController

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

#pragma mark - 代理方式浏览图片，优先级最高

@property (nonatomic, weak) id<ADImageBrowserControllerDataSource> delegate;
/// 代理方式初始化方法，有过渡动画，presentViewController时animated参数传NO
- (instancetype)initWithFromFrame:(CGRect)fromFrame;
/// 代理方式初始化方法，有过渡动画，presentViewController时animated参数传NO
- (instancetype)initWithFromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index;

#pragma mark - 无动画版浏览图片，可指定当前展示图片下标，缺省下标为0

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

#pragma mark - 有动画版浏览图片，需提供当前展示图片ImageView的frame，可指定当前展示图片下标，缺省下标为0

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
