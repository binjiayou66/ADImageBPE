//
//  ADImagePickerTabBar.h
//  ADImageBPE
//
//  Created by Andy on 2018/12/11.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADImagePickerTabBar;

@protocol ADImagePickerTabBarDelegate <NSObject>

- (void)tabBarDidClickedLeftButton:(ADImagePickerTabBar *)tabBar;
- (void)tabBarDidClickedRightButton:(ADImagePickerTabBar *)tabBar;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ADImagePickerTabBar : UIView

@property (nonatomic, weak) id<ADImagePickerTabBarDelegate> delegate;
@property (nonatomic, strong, readonly) UIButton *leftButton;
@property (nonatomic, strong, readonly) UIButton *rightButton;

@end

NS_ASSUME_NONNULL_END
