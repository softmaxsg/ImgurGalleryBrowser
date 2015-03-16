//
//  IMGImage(Thumbnails)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "IMGImage+Thumbnails.h"

NSInteger const IMGSizeSmallestProportional = IMGSmallThumbnailSize;
NSInteger const IMGSizeLargestProportional = IMGHugeThumbnailSize;

@implementation IMGImage (Thumbnails)

+ (NSDictionary *)thumbnailSizes
{
    static NSDictionary *thumbnailSizes;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        thumbnailSizes = @
        {
            @(IMGSmallSquareSize): @90,
            @(IMGBigSquareSize): @160,
            @(IMGSmallThumbnailSize): @160,
            @(IMGMediumThumbnailSize): @320,
            @(IMGLargeThumbnailSize): @640,
            @(IMGHugeThumbnailSize): @1024
        };
    });

    return thumbnailSizes;
}

+ (CGSize)thumbnailSizeForKind:(IMGSize)thumbnailKind
{
    CGFloat thumbnailSize = [[self thumbnailSizes][@(thumbnailKind)] floatValue];
    return CGSizeMake(thumbnailSize, thumbnailSize);
}

- (CGSize)thumbnailProportionalSizeForKind:(IMGSize)thumbnailKind
{
    if (thumbnailKind >= IMGSizeSmallestProportional && thumbnailKind <= IMGSizeLargestProportional)
    {
        CGFloat originalWidth = self.width;
        CGFloat originalHeight = self.height;

        CGSize thumbnailSize = [self.class thumbnailSizeForKind:(IMGSize)thumbnailKind];
        CGFloat scale = MAX(originalWidth / thumbnailSize.width, originalHeight / thumbnailSize.height);

        return CGSizeMake(originalWidth / scale, originalHeight / scale);
    }

    return [self.class thumbnailSizeForKind:thumbnailKind];
}

+ (IMGSize)thumbnailKindBestFittingSquareWidth:(CGFloat)width
{
    CGSize smallSquareSize = [self thumbnailSizeForKind:IMGSmallSquareSize];
    if (width <= smallSquareSize.width) return IMGSmallSquareSize;

    return IMGBigSquareSize;
}

- (IMGSize)thumbnailKindBestFittingSize:(CGSize)size
{
    IMGSize thumbnailKind = (IMGSize)IMGSizeLargestProportional;
    for (IMGSize kind = thumbnailKind - 1; kind >= IMGSizeSmallestProportional; kind--)
    {
        CGSize scaledSize = [self thumbnailProportionalSizeForKind:kind];
        if (scaledSize.width < size.width || scaledSize.height < size.height) break;

        thumbnailKind = kind;
    }

    return thumbnailKind;
}

- (IMGSize)thumbnailKindBestFittingWidth:(CGFloat)width
{
    IMGSize thumbnailKind = (IMGSize)IMGSizeLargestProportional;
    for (IMGSize kind = thumbnailKind - 1; kind >= IMGSizeSmallestProportional; kind--)
    {
        CGSize scaledSize = [self thumbnailProportionalSizeForKind:kind];
        if (scaledSize.width < width) break;

        thumbnailKind = kind;
    }

    return thumbnailKind;
}

- (NSURL *)thumbnailUrlBestFittingSize:(CGSize)size
{
    return [self URLWithSize:[self thumbnailKindBestFittingSize:size]];
}

- (NSURL *)thumbnailUrlBestFittingWidth:(CGFloat)width
{
    return [self URLWithSize:[self thumbnailKindBestFittingWidth:width]];
}

- (NSURL *)thumbnailUrlBestFittingSquareWidth:(CGFloat)width
{
    return [self URLWithSize:[self.class thumbnailKindBestFittingSquareWidth:width]];
}

@end