//
//  ADAssetPreviewController.h
//  ADImageBPE
//
//  Created by Andy on 2018/12/12.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class ADAssetPreviewController;

@protocol ADAssetPreviewControllerDelegate <NSObject>

@optional
- (CGRect)assetPreviewControllerAnimationToFrame:(ADAssetPreviewController *)controller;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ADAssetPreviewController : UIViewController

- (instancetype)initWithAssets:(NSArray<PHAsset *> *)assets currentIndex:(NSInteger)currentIndex;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, weak) id<ADAssetPreviewControllerDelegate> delegate;

- (void)setNavigationBarHidden:(BOOL)hidden;

@end

NS_ASSUME_NONNULL_END
