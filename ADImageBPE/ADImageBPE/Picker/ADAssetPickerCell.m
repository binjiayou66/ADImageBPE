//
//  ADAssetPickerCell.m
//  ADImageBPE
//
//  Created by Andy on 2018/12/10.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADAssetPickerCell.h"

@interface ADAssetPickerCell ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ADAssetPickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self resetButtonStyle];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
    self.button.frame = CGRectMake(self.bounds.size.width - 26, 2, 24, 24);
}

- (void)resetButtonStyle
{
    [self.button setTitle:@"√" forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    self.button.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setButtonAsPickedWithIndex:(NSInteger)index
{
    [self.button setTitle:[NSString stringWithFormat:@"%ld", index] forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor colorWithRed:50/255.0 green:170/255.0 blue:60/255.0 alpha:1];
    self.button.layer.borderColor = [UIColor colorWithRed:50/255.0 green:170/255.0 blue:60/255.0 alpha:1].CGColor;
}

- (void)onClickButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(assetPickerCellDidClickedButton:)]) {
        [self.delegate assetPickerCellDidClickedButton:self];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
        [_button setTitle:@"√" forState:UIControlStateNormal];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 12;
        _button.layer.borderColor = [UIColor whiteColor].CGColor;
        _button.layer.borderWidth = 1;
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
