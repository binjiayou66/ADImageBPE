//
//  ADAssetPreviewController.m
//  ADImageBPE
//
//  Created by Andy on 2018/12/12.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADAssetPreviewController.h"
#import "ADAssetPreviewCell.h"
#import "ADImageBPEDefinition.h"

@interface ADAssetPreviewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ADAssetPreviewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<PHAsset *> *assets;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIImageView *captureImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *animationImageView;

@end

@implementation ADAssetPreviewController

- (instancetype)initWithAssets:(NSArray<PHAsset *> *)assets currentIndex:(NSInteger)currentIndex
{
    if (self = [super init]) {
        self.assets = assets;
        self.currentIndex = currentIndex;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%ld/%ld", self.currentIndex + 1, self.assets.count];
    
    self.captureImageView.frame = self.view.bounds;
    self.captureImageView.image = [self _capture];
    [self.view addSubview:self.captureImageView];
    
    self.maskView.frame = self.view.bounds;
    [self.view addSubview:self.maskView];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.animationImageView];
    
    self.collectionView.frame = self.view.bounds;
    self.collectionView.contentOffset = CGPointMake(self.currentIndex * self.view.bounds.size.width, 0);
}

- (void)dealloc
{
    NSLog(@"ADAssetPreviewController dealloc.");
}

#pragma mark - public method

- (void)setNavigationBarHidden:(BOOL)hidden
{
    self.navigationController.navigationBar.hidden = hidden;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = floor((scrollView.contentOffset.x - scrollView.bounds.size.width / 2) / scrollView.bounds.size.width)+ 1;
    self.title = [NSString stringWithFormat:@"%ld/%ld", self.currentIndex + 1, self.assets.count];
}

#pragma mark - UICollection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADAssetPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ADAssetPreviewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row < self.assets.count) {
        PHAsset *asset = self.assets[indexPath.row];
        PHImageManager *imageManager = [PHImageManager defaultManager];
        PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
        [imageManager requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeAspectFit options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.imageView.image = result;
        }];
    }
    
    return cell;
}

#pragma mark - ADImageBrowserCellDelegate

- (void)imageBrowserCell:(ADAssetPreviewCell *)cell panChangedWithTranslationPoint:(CGPoint)translationPoint
{
    CGFloat alpha = 1 - translationPoint.y * 2 / [[UIScreen mainScreen] bounds].size.height;
    alpha = MAX(0, MIN(1, alpha));
    self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
}

- (void)imageBrowserCell:(ADAssetPreviewCell *)cell panEndedWithTranslationPoint:(CGPoint)translationPoint
{
    [self _dismissAnimationWithFrame:cell.imageView.frame completion:^{
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - private method

- (UIImage *)_capture
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, window.opaque, 0.0);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *rt = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rt;
}

- (void)_dismissAnimationWithFrame:(CGRect)frame completion:(void(^)(void))completion
{
    self.animationImageView.alpha = 1;
    self.animationImageView.image = [(ADAssetPreviewCell *)self.collectionView.visibleCells.firstObject imageView].image;
    self.animationImageView.frame = frame;
    self.collectionView.hidden =  YES;
    CGRect toFrame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(assetPreviewControllerAnimationToFrame:)]) {
        toFrame = [self.delegate assetPreviewControllerAnimationToFrame:self];
    }
    if (CGRectIsEmpty(toFrame)) {
        if (completion) completion();
    } else {
        [UIView animateWithDuration:ADAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.maskView.backgroundColor = [UIColor clearColor];
            self.animationImageView.frame = toFrame;
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }
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

- (UIImageView *)captureImageView
{
    if (!_captureImageView) {
        _captureImageView = [[UIImageView alloc] init];
    }
    return _captureImageView;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor blackColor];
    }
    return _maskView;
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
