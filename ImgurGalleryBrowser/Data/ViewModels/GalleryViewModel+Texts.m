 //
//  GalleryViewModel(Texts)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryViewModel+Texts.h"
#import <BlocksKit/NSArray+BlocksKit.h>

@implementation GalleryViewModel (Texts)

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
+ (NSString *)titleForSectionKind:(GallerySectionKind)sectionKind
{
    switch (sectionKind)
    {
        case GallerySectionKindHot: return @"Hot";
        case GallerySectionKindTop: return @"Top";
        case GallerySectionKindUser: return @"User";
        case GallerySectionKindUnknown: return nil;
    }

    return nil;
}

+ (NSString *)titleForWindowKind:(GalleryWindowKind)windowKind
{
    switch (windowKind)
    {
        case GalleryWindowKindAll: return @"All";
        case GalleryWindowKindDay: return @"Day";
        case GalleryWindowKindWeek: return @"Week";
        case GalleryWindowKindMonth: return @"Month";
        case GalleryWindowKindYear: return @"Year";
    }

    return nil;
}

+ (NSString *)titleForSortMode:(GallerySortMode)sortMode
{
    switch (sortMode)
    {
        case GallerySortModeViral: return @"Viral";
        case GallerySortModeTop: return @"Top";
        case GallerySortModeTime: return @"New";
        case GallerySortModeRising: return @"Rising";
    }

    return nil;
}
#pragma clang diagnostic pop

- (NSArray *)allowedWindowKindsTitles
{
    return [self.allowedWindowKinds bk_map:^id(NSNumber *windowKind)
    {
        return [self.class titleForWindowKind:(GalleryWindowKind)windowKind.unsignedIntegerValue];
    }];
}

- (NSArray *)allowedSortModesTitles
{
    return [self.allowedSortModes bk_map:^id(NSNumber *sortMode)
    {
        return [self.class titleForSortMode:(GallerySortMode)sortMode.unsignedIntegerValue];
    }];
}

@end