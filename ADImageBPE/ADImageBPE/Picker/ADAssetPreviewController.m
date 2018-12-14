//
//  ADAssetPreviewController.m
//  ADImageBPE
//
//  Created by Andy on 2018/12/12.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADAssetPreviewController.h"
#import "ADAssetPreviewCell.h"

@interface ADAssetPreviewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ADAssetPreviewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ADAssetPreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.frame = self.view.bounds;
    self.collectionView.contentOffset = CGPointMake(self.currentIndex * self.view.bounds.size.width, 0);
}

- (void)reloadImageAtIndex:(NSInteger)index
{
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)setNavigationBarHidden:(BOOL)hidden
{
    self.navigationController.navigationBar.hidden = hidden;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = floor((scrollView.contentOffset.x - scrollView.bounds.size.width / 2) / scrollView.bounds.size.width)+ 1;
}

#pragma mark - UICollection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(assetBrowserControllerNumberOfImages:)]) {
        return [self.delegate assetBrowserControllerNumberOfImages:self];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADAssetPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ADAssetPreviewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    if ([self.delegate respondsToSelector:@selector(assetBrowserController:imageAtIndex:)]) {
        cell.imageView.image = [self.delegate assetBrowserController:self imageAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - ADImageBrowserCellDelegate

- (void)imageBrowserCell:(ADAssetPreviewCell *)cell panChangedWithTranslationPoint:(CGPoint)translationPoint
{
    CGFloat alpha = 1 - translationPoint.y * 2 / [[UIScreen mainScreen] bounds].size.height;
    alpha = MAX(0, MIN(1, alpha));
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
}

- (void)imageBrowserCell:(ADAssetPreviewCell *)cell panEndedWithTranslationPoint:(CGPoint)translationPoint
{
    [self.navigationController popViewControllerAnimated:NO];
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
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ADAssetPreviewCell class] forCellWithReuseIdentifier:NSStringFromClass([ADAssetPreviewCell class])];
    }
    return _collectionView;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
        if ([self.delegate respondsToSelector:@selector(assetBrowserControllerDidChangeCurrentIndex:)]) {
            [self.delegate assetBrowserControllerDidChangeCurrentIndex:self];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
