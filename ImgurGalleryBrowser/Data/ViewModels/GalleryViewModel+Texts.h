//
//  GalleryViewModel(Texts)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GalleryViewModel.h"

@interface GalleryViewModel (Texts)

+ (NSString *)titleForSectionKind:(GallerySectionKind)sectionKind;
+ (NSString *)titleForWindowKind:(GalleryWindowKind)windowKind;
+ (NSString *)titleForSortMode:(GallerySortMode)sortMode;

- (NSArray *)allowedWindowKindsTitles;
- (NSArray *)allowedSortModesTitles;

@end