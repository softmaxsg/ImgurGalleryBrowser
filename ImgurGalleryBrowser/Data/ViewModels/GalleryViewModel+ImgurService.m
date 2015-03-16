//
//  GalleryViewModel(ImgurService)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryViewModel+ImgurService.h"
#import "ImgurService+Constants.h"

@implementation GalleryViewModel (ImgurService)

+ (NSString *)paramValueForSectionKind:(GallerySectionKind)sectionKind
{
    switch (sectionKind)
    {
        case GallerySectionKindHot: return kImgurGalleryRequestSectionParamHotValue;
        case GallerySectionKindTop: return kImgurGalleryRequestSectionParamTopValue;
        case GallerySectionKindUser: return kImgurGalleryRequestSectionParamUserValue;
        default: break;
    }

    return nil;
}

+ (NSString *)paramValueForWindowKind:(GalleryWindowKind)windowKind
{
    switch (windowKind)
    {
        case GalleryWindowKindAll: return kImgurGalleryRequestWindowParamAllValue;
        case GalleryWindowKindDay: return kImgurGalleryRequestWindowParamDayValue;
        case GalleryWindowKindWeek: return kImgurGalleryRequestWindowParamWeekValue;
        case GalleryWindowKindMonth: return kImgurGalleryRequestWindowParamMonthValue;
        case GalleryWindowKindYear: return kImgurGalleryRequestWindowParamYearValue;
    }

    return nil;
}

+ (NSString *)paramValueForSortMode:(GallerySortMode)sortMode
{
    switch (sortMode)
    {
        case GallerySortModeViral: return kImgurGalleryRequestSortParamViralValue;
        case GallerySortModeTop: return kImgurGalleryRequestSortParamTopValue;
        case GallerySortModeTime: return kImgurGalleryRequestSortParamTimeValue;
        case GallerySortModeRising: return kImgurGalleryRequestSortParamRisingValue;
    }

    return nil;
}

@end