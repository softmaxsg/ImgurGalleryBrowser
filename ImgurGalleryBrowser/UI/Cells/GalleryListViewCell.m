//
//  GalleryListViewCell.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryListViewCell.h"
#import "IMGImage+Thumbnails.h"

@implementation GalleryListViewCell

- (NSURL *)urlForImage:(IMGImage *)image
{
    return [image thumbnailUrlBestFittingSquareWidth:CGRectGetWidth(self.imageView.bounds)];
}

- (void)configureCell
{
    self.backgroundColor = [UIColor blackColor];
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1;

    static UIColor *titleTextColor;
    static UIFont *titleFont;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        titleTextColor = [UIColor whiteColor];
        titleFont = [UIFont systemFontOfSize:14];
    });

    UIView *contentView = self.contentView;

    // Predefined size is required for image caching library
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:contentView.bounds];
    imageView.clipsToBounds = YES;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.backgroundColor = self.backgroundColor;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView = imageView;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = titleTextColor;
    titleLabel.font = titleFont;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 0;
    self.titleLabel = titleLabel;

    [contentView addSubview:imageView];
    [contentView addSubview:titleLabel];

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView, titleLabel);
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]"
                                                                        options:(NSLayoutFormatOptions)0
                                                                        metrics:nil
                                                                          views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|"
                                                                        options:(NSLayoutFormatOptions)0
                                                                        metrics:nil
                                                                        views:views]];

    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:0]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView]-[titleLabel]-|"
                                                                        options:(NSLayoutFormatOptions)0
                                                                        metrics:nil
                                                                          views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[titleLabel]-2-|"
                                                                        options:(NSLayoutFormatOptions)0
                                                                        metrics:nil
                                                                          views:views]];
#pragma clang diagnostic pop
}

@end
