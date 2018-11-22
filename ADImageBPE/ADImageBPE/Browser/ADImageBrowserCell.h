//
//  ADImageBrowserCell.h
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADImageBrowserCell;

@protocol ADImageBrowserCellDelegate <NSObject>

- (void)imageBrowserCellApplyDismiss:(ADImageBrowserCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ADImageBrowserCell : UICollectionViewCell

@property (nonatomic, weak) id<ADImageBrowserCellDelegate> delegate;
@property (nonatomic, strong, readonly) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
