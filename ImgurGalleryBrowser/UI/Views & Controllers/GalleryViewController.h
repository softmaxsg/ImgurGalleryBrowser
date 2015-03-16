//
//  GalleryViewController.h
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import UIKit;
#import "UICollectionViewControllerEx.h"
#import "GalleryViewModel.h"

@class UISegmentedControlEx;

typedef NS_ENUM(NSUInteger, GalleryLayoutMode)
{
    GalleryLayoutModeGrid = 1,
    GalleryLayoutModeStaggeredGrid,
    GalleryLayoutModeList
};

@interface GalleryViewController : UICollectionViewControllerEx <GalleryViewModelDelegate>

@property (nonatomic, weak, readonly) UISegmentedControlEx *layoutModeSegmentedControl;
@property (nonatomic, weak, readonly) UISegmentedControlEx *windowKindSegmentedControl;
@property (nonatomic, weak, readonly) UISegmentedControlEx *sortModeSegmentedControl;
@property (nonatomic, weak, readonly) UISegmentedControlEx *viralItemsSegmentedControl;

@property (nonatomic, readonly) GalleryLayoutMode layoutMode;
@property (nonatomic) GalleryViewModel *viewModel;

- (instancetype)initWithViewModel:(GalleryViewModel *)viewModel;
+ (instancetype)controllerWithViewModel:(GalleryViewModel *)viewModel;

@end
