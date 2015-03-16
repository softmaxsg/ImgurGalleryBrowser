//
//  ImgurServiceProtocol
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import Foundation;

@protocol ImgurServiceProtocol <NSObject>

- (void)galleryWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

@end