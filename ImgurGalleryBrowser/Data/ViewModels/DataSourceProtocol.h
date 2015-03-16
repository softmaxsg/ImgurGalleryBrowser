//
//  DataSourceProtocol
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataSourceProtocol <NSObject>

@property (nonatomic, readonly) NSUInteger itemsCount;
- (id)itemForIndexPath:(NSIndexPath *)indexPath;

@end