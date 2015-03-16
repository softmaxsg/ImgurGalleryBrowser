//
//  GalleryViewModel.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryViewModel.h"
#import <libextobjc/EXTScope.h>
#import <ImgurSession/IMGGalleryImage.h>
#import <ImgurSession/IMGGalleryAlbum.h>
#import "ImgurServiceProtocol.h"
#import "ImgurService+Constants.h"
#import "GalleryViewModel+ImgurService.h"
#import "NSMutableDictionary+SafeExtras.h"
#import "IMGImage+Thumbnails.h"

@interface GalleryViewModel ()

@property (nonatomic) id<ImgurServiceProtocol> dataService;
@property (nonatomic) NSArray *items;

@property (nonatomic) NSMutableDictionary *lastLoadingParams;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"
@property (nonatomic) BOOL loadingInProgress;
@property (nonatomic) BOOL nextBatchAvailable;
#pragma clang diagnostic pop

- (void)notifyDelegateDataStartLoading:(BOOL)itemsCleared;
- (void)notifyDelegateDataLoaded;
- (void)notifyDelegateDataLoadingFailed:(NSError *)error;

@end

@implementation GalleryViewModel

@dynamic dataService;

- (void)setWindowKind:(GalleryWindowKind)windowKind
{
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSAssert(self.sectionKind == GallerySectionKindTop, @"Parameter window is available only for Top section");
#pragma clang diagnostic pop

    _windowKind = windowKind;
}

- (void)setSortMode:(GallerySortMode)sortMode
{
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSAssert(self.sectionKind != GallerySectionKindTop, @"Parameter sort is not available for Top section");
    NSAssert(sortMode != GallerySortModeRising || self.sectionKind == GallerySectionKindUser, @"Sort mode rising is available only for User section");
#pragma clang diagnostic pop

    _sortMode = sortMode;
}

- (void)setShowViral:(BOOL)showViral
{
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSAssert(self.sectionKind == GallerySectionKindUser, @"Parameter showViral is available only for User section");
#pragma clang diagnostic pop

    _showViral = showViral;
}

- (instancetype)initWithSectionKind:(GallerySectionKind)sectionKind
{
    NSParameterAssert(sectionKind != GallerySectionKindUnknown);

    if ((self = [super init]))
    {
        _windowKind = GalleryWindowKindDay;
        _sortMode = GallerySortModeViral;
        _showViral = YES;

        _sectionKind = sectionKind;
    }

    return self;
}

- (instancetype)init
{
    return [self initWithSectionKind:GallerySectionKindUnknown];
}

+ (instancetype)modelWithSectionKind:(GallerySectionKind)sectionKind
{
    return [[self alloc] initWithSectionKind:sectionKind];
}

- (NSArray *)allowedWindowKinds
{
    if (self.sectionKind == GallerySectionKindTop)
    {
        return @
        [
            @(GalleryWindowKindDay),
            @(GalleryWindowKindWeek),
            @(GalleryWindowKindMonth),
            @(GalleryWindowKindYear),
            @(GalleryWindowKindAll)
        ];
    }

    return nil;
}

- (NSArray *)allowedSortModes
{
    GallerySectionKind sectionKind = self.sectionKind;

    if (sectionKind == GallerySectionKindTop) return nil;
    if (sectionKind == GallerySectionKindUser)
    {
        return @
        [
            @(GallerySortModeViral),
            @(GallerySortModeTop),
            @(GallerySortModeTime),
            @(GallerySortModeRising)
        ];
    }

    return @
    [
        @(GallerySortModeViral),
        @(GallerySortModeTop),
        @(GallerySortModeTime)
    ];
}

- (BOOL)allowedShowViralOption
{
    return self.sectionKind == GallerySectionKindUser;
}

- (void)notifyDelegateDataStartLoading:(BOOL)itemsCleared
{
    id <GalleryViewModelDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(viewModelDataLoadingStarted:withClearingItems:)])
    {
        [delegate viewModelDataLoadingStarted:self withClearingItems:itemsCleared];
    }
}

- (void)notifyDelegateDataLoaded
{
    id <GalleryViewModelDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(viewModelDataLoaded:)])
    {
        [delegate viewModelDataLoaded:self];
    }
}

