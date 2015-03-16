//
//  GalleryStaggeredGridViewCell.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryStaggeredGridViewCell.h"
#import "IMGImage+Thumbnails.h"

@implementation GalleryStaggeredGridViewCell

- (NSURL *)urlForImage:(IMGImage *)image
{
    return [image thumbnailUrlBestFittingWidth:CGRectGetWidth(self.imageView.bounds)];
}

@end
