//
//  ImgurService.h
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import Foundation;
#import "ImgurServiceProtocol.h"

@interface ImgurService : NSObject<ImgurServiceProtocol>

+ (void)registerService;

- (void)galleryWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

@end
