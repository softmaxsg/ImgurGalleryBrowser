//
//  GalleryViewModel(Localization)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GalleryViewModel.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
@interface GalleryViewModel (Localization)

+ (NSString *)localizedTitleForSectionKind:(GallerySectionKind)sectionKind;
+ (NSString *)localizedTitleForWindowKind:(GalleryWindowKind)windowKind;
+ (NSString *)localizedTitleForSortMode:(GallerySortMode)sortMode;

- (NSArray *)localizedAllowedWindowKindsTitles;
- (NSArray *)localizedAllowedSortModesTitles;

@end
#pragma clang diagnostic pop