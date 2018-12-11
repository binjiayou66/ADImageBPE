//
//  ADImageBPEDefinition.h
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 正常屏幕导航栏高度
extern CGFloat const ADNormalNavigationBarHeight;
/// 异型屏幕导航栏高度
extern CGFloat const ADAbnormalNavigationBarHeight;
/// 正常屏幕tabbar高度
extern CGFloat const ADNormalTabBarHeight;
/// 异型屏幕tabbar高度
extern CGFloat const ADAbnormalTabBarHeight;
/// 动画时长
extern NSTimeInterval const ADAnimationDuration;
/// 是否为异形屏
static inline BOOL ad_isAbnormalScreen() { CGSize size = [UIScreen mainScreen].bounds.size; return (MIN(size.width, size.height) / MAX(size.width, size.height)) < 0.55; };
static inline CGRect ad_screenBounds() { return [[UIScreen mainScreen] bounds]; };
static inline CGSize ad_screenSize() { return [[UIScreen mainScreen] bounds].size; };
static inline CGFloat ad_screenHeight() { return [[UIScreen mainScreen] bounds].size.height; };
static inline CGFloat ad_screenWith() { return [[UIScreen mainScreen] bounds].size.width; };

extern CGFloat const ADImagePickerCollectionViewItemCountPerRow;
extern CGFloat const ADImagePickerCollectionViewLineSpacing;
extern CGFloat const ADImagePickerCollectionViewInteritemSpacing;
static inline CGFloat ADImagePickerCollectionViewItemWidth() { return ([[UIScreen mainScreen] bounds].size.width - (ADImagePickerCollectionViewItemCountPerRow + 1) * ADImagePickerCollectionViewLineSpacing) / ADImagePickerCollectionViewItemCountPerRow; };

NS_ASSUME_NONNULL_BEGIN

@interface ADImageBPEDefinition : NSObject

@end

NS_ASSUME_NONNULL_END
