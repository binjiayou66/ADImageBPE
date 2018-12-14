//
//  ADAssetPreviewCell.h
//  ADImageBPE
//
//  Created by Andy on 2018/12/12.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADAssetPreviewCell;
@class ADAssetPreviewController;

@protocol ADAssetPreviewCellDelegate <NSObject>

- (void)imageBrowserCell:(ADAssetPreviewCell *)cell panChangedWithTranslationPoint:(CGPoint)translationPoint;
- (void)imageBrowserCell:(ADAssetPreviewCell *)cell panEndedWithTranslationPoint:(CGPoint)translationPoint;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ADAssetPreviewCell : UICollectionViewCell

@property (nonatomic, weak) ADAssetPreviewController<ADAssetPreviewCellDelegate> *delegate;
@property (nonatomic, strong, readonly) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
