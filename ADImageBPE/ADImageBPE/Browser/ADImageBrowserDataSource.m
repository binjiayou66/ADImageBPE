//
//  ADImageBrowserDataSource.m
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADImageBrowserDataSource.h"

@interface ADImageBrowserDataSource ()

@property (nonatomic, strong) NSMutableArray<UIImage *> *data;
@property (nonatomic, strong) NSArray *originData;

@end

@implementation ADImageBrowserDataSource

- (void)loadData:(NSArray *)data type:(ADImageBrowserDataSourceDataType)type
{
    self.originData = data;
    switch (type) {
        case ADImageBrowserDataSourceDataTypeImage:
        {
            self.data.array = data;
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
            self.data.array = @[];
            break;
        }
    }
}

- (nullable UIImage *)imageAtIndex:(NSUInteger)index
{
    if (index < self.data.count) {
        return self.data[index];
    }
    return nil;
}

#pragma mark - getter and setter

- (NSMutableArray *)data
{
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (NSUInteger)dataCount
{
    return self.originData.count;
}

@end
