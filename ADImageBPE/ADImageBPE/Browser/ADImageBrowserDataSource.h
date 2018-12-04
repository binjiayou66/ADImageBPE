//
//  ADImageBrowserDataSource.h
//  ADImageBPE
//
//  Created by Andy on 2018/11/22.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ADImageBrowserDataSourceDataType) {
    ADImageBrowserDataSourceDataTypeUnknown = 0,
    ADImageBrowserDataSourceDataTypeImage,
    ADImageBrowserDataSourceDataTypePath,
    ADImageBrowserDataSourceDataTypeURL,
};

NS_ASSUME_NONNULL_BEGIN

@interface ADImageBrowserDataSource : NSObject

@property (nonatomic, assign, readonly) NSUInteger dataCount;
@property (nonatomic, strong, readonly) NSMutableArray<UIImage *> *data;

- (void)loadData:(NSArray *)data type:(ADImageBrowserDataSourceDataType)type;
- (nullable UIImage *)imageAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
