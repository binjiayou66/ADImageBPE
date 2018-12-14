//
//  ADAssetPickerController.m
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADAssetPickerController.h"
#import "ADAssetPickerDataSource.h"
#import "ADAssetPickerCell.h"
#import "ADImagePickerTabBar.h"
#import "ADImageBPEDefinition.h"
#import "ADImagePickerController.h"
#import "ADAssetPreviewController.h"

@interface ADAssetPickerController ()<ADAssetPickerDataSourceDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ADAssetPickerCellDelegate, ADImagePickerTabBarDelegate, ADAssetPreviewControllerDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ADAssetPickerDataSource *dataSource;
@property (nonatomic, strong) ADImagePickerTabBar *tabBar;
@property (nonatomic, strong) NSMutableDictionary *previewDataSource;

@end

@implementation ADAssetPickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onClickRightBarButton)];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tabBar];
    
    CGFloat originY = ad_isAbnormalScreen() ? ADAbnormalNavigationBarHeight : ADNormalNavigationBarHeight;
    self.collectionView.frame = CGRectMake(0, originY, ad_screenWith(), ad_screenHeight() - originY);
    CGFloat tabBarHeight = ad_isAbnormalScreen() ? ADAbnormalTabBarHeight : ADNormalTabBarHeight;
    self.tabBar.frame = CGRectMake(0, ad_screenHeight() - tabBarHeight, ad_screenWith(), tabBarHeight);
    
    [self.dataSource loadData];
}

- (void)onClickRightBarButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ADAssetPickerDataSourceDelegate

- (void)assetPickerDataSourceLoadDataSuccess:(ADAssetPickerDataSource *)dataSource
{
    [self.collectionView reloadData];
}

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.thumbnailImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADAssetPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADImagePickerCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataSource.thumbnailImages.count) {
        cell.imageView.image = self.dataSource.thumbnailImages[indexPath.row];
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    NSInteger pickedIndex = [self.dataSource pickedIndexOfImageAtIndex:indexPath.row];
    if (pickedIndex != NSNotFound) {
        [cell setButtonAsPickedWithIndex:pickedIndex + 1];
    } else {
        [cell resetButtonStyle];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataSource requestImageAtIndex:indexPath.row contentMode:PHImageContentModeAspectFit resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            self.previewDataSource[@(indexPath.row)] = result;
            if ([self.navigationController.viewControllers.lastObject isKindOfClass:[ADAssetPreviewController class]]) {
                ADAssetPreviewController *preview = (id)self.navigationController.viewControllers.lastObject;
                [preview reloadImageAtIndex:indexPath.row];
            } else {
                ADAssetPreviewController *preview = [[ADAssetPreviewController alloc] init];
                preview.delegate = self;
                preview.currentIndex = indexPath.row;
                [self.navigationController pushViewController:preview animated:YES];
            }
        }
    }];
}

#pragma mark - ADAssetPickerCellDelegate

- (void)assetPickerCellDidClickedButton:(ADAssetPickerCell *)cell
{
    NSInteger index = cell.indexPath.row;
    if ([self.dataSource hasPickedImageAtIndex:index]) {
        [self.dataSource unpickImageAtIndex:index];
        if (self.dataSource.pickedImageCount <= 0) {
            self.tabBar.leftButton.enabled = NO;
            self.tabBar.rightButton.enabled = NO;
            [self.tabBar.rightButton setTitle:@"确定" forState:UIControlStateNormal];
        } else {
            [self.tabBar.rightButton setTitle:[NSString stringWithFormat:@"确定(%ld)", self.dataSource.pickedImageCount] forState:UIControlStateNormal];
        }
    } else {
        if (self.dataSource.pickedImageCount >= self.maximumCount) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您最多能选择%ld张照片", self.maximumCount] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        [self.dataSource pickImageAtIndex:index];
        self.tabBar.leftButton.enabled = YES;
        self.tabBar.rightButton.enabled = YES;
        [self.tabBar.rightButton setTitle:[NSString stringWithFormat:@"确定(%ld)", self.dataSource.pickedImageCount] forState:UIControlStateNormal];
    }
    [self.collectionView reloadData];
}

#pragma mark - ADImagePickerTabBarDelegate

- (void)tabBarDidClickedLeftButton:(ADImagePickerTabBar *)tabBar
{
    
}

- (void)tabBarDidClickedRightButton:(ADImagePickerTabBar *)tabBar
{
    if ([self.navigationController isKindOfClass:[ADImagePickerController class]]) {
        ADImagePickerController *imagePicker = (id)self.navigationController;
        if ([imagePicker.pickDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingImages:)]) {
            [imagePicker.pickDelegate imagePickerController:imagePicker didFinishPickingImages:self.dataSource.pickedImages];
            [imagePicker dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - ADAssetPreviewControllerDataSource

- (NSUInteger)assetBrowserControllerNumberOfImages:(ADAssetPreviewController *)controller
{
    return self.dataSource.thumbnailImages.count;
}

- (UIImage *)assetBrowserController:(ADAssetPreviewController *)controller imageAtIndex:(NSUInteger)index
{
    UIImage *image = [self.previewDataSource objectForKey:@(index)];
    if (image) {
        return image;
    }
    return [UIImage imageNamed:@"ADAssetPickerPlaceholder"];
}

- (void)assetBrowserControllerDidChangeCurrentIndex:(ADAssetPreviewController *)controller
{
    NSInteger currentIndex = controller.currentIndex;
    NSLog(@" --- %ld -- %@", currentIndex, self.previewDataSource);
    if (currentIndex - 1 >= 0) {
        [self.dataSource requestImageAtIndex:currentIndex - 1 contentMode:PHImageContentModeAspectFit resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) self.previewDataSource[@(currentIndex - 1)] = result;
        }];
    }
    if (currentIndex - 2 >= 0) {
        [self.dataSource requestImageAtIndex:currentIndex - 2 contentMode:PHImageContentModeAspectFit resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) self.previewDataSource[@(currentIndex - 2)] = result;
        }];
    }
    if (currentIndex + 1 < self.dataSource.thumbnailImages.count) {
        [self.dataSource requestImageAtIndex:currentIndex + 1 contentMode:PHImageContentModeAspectFit resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) self.previewDataSource[@(currentIndex + 1)] = result;
        }];
    }
    if (currentIndex + 2 < self.dataSource.thumbnailImages.count) {
        [self.dataSource requestImageAtIndex:currentIndex + 2 contentMode:PHImageContentModeAspectFit resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) self.previewDataSource[@(currentIndex + 2)] = result;
        }];
    }
    NSLog(@" --- %@", self.previewDataSource);
    NSArray *retainIndex = @[@(currentIndex - 2), @(currentIndex - 1), @(currentIndex), @(currentIndex + 1), @(currentIndex + 2)];
    for (NSNumber *item in self.previewDataSource.allKeys) {
        if (![retainIndex containsObject:item]) {
            [self.previewDataSource removeObjectForKey:item];
        }
    }
    NSLog(@" --- %@", self.previewDataSource);
}

#pragma mark - getter and setter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = ADImagePickerCollectionViewLineSpacing;
        layout.minimumInteritemSpacing = ADImagePickerCollectionViewInteritemSpacing;
        CGFloat width = ADImagePickerCollectionViewItemWidth();
        layout.itemSize = CGSizeMake(width, width);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(ADImagePickerCollectionViewInteritemSpacing, ADImagePickerCollectionViewLineSpacing, ADImagePickerCollectionViewInteritemSpacing, ADImagePickerCollectionViewLineSpacing);
        [_collectionView registerClass:[ADAssetPickerCell class] forCellWithReuseIdentifier:@"ADImagePickerCell"];
    }
    return _collectionView;
}

- (ADAssetPickerDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[ADAssetPickerDataSource alloc] init];
        _dataSource.delegate = self;
    }
    return _dataSource;
}

- (ADImagePickerTabBar *)tabBar
{
    if (!_tabBar) {
        _tabBar = [[ADImagePickerTabBar alloc] init];
        _tabBar.delegate = self;
        [_tabBar.leftButton setTitle:@"预览" forState:UIControlStateNormal];
        [_tabBar.rightButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    return _tabBar;
}

- (NSMutableDictionary *)previewDataSource
{
    if (!_previewDataSource) {
        _previewDataSource = [[NSMutableDictionary alloc] init];
    }
    return _previewDataSource;
}

- (NSString *)title
{
    return @"所有照片";
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
