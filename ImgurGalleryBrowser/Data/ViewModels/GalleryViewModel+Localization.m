//
//  GalleryViewModel(Localization)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//


#import "GalleryViewModel+Localization.h"
#import <BlocksKit/NSArray+BlocksKit.h>
#import "GalleryViewModel+Texts.h"

@implementation GalleryViewModel (Localization)

+ (NSString *)localizedTitleForSectionKind:(GallerySectionKind)sectionKind
{
    return NSLocalizedString([self titleForSectionKind:sectionKind], nil);
}

+ (NSString *)localizedTitleForWindowKind:(GalleryWindowKind)windowKind
{
    return NSLocalizedString([self titleForWindowKind:windowKind], nil);
}

+ (NSString *)localizedTitleForSortMode:(GallerySortMode)sortMode
{
    return NSLocalizedString([self titleForSortMode:sortMode], nil);
}

- (NSArray *)localizedAllowedWindowKindsTitles
{
    return [self.allowedWindowKindsTitles bk_map:^id(NSString *title)
    {
        return NSLocalizedString(title, nil);
    }];
}

- (NSArray *)localizedAllowedSortModesTitles
{
    return [self.allowedSortModesTitles bk_map:^id(NSString *title)
    {
        return NSLocalizedString(title, nil);
    }];
}

@end