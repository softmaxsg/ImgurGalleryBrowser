//
//  GalleryImageViewCell.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryImageViewCell.h"
#import "IMGImage+Thumbnails.h"
#import <ImgurSession/IMGGalleryImage.h>
#import <ImgurSession/IMGGalleryAlbum.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface GalleryImageViewCell ()

- (void)clearControls;
- (void)updateControls;

@end

@implementation GalleryImageViewCell

- (void)setItem:(id)item
{
    if (_item != item)
    {
        _item = item;

        [self updateControls];
    }
}

- (NSURL *)urlForImage:(IMGImage *)image
{
    return image.url;
}

- (void)clearControls
{
    self.titleLabel.text = nil;

    UIImageView *imageView = self.imageView;
    [imageView sd_cancelCurrentImageLoad];
    imageView.image = nil;
}

- (void)updateControls
{
    UIImageView *imageView = self.imageView;

    NSURL *imageUrl;
    NSString *title;

    id item = self.item;
    if ([item isKindOfClass:[IMGGalleryAlbum class]])
    {
        IMGGalleryAlbum *galleryAlbum = item;
        title = galleryAlbum.title;
        imageUrl = [self urlForImage:galleryAlbum.images.firstObject];
    }
    else if ([item isKindOfClass:[IMGGalleryImage class]])
    {
        IMGGalleryImage *galleryImage = item;
        title = galleryImage.title;
        imageUrl = [self urlForImage:galleryImage];
    }
    else
    {
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
        NSAssert(NO, @"Wrong item type");
#pragma clang diagnostic pop
    }

    self.titleLabel.text = title;

    if (imageUrl != nil)
    {
        [imageView sd_setImageWithURL:imageUrl
                     placeholderImage:nil
                              options:0
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                            {
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
                                if (error != nil)
                                {
                                    NSLog(@"[ERROR] Can't load image %@. %@", imageUrl.absoluteString, error);
                                }
#pragma clang diagnostic pop
                            }];
    }
}

@end
