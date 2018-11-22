//
//  ADImageViewWrapperScrollView.m
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADImageViewWrapperScrollView.h"

@implementation ADImageViewWrapperScrollView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"Began ---- %@", NSStringFromCGPoint(point));
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"Moved ---- %@", NSStringFromCGPoint(point));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"Ended ---- %@", NSStringFromCGPoint(point));
}

@end