- (void)notifyDelegateDataLoadingFailed:(NSError *)error
{
    id <GalleryViewModelDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(viewModel:dataLoadingFailed:)])
    {
        [delegate viewModel:self dataLoadingFailed:error];
    }
}

- (void)startLoading
{
    [self startLoading:YES];
}

- (void)startLoading:(BOOL)clearItems
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params safeSetObject:[self.class paramValueForSectionKind:self.sectionKind]
                   forKey:kImgurGalleryRequestSectionParamName
             wrapNilValue:NO];

    if (self.allowedWindowKinds.count > 0)
    {
        [params safeSetObject:[self.class paramValueForWindowKind:self.windowKind]
                       forKey:kImgurGalleryRequestWindowParamName
                 wrapNilValue:NO];
    }

    if (self.allowedSortModes.count > 0)
    {
        [params safeSetObject:[self.class paramValueForSortMode:self.sortMode]
                       forKey:kImgurGalleryRequestSortParamName
                 wrapNilValue:NO];
    }

    if (self.allowedShowViralOption)
    {
        [params safeSetObject:self.showViral ? kImgurRequestBoolParamYesValue : kImgurRequestBoolParamNoValue
                       forKey:kImgurGalleryRequestShowViralParamName
                 wrapNilValue:NO];
    }

    self.lastLoadingParams = params;

    if (clearItems) self.items = nil;

    [self loadDataForPage:0];
}

- (void)loadDataForPage:(NSUInteger)pageNo
{
    if (self.loadingInProgress) return;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSMutableDictionary *params = self.lastLoadingParams;
    NSAssert(params.count > 0, @"Use startLoading: first");
    params[kImgurGalleryRequestPageParamName] = @(pageNo);
#pragma clang diagnostic pop

    [self notifyDelegateDataStartLoading:self.items == nil];

    self.loadingInProgress = YES;
    @weakify(self);
    [self.dataService galleryWithParameters:params success:^(NSArray *array)
    {
        @strongify(self);
        NSArray *items = self.items;
        if (items.count == 0 || pageNo == 0)
        {
            items = array;
        }
        else
        {
            items = [items arrayByAddingObjectsFromArray:array];
        }
        self.items = items;

        self.nextBatchAvailable = array.count > 0;
        self.loadingInProgress = NO;
        [self notifyDelegateDataLoaded];
    } failure:^(NSError *error)
    {
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
        NSLog(@"[ERROR] GalleryViewModel can't load data. %@", error);
#pragma clang diagnostic pop

        @strongify(self);
        self.loadingInProgress = NO;
        [self notifyDelegateDataLoadingFailed:error];
    }];
}

- (IMGImage *)imageAtIndexPath:(NSIndexPath *)indexPath
{
    IMGImage *image;

    id item = [self itemForIndexPath:indexPath];
    if ([item isKindOfClass:[IMGGalleryImage class]])
    {
        image = item;
    }
    else if ([item isKindOfClass:[IMGGalleryAlbum class]])
    {
        image = [item images].firstObject;
    }

    return image;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath bestFittingWidth:(CGFloat)width
{
    IMGImage *image = [self imageAtIndexPath:indexPath];
    IMGSize thumbnailKind = [image thumbnailKindBestFittingWidth:width];
    return [image thumbnailProportionalSizeForKind:thumbnailKind];
}

- (NSUInteger)itemsCount
{
    return self.items.count;
}

- (id)itemForIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger itemIndex = NSNotFound;
    if (indexPath.length == 1)
    {
        itemIndex = [indexPath indexAtPosition:0];
    }
    else if (indexPath.length == 2 && [indexPath indexAtPosition:0] == 0)
    {
        itemIndex = [indexPath indexAtPosition:1];
    }
    else
    {
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
        NSAssert(NO, @"Invalid indexPath");
#pragma clang diagnostic pop
    }

    NSArray *items = self.items;
    return items.count > itemIndex ? items[itemIndex] : nil;
}

- (void)loadNextBatch
{
    NSUInteger pageNo = self.items.count > 0 ? [self.lastLoadingParams[kImgurGalleryRequestPageParamName] unsignedIntegerValue] + 1 : 0;
    [self loadDataForPage:pageNo];
}

@end
