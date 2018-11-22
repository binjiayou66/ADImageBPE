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
/// 是否为异形屏
static inline BOOL ad_isAbnormalScreen() { CGSize size = [UIScreen mainScreen].bounds.size; return (MIN(size.width, size.height) / MAX(size.width, size.height)) < 0.55; };

NS_ASSUME_NONNULL_BEGIN

@interface ADImageBPEDefinition : NSObject

@end

NS_ASSUME_NONNULL_END
