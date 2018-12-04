//
//  ADImagePickerDataSource.h
//  ADImageBPE
//
//  Created by Andy on 2018/12/3.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ADImagePickerDataSource : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *data;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END
