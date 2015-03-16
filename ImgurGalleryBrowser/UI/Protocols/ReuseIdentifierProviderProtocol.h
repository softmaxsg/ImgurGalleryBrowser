//
//  ReuseIdentifierProviderProtocol
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import Foundation;

@protocol ReuseIdentifierProviderProtocol <NSObject>

- (NSString *)reuseIdentifierForIndexPath:(NSIndexPath *)indexPath;

@end