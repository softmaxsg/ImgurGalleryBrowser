//
//  UIImage+CreationUtils.h
//
//  Copyright 2013 Vitaly Chupryk. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
@interface UIImage (CreationUtils)

+ (UIImage *)imageWithBackgroundColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithBackgroundColor:(UIColor *)color size:(CGSize)size drawingBlock:(void (^)())drawingBlock;

+ (UIImage *)imageWithSize:(CGSize)size drawingBlock:(void (^)())drawingBlock;

- (UIImage *)imageWithTintColor:(UIColor *)tintColor;

@end

#pragma clang diagnostic pop