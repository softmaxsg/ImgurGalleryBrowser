//
//  IncrementalDataLoadingProtocol
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IncrementalDataLoadingProtocol <NSObject>

- (BOOL)loadingInProgress;

- (BOOL)nextBatchAvailable;
- (void)loadNextBatch;

@end