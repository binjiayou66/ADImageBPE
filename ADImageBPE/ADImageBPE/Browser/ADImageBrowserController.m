//
//  ADImageBrowserController.m
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADImageBrowserController.h"
#import "ADImageBrowserDataSource.h"

@interface ADImageBrowserController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ADImageBrowserDataSource *dataSource;

@end

@implementation ADImageBrowserController

- (instancetype)initWithImages:(NSArray<UIImage *> *)images
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - getter and setter

- (ADImageBrowserDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[ADImageBrowserDataSource alloc] init];
    }
    return _dataSource;
}

@end
