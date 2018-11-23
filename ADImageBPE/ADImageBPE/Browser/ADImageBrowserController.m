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

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, strong) UIImageView *animationImageView;
@property (nonatomic, assign) BOOL hasAnimation;
@property (nonatomic, assign) CGRect fromFrame;

@end

@implementation ADImageBrowserController

- (instancetype)initWithCurrentIndex:(NSUInteger)index
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.currentIndex = index;
    }
    return self;
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images
{
    return [self initWithImages:images currentIndex:0];
}

- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths
{
    return [self initWithImagePaths:imagePaths currentIndex:0];
}

- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs
{
    return [self initWithImageURLs:imageURLs currentIndex:0];
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images currentIndex:(NSUInteger)index
{
    if (self = [self initWithCurrentIndex:index]) {
        [self.dataSource loadData:images type:ADImageBrowserDataSourceDataTypeImage];
    }
    return self;
}

- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths currentIndex:(NSUInteger)index
{
    if (self = [self initWithCurrentIndex:index]) {
        [self.dataSource loadData:imagePaths type:ADImageBrowserDataSourceDataTypePath];
    }
    return self;
}

- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs currentIndex:(NSUInteger)index
{
    if (self = [self initWithCurrentIndex:index]) {
        [self.dataSource loadData:imageURLs type:ADImageBrowserDataSourceDataTypeURL];
    }
    return self;
}

- (instancetype)initWithFromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index
{
    if (self = [super init]) {
        self.currentIndex = index;
        self.hasAnimation = !CGRectIsEmpty(fromFrame);
        if (self.hasAnimation) {
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            self.fromFrame = fromFrame;
        }
    }
    return self;
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images fromFrame:(CGRect)fromFrame
{
    return [self initWithImages:images fromFrame:fromFrame currentIndex:0];
}

- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths fromFrame:(CGRect)fromFrame
{
    return [self initWithImagePaths:imagePaths fromFrame:fromFrame currentIndex:0];
}

- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs fromFrame:(CGRect)fromFrame
{
    return [self initWithImageURLs:imageURLs fromFrame:fromFrame currentIndex:0];
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images fromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index
{
    if (self = [self initWithFromFrame:fromFrame currentIndex:index]) {
        [self.dataSource loadData:images type:ADImageBrowserDataSourceDataTypeImage];
    }
    return self;
}

- (instancetype)initWithImagePaths:(NSArray<NSString *> *)imagePaths fromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index
{
    if (self = [self initWithFromFrame:fromFrame currentIndex:index]) {
        [self.dataSource loadData:imagePaths type:ADImageBrowserDataSourceDataTypePath];
    }
    return self;
}

- (instancetype)initWithImageURLs:(NSArray<NSURL *> *)imageURLs fromFrame:(CGRect)fromFrame currentIndex:(NSUInteger)index
{
    if (self = [self initWithFromFrame:fromFrame currentIndex:index]) {
        [self.dataSource loadData:imageURLs type:ADImageBrowserDataSourceDataTypeURL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = self.hasAnimation ? [UIColor clearColor] : [UIColor blackColor];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.animationImageView];
    
    self.collectionView.frame = self.view.bounds;
    self.collectionView.contentOffset = CGPointMake(self.currentIndex * self.view.bounds.size.width, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.hasAnimation) {
        [self _presentAnimation];
    }
}

- (void)dealloc
{
    NSLog(@"ADImageBrowserController dealloc.");
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
    if (self.hasAnimation) {
        [self _dismissAnimationWithFrame:self.view.bounds completion:^{
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imageBrowserCell:(ADImageBrowserCell *)cell panChangedWithTranslationPoint:(CGPoint)translationPoint
{
    CGFloat alpha = 1 - translationPoint.y * 2 / [[UIScreen mainScreen] bounds].size.height;
    alpha = MAX(0, MIN(1, alpha));
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
}

- (void)imageBrowserCell:(ADImageBrowserCell *)cell panEndedWithTranslationPoint:(CGPoint)translationPoint
{
    if (self.hasAnimation) {
        [self _dismissAnimationWithFrame:cell.imageView.frame completion:^{
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    } else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - private method

- (void)_presentAnimation
{
    self.animationImageView.alpha = 1;
    self.animationImageView.image = self.dataSource.dataSource[self.currentIndex];
    self.animationImageView.frame = self.fromFrame;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGSize tempSize = self.animationImageView.image.size;
    CGSize endSize = CGSizeMake(screenSize.width, (tempSize.height * screenSize.width / tempSize.width) > screenSize.height ? screenSize.height:(tempSize.height * screenSize.width / tempSize.width));
    
    self.collectionView.hidden =  YES;
    [UIView animateWithDuration:ADAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.backgroundColor = [UIColor blackColor];
        self.animationImageView.bounds = (CGRect){CGPointZero,endSize};
        self.animationImageView.center = self.view.center;
    } completion:^(BOOL finished) {
        self.collectionView.hidden = NO;
        [UIView animateWithDuration:ADAnimationDuration animations:^{
            [self.animationImageView setAlpha:0];
        }];
    }];
}

- (void)_dismissAnimationWithFrame:(CGRect)frame completion:(void(^)(void))completion
{
    self.animationImageView.alpha = 1;
    self.animationImageView.image = [(ADImageBrowserCell *)self.collectionView.visibleCells.firstObject imageView].image;
    self.animationImageView.frame = frame;
    self.collectionView.hidden =  YES;
    [UIView animateWithDuration:ADAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.backgroundColor = [UIColor clearColor];
        self.animationImageView.frame = self.fromFrame;
    } completion:^(BOOL finished) {
        completion();
    }];
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

- (UIImageView *)animationImageView
{
    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] init];
        _animationImageView.contentMode = UIViewContentModeScaleAspectFit;
        _animationImageView.alpha = 0;
    }
    return _animationImageView;
}

@end
