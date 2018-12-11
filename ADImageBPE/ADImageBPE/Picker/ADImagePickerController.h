//
//  ADImagePickerController.h
//  ADImageBPE
//
//  Created by Andy on 2018/12/11.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

// ADImagePickerController:UINavigationController
// - ADAlbumPickerController
// - ADAssetPickerController
// - ADImagePreviewBrowserController

NS_ASSUME_NONNULL_BEGIN

@interface ADImagePickerController : UINavigationController

@property (nonatomic, assign) NSInteger maximumCount;
@property (nonatomic, assign) NSInteger minimumCount;

@end

NS_ASSUME_NONNULL_END
