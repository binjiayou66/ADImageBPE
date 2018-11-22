//
//  ADImageBrowserController.m
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADImageBrowserController.h"
#import "ADImageBrowserDataSource.h"
#import "ADImageBrowserCell.h"
#import "ADImageBPEDefinition.h"

@interface ADImageBrowserController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ADImageBrowserCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ADImageBrowserDataSource *dataSource;

@end

@implementation ADImageBrowserController

- (instancetype)init
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images
{
    if (self = [super init]) {
        [self.dataSource loadData:images type:ADImageBrowserDataSourceDataTypeImage];
    }
    return self;
}

- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths
{
    if (self = [super init]) {
        [self.dataSource loadData:imagePaths type:ADImageBrowserDataSourceDataTypePath];
    }
    return self;
}

- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs
{
    if (self = [super init]) {
        [self.dataSource loadData:imageURLs type:ADImageBrowserDataSourceDataTypeURL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.collectionView];
    [self _layoutSubviews];
}

#pragma mark - UICollection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.dataCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ADImageBrowserCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.imageView.image = self.dataSource.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - ADImageBrowserCellDelegate

- (void)imageBrowserCellApplyDismiss:(ADImageBrowserCell *)cell
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private method

- (void)_layoutSubviews
{
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - getter and setter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        layout.itemSize = self.view.bounds.size;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[ADImageBrowserCell class] forCellWithReuseIdentifier:NSStringFromClass([ADImageBrowserCell class])];
    }
    return _collectionView;
}

- (ADImageBrowserDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[ADImageBrowserDataSource alloc] init];
    }
    return _dataSource;
}

@end
