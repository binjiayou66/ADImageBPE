//
//  ADImageBrowserDataSource.m
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADImageBrowserDataSource.h"

@interface ADImageBrowserDataSource ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation ADImageBrowserDataSource

#pragma mark - getter and setter

- (NSMutableArray *)data
{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

@end
