//
//  ADImagePickerController.h
//  ADImageBPE
//
//  Created by Andy on 2018/12/11.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADImagePickerController;

// ADImagePickerController:UINavigationController
// - ADAlbumPickerController
// - ADAssetPickerController
// - ADAssetPreviewController

@protocol ADImagePickerControllerDelegate <NSObject>

- (void)imagePickerController:(ADImagePickerController *)picker didFinishPickingImages:(NSArray<UIImage *> *)images;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ADImagePickerController : UINavigationController

@property (nonatomic, assign) NSInteger maximumCount;
@property (nonatomic, assign) NSInteger minimumCount;
@property (nonatomic, assign) id<ADImagePickerControllerDelegate> pickDelegate;

@end

NS_ASSUME_NONNULL_END
