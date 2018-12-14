//
//  ADAssetPreviewController.h
//  ADImageBPE
//
//  Created by Andy on 2018/12/12.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADAssetPreviewController;

@protocol ADAssetPreviewControllerDataSource <NSObject>

- (NSUInteger)assetBrowserControllerNumberOfImages:(ADAssetPreviewController *)controller;
- (UIImage *)assetBrowserController:(ADAssetPreviewController *)controller imageAtIndex:(NSUInteger)index;

@optional
- (void)assetBrowserControllerDidChangeCurrentIndex:(ADAssetPreviewController *)controller;
- (CGRect)assetBrowserControllerAnimationFromFrame:(ADAssetPreviewController *)controller;
- (CGRect)assetBrowserControllerAnimationToFrame:(ADAssetPreviewController *)controller;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ADAssetPreviewController : UIViewController

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, weak) id<ADAssetPreviewControllerDataSource> delegate;

- (void)reloadImageAtIndex:(NSInteger)index;
- (void)setNavigationBarHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
