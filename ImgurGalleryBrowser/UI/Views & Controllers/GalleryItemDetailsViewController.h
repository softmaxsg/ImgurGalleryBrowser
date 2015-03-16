//
//  GalleryItemDetailsViewController.h
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import UIKit;

@interface GalleryItemDetailsViewController : UIViewController

@property (nonatomic) id item;

- (instancetype)initWithItem:(id)item;
+ (instancetype)controllerWithItem:(id)item;

@end
