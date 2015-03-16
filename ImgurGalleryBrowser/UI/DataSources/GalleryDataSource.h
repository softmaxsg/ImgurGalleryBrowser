//
//  GalleryDataSource.h
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import UIKit;
#import "IncrementalDataLoadingProtocol.h"

@protocol DataSourceProtocol;

@interface GalleryDataSource : NSObject<UICollectionViewDataSource, IncrementalDataLoadingProtocol>

- (instancetype)initWithViewModel:(id <DataSourceProtocol>)viewModel;
+ (instancetype)dataSourceWithViewModel:(id <DataSourceProtocol>)viewModel;

- (void)registerCollectionViewReusableClasses:(UICollectionView *)collectionView;

@end

@interface GalleryDataSource (Unavailable)

- (instancetype)init __attribute__((unavailable("Use initWithViewModel: instead")));

@end
