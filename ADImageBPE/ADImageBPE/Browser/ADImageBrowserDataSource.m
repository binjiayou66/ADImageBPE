//
//  ADImageBrowserDataSource.m
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADImageBrowserDataSource.h"

@interface ADImageBrowserDataSource ()

@property (nonatomic, strong) NSMutableArray<UIImage *> *dataSource;
@property (nonatomic, strong) NSArray *originData;

@end

@implementation ADImageBrowserDataSource

- (void)loadData:(NSArray *)data type:(ADImageBrowserDataSourceDataType)type
{
    self.originData = data;
    switch (type) {
        case ADImageBrowserDataSourceDataTypeImage:
        {
            self.dataSource.array = data;
            break;
        }
        case ADImageBrowserDataSourceDataTypePath:
        {
            break;
        }
        case ADImageBrowserDataSourceDataTypeURL:
        {
            break;
        }
        default:
        {
            self.dataSource.array = @[];
            break;
        }
    }
}

- (nullable UIImage *)imageAtIndex:(NSUInteger)index
{
    if (index < self.dataSource.count) {
        return self.dataSource[index];
    }
    return nil;
}

#pragma mark - getter and setter

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSUInteger)dataCount
{
    return self.originData.count;
}

@end
