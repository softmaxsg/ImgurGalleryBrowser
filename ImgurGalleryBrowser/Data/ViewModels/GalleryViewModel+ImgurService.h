//
//  GalleryViewModel(ImgurService)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import Foundation;
#import "GalleryViewModel.h"

@interface GalleryViewModel (ImgurService)

+ (NSString *)paramValueForSectionKind:(GallerySectionKind)sectionKind;
+ (NSString *)paramValueForWindowKind:(GalleryWindowKind)windowKind;
+ (NSString *)paramValueForSortMode:(GallerySortMode)sortMode;

@end