//
//  GalleryGridViewCell.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryGridViewCell.h"
#import "IMGImage+Thumbnails.h"

@implementation GalleryGridViewCell

- (NSURL *)urlForImage:(IMGImage *)image
{
    return [image thumbnailUrlBestFittingSize:self.imageView.bounds.size];
}

- (void)configureCell
{
    self.backgroundColor = [UIColor blackColor];
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1;

    static UIColor *titleBackgroundColor;
    static UIColor *titleTextColor;
    static UIFont *titleFont;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        titleBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        titleTextColor = [UIColor whiteColor];
        titleFont = [UIFont systemFontOfSize:12];
    });

    UIView *contentView = self.contentView;

    // Predefined size is required for image caching library
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:contentView.bounds];
    imageView.clipsToBounds = YES;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.backgroundColor = self.backgroundColor;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView = imageView;

    UIView *titleBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    titleBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    titleBackgroundView.backgroundColor = titleBackgroundColor;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = titleTextColor;
    titleLabel.font = titleFont;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 3;
    self.titleLabel = titleLabel;

    [contentView addSubview:imageView];
    [contentView addSubview:titleBackgroundView];

    [titleBackgroundView addSubview:titleLabel];

    NSDictionary *views = NSDictionaryOfVariableBindings(imageView, titleLabel, titleBackgroundView);
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                        options:(NSLayoutFormatOptions)0
                                                                        metrics:nil
                                                                          views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|"
                                                                        options:(NSLayoutFormatOptions)0
                                                                        metrics:nil
                                                                          views:views]];

    [titleBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[titleLabel]-4-|"
                                                                                options:(NSLayoutFormatOptions)0
                                                                                metrics:nil
                                                                                  views:views]];

    [titleBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[titleLabel]-2-|"
                                                                                options:(NSLayoutFormatOptions)0
                                                                                metrics:nil
                                                                                  views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleBackgroundView]-0-|"
                                                                        options:(NSLayoutFormatOptions)0
                                                                        metrics:nil
                                                                          views:views]];

    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleBackgroundView]-0-|"
                                                                        options:(NSLayoutFormatOptions)0
                                                                        metrics:nil
                                                                          views:views]];
#pragma clang diagnostic pop
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
}

@end
