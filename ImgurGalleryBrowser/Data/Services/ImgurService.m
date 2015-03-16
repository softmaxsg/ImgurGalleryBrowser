//
//  ImgurService.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "ImgurService.h"
#import "ImgurService+Constants.h"
#import <ImgurSession/IMGSession.h>
#import <ImgurSession/IMGGalleryRequest.h>
#import <ImgurSession/IMGGalleryImage.h>
#import <ImgurSession/IMGGalleryAlbum.h>
#import <BloodMagic/BMInitializer+Injectable.h>

@implementation ImgurService

+ (void)registerService
{
    BMInitializer *initializer = [BMInitializer injectableInitializer];
    initializer.protocols = @[ @protocol(ImgurServiceProtocol) ];
    initializer.initializer = ^id (id sender)
    {
        return [[self alloc] init];
    };

    [initializer registerInitializer];
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
// Should use own version of +[IMGGalleryRequest galleryWithParameters:success:failure:] because original one doesn't support time windows due bug inside
- (void)galleryWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSMutableArray *pathComponents = [NSMutableArray array];
    NSMutableArray *queryParams = [NSMutableArray array];

    void (^addPathComponent)(NSString *, id, BOOL) = ^(NSString *paramName, id defaultValue, BOOL isQueryParam)
    {
        id paramValue = parameters[paramName] ?: defaultValue;
        if (paramValue != nil)
        {
            if (![paramValue isKindOfClass:[NSString class]])
            {
                if ([paramValue respondsToSelector:@selector(stringValue)])
                {
                    paramValue = [paramValue stringValue];
                }
                else
                {
                    paramValue = [paramValue description];
                }
            }

            if (!isQueryParam)
            {
                [pathComponents addObject:paramValue];
            }
            else
            {
                [queryParams addObject:[NSString stringWithFormat:@"%@=%@", paramName, paramValue]];
            }
        }
    };

    addPathComponent(kImgurGalleryRequestSectionParamName, kImgurGalleryRequestSectionParamDefaultValue, NO);
    addPathComponent(kImgurGalleryRequestSortParamName, kImgurGalleryRequestSortParamDefaultValue, NO);
    addPathComponent(kImgurGalleryRequestWindowParamName, kImgurGalleryRequestWindowParamDefaultValue, NO);
    addPathComponent(kImgurGalleryRequestPageParamName, @0, NO);
    addPathComponent(kImgurGalleryRequestShowViralParamName, kImgurGalleryRequestShowViralParamDefaultValue, YES);

    NSString *path = [IMGGalleryRequest path];
    if (pathComponents.count > 0) path = [path stringByAppendingPathComponent:[NSString pathWithComponents:pathComponents]];
    if (queryParams.count > 0) path = [path stringByAppendingFormat:@"?%@", [queryParams componentsJoinedByString:@"&"]];

    [[IMGSession sharedInstance] GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSArray * jsonArray = responseObject;
        NSMutableArray * images = [NSMutableArray new];

        for (NSDictionary * json in jsonArray)
        {
            Class itemClass = [json[@"is_album"] boolValue] ? [IMGGalleryAlbum class] : [IMGGalleryImage class];

            NSError *JSONError = nil;
            id item = [(IMGModel *)[itemClass alloc] initWithJSONObject:json error:&JSONError];
            if (item != nil) [images addObject:item];
        }
        if (success) success([NSArray arrayWithArray:images]);

    } failure:failure];
}
#pragma clang diagnostic pop

@end
