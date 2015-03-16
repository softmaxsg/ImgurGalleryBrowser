//
//  GalleryViewModel.h
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import CoreGraphics;
#import "BaseViewModel.h"
#import <BloodMagic/BMInjectable.h>
#import "DataSourceProtocol.h"
#import "IncrementalDataLoadingProtocol.h"

@protocol GalleryViewModelDelegate;

typedef NS_ENUM(NSUInteger, GallerySectionKind)
{
    GallerySectionKindUnknown = 0,
    GallerySectionKindHot,
    GallerySectionKindTop,
    GallerySectionKindUser
};

typedef NS_ENUM(NSUInteger, GalleryWindowKind)
{
    GalleryWindowKindAll = 0,
    GalleryWindowKindDay,
    GalleryWindowKindWeek,
    GalleryWindowKindMonth,
    GalleryWindowKindYear
};

typedef NS_ENUM(NSUInteger, GallerySortMode)
{
    GallerySortModeViral = 0,
    GallerySortModeTop,
    GallerySortModeTime,
    GallerySortModeRising
};

@interface GalleryViewModel : BaseViewModel<BMInjectable, DataSourceProtocol, IncrementalDataLoadingProtocol>

@property (nonatomic, weak) id <GalleryViewModelDelegate> delegate;

@property (nonatomic, readonly) GallerySectionKind sectionKind;
@property (nonatomic) GalleryWindowKind windowKind;
@property (nonatomic) GallerySortMode sortMode;
@property (nonatomic) BOOL showViral;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"
@property (nonatomic, readonly) NSUInteger itemsCount;

@property (nonatomic, readonly) BOOL loadingInProgress;
@property (nonatomic, readonly) BOOL nextBatchAvailable;
#pragma clang diagnostic pop

- (instancetype)initWithSectionKind:(GallerySectionKind)sectionKind;
+ (instancetype)modelWithSectionKind:(GallerySectionKind)sectionKind;

- (NSArray *)allowedWindowKinds;
- (NSArray *)allowedSortModes;
- (BOOL)allowedShowViralOption;

- (void)startLoading;
- (void)startLoading:(BOOL)clearItems;

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath bestFittingWidth:(CGFloat)width;

- (id)itemForIndexPath:(NSIndexPath *)indexPath;

@end

@protocol GalleryViewModelDelegate <NSObject>

@optional
- (void)viewModelDataLoadingStarted:(GalleryViewModel *)viewModel withClearingItems:(BOOL)itemsCleared;
- (void)viewModelDataLoaded:(GalleryViewModel *)viewModel;
- (void)viewModel:(GalleryViewModel *)viewModel dataLoadingFailed:(NSError *)error;

@end