//
//  IMGImage(Thumbnails)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import Foundation;
@import CoreGraphics;
#import <ImgurSession/IMGImage.h>

@interface IMGImage (Thumbnails)

+ (CGSize)thumbnailSizeForKind:(IMGSize)thumbnailKind;

- (CGSize)thumbnailProportionalSizeForKind:(IMGSize)thumbnailKind;

+ (IMGSize)thumbnailKindBestFittingSquareWidth:(CGFloat)width;
- (IMGSize)thumbnailKindBestFittingSize:(CGSize)size;
- (IMGSize)thumbnailKindBestFittingWidth:(CGFloat)width;

- (NSURL *)thumbnailUrlBestFittingSize:(CGSize)size;
- (NSURL *)thumbnailUrlBestFittingWidth:(CGFloat)width;
- (NSURL *)thumbnailUrlBestFittingSquareWidth:(CGFloat)width;

@end