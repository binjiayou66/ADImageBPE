//
//  ADAssetPreviewCell.m
//  ADImageBPE
//
//  Created by Andy on 2018/12/12.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADAssetPreviewCell.h"
#import "ADImageBPEDefinition.h"
#import "ADAssetPreviewController.h"

@interface ADAssetPreviewCell ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGPoint imageViewOriginCenter;

@end

@implementation ADAssetPreviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    self.imageView.frame = self.scrollView.bounds;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        if (self.scrollView.contentSize.height > self.contentView.bounds.size.height) { return NO; }
        CGPoint velocity = [gestureRecognizer velocityInView:self.contentView];
        return velocity.y > 0 && (fabs(velocity.y) > fabs(velocity.x));
    }
    return YES;
}

#pragma mark - event

- (void)onTap
{
    [self.delegate setNavigationBarHidden:!(self.delegate.navigationController.navigationBar.isHidden)];
}

- (void)onDoubleTap
{
    CGFloat scale = self.scrollView.zoomScale > 1.0f ? 1.0f : 2.0f;
    [self.scrollView setZoomScale:scale animated:YES];
}

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.imageViewOriginCenter = self.imageView.center;
        [self.delegate setNavigationBarHidden:YES];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint transPoint = [pan translationInView:self];
        CGFloat scale = 1 - transPoint.y * 2 / [[UIScreen mainScreen] bounds].size.height;
        scale = MAX(0.5, MIN(scale, 1));
        self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
        self.imageView.center = CGPointMake(self.imageViewOriginCenter.x + transPoint.x, self.imageViewOriginCenter.y + transPoint.y);
        if ([self.delegate respondsToSelector:@selector(imageBrowserCell:panChangedWithTranslationPoint:)]) {
            [self.delegate imageBrowserCell:self panChangedWithTranslationPoint:transPoint];
        }
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint transPoint = [pan translationInView:self];
        if (transPoint.y > 44) {
            if ([self.delegate respondsToSelector:@selector(imageBrowserCell:panEndedWithTranslationPoint:)]) {
                [self.delegate imageBrowserCell:self panEndedWithTranslationPoint:transPoint];
            }
        } else {
            [UIView animateWithDuration:ADAnimationDuration animations:^{
                self.imageView.transform = CGAffineTransformMakeScale(1, 1);
                self.imageView.frame = self.scrollView.bounds;
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(imageBrowserCell:panChangedWithTranslationPoint:)]) {
                    [self.delegate imageBrowserCell:self panChangedWithTranslationPoint:CGPointZero];
                }
                [self.delegate setNavigationBarHidden:NO];
            }];
        }
    }
}

#pragma mark - getter and setter

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.maximumZoomScale = 2.0f;
        _scrollView.minimumZoomScale = 1.0f;
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [_imageView addGestureRecognizer:tap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap)];
        doubleTap.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:doubleTap];
        [tap requireGestureRecognizerToFail:doubleTap];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        pan.delegate = self;
        [_imageView addGestureRecognizer:pan];
    }
    return _imageView;
}

@end
