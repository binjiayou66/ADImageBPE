//
//  ADImagePickerController.m
//  ADImageBPE
//
//  Created by Andy on 2018/12/11.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADImagePickerController.h"
#import "ADAssetPickerController.h"

@interface ADImagePickerController ()

@end

@implementation ADImagePickerController

- (instancetype)init
{
    if (self = [super initWithRootViewController:[[ADAssetPickerController alloc] init]]) {
        self.maximumCount = NSIntegerMax;
        self.minimumCount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                NSFontAttributeName : [UIFont systemFontOfSize:18] };
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor colorWithWhite:0.1 alpha:0.1];
}

- (void)setMaximumCount:(NSInteger)maximumCount
{
    _maximumCount = maximumCount;
    if ([self.viewControllers.firstObject respondsToSelector:@selector(setMaximumCount:)]) {
        [(id)self.viewControllers.firstObject setMaximumCount:maximumCount];
    }
}

- (void)setMinimumCount:(NSInteger)minimumCount
{
    _minimumCount = minimumCount;
    if ([self.viewControllers.firstObject respondsToSelector:@selector(setMinimumCount:)]) {
        [(id)self.viewControllers.firstObject setMinimumCount:minimumCount];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}

- (void)dealloc
{
    NSLog(@"ADImagePickerController dealloc.");
}

@end
