//
//  ADImagePickerTabBar.m
//  ADImageBPE
//
//  Created by Andy on 2018/12/11.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADImagePickerTabBar.h"

@interface ADImagePickerTabBar ()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ADImagePickerTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
        
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonWidth = 58;
    self.leftButton.frame = CGRectMake(0, 0, buttonWidth + 20, 48);
    self.rightButton.frame = CGRectMake(self.bounds.size.width - 16 - buttonWidth, 10, buttonWidth, 28);
}

#pragma mark - event

- (void)onLeftButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickedLeftButton:)]) {
        [self.delegate tabBarDidClickedLeftButton:self];
    }
}

- (void)onRightButtonClicked
{
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickedRightButton:)]) {
        [self.delegate tabBarDidClickedRightButton:self];
    }
}

#pragma mark - getter and setter

- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateHighlighted];
        [_leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateDisabled];
        _leftButton.enabled = NO;
        [_leftButton setTitle:@"左按钮" forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leftButton addTarget:self action:@selector(onLeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.backgroundColor = [UIColor colorWithRed:50/255.0 green:170/255.0 blue:60/255.0 alpha:1];
        _rightButton.layer.masksToBounds = YES;
        _rightButton.layer.cornerRadius = 3;
        [_rightButton setTitle:@"右按钮" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateHighlighted];
        [_rightButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateDisabled];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _rightButton.enabled = NO;
        [_rightButton addTarget:self action:@selector(onRightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end
