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

@end

NS_ASSUME_NONNULL_END
