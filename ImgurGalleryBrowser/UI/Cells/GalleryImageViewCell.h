//
//  GalleryImageViewCell.h
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import UIKit;
#import "CustomCollectionViewCell.h"

@class IMGImage;

@interface GalleryImageViewCell : CustomCollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic) id item;

- (NSURL *)urlForImage:(IMGImage *)image;

@end
