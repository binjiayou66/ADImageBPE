//
//  ADAssetPickerCell.h
//  ADImageBPE
//
//  Created by Andy on 2018/12/10.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADAssetPickerCell;

@protocol ADAssetPickerCellDelegate <NSObject>

- (void)assetPickerCellDidClickedButton:(ADAssetPickerCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ADAssetPickerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<ADAssetPickerCellDelegate> delegate;

- (void)resetButtonStyle;
- (void)setButtonAsPickedWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
