//
//  GalleryViewController(Layout)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryViewController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "ReuseIdentifierProviderProtocol.h"

@interface GalleryViewController (Layout) <CHTCollectionViewDelegateWaterfallLayout, ReuseIdentifierProviderProtocol>

- (void)updateGalleryLayoutForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end