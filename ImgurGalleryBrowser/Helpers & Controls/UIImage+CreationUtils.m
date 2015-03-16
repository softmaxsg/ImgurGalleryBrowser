//
//  UIImage+CreationUtils.m
//
//  Copyright 2013 Vitaly Chupryk. All rights reserved.
//

#import "UIImage+CreationUtils.h"

@implementation UIImage (CreationUtils)

+ (UIImage *)imageWithBackgroundColor:(UIColor *)color size:(CGSize)size
{
    return [self imageWithBackgroundColor:color size:size drawingBlock:nil];
}

+ (UIImage *)imageWithBackgroundColor:(UIColor *)color size:(CGSize)size drawingBlock:(void (^)())drawingBlock
{
    return [self imageWithSize:size drawingBlock:^
    {
        [color setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));

        if (drawingBlock != nil) drawingBlock();
    }];
}

+ (UIImage *)imageWithSize:(CGSize)size drawingBlock:(void (^)())drawingBlock
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);

    if (drawingBlock != nil) drawingBlock();

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextSetBlendMode(context, kCGBlendModeNormal);

    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);

    [tintColor setFill];
    CGContextFillRect(context, rect);

    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return tintedImage;
}

@end
