//
//  IMGImage(Fixes)
//  ImgurGalleryBrowser
//
// Copyright (c) 2016 Vitaly Chupryk. All rights reserved.
//

@import Foundation;
@import CoreGraphics;
#import <ImgurSession/IMGImage.h>

@interface IMGImage (Fixes)

// Fixed version of the original `URLWithSize:`
- (NSURL *)URLWithSizeFixed:(IMGSize)size;

@end