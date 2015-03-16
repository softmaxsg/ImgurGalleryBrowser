//
//  GalleryViewController(Observers)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GalleryViewController.h"

@class UISegmentedControlEx;

@interface GalleryViewController (Observers)

+ (NSArray *)observingViewModelKeyPaths;
- (NSString *)viewModelKeyPathForSegmentedControl:(UISegmentedControlEx *)segmentedControl;
- (UISegmentedControlEx *)segmentedControlForViewModelKeyPath:(NSString *)keyPath;

- (void)removeObservers;

@end