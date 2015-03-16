//
//  AppDelegate.h
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import UIKit;
#import <ImgurSession/ImgurSession.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, IMGSessionDelegate>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"
@property (nonatomic) UIWindow *window;
#pragma clang diagnostic pop

@end
