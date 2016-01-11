//
//  IMGImage(Fixes)
//  ImgurGalleryBrowser
//
// Copyright (c) 2016 Vitaly Chupryk. All rights reserved.
//

#import "IMGImage+Fixes.h"

@implementation IMGImage (Fixes)

- (NSURL *)URLWithSizeFixed:(IMGSize)size
{

    NSString *path = [[self.url absoluteString] stringByDeletingPathExtension];

    // This is required because some urls already contains suffix for a thumbnail
    if (path.lastPathComponent.length == 8) {
        return self.url;
    }

    NSString *extension = [self.url pathExtension];
    NSString *stringURL;

    switch (size) {
        case IMGSmallSquareSize:
            stringURL = [NSString stringWithFormat:@"%@s.%@", path, extension];
            break;

        case IMGBigSquareSize:
            stringURL = [NSString stringWithFormat:@"%@b.%@", path, extension];
            break;

            //keeps image proportions below, please use these for better looking design

        case IMGSmallThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@t.%@", path, extension];
            break;

        case IMGMediumThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@m.%@", path, extension];
            break;

        case IMGLargeThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@l.%@", path, extension];
            break;

        case IMGHugeThumbnailSize:
            stringURL = [NSString stringWithFormat:@"%@h.%@", path, extension];
            break;

        default:
            return nil;
    }

    return [NSURL URLWithString:stringURL];
}

@end