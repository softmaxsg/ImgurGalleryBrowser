//
//  AboutViewController.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "AboutViewController.h"
#import "MessageUIHelper.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const kAboutControllerCreditsFile = @"Credits";

NSString *const kCreditsAuthorElementKey = @"CreditsAuthor";
NSString *const kCreditsEmailElementKey = @"CreditsEmail";

NSString *const kCreditsAppNameDataKey = @"appName";
NSString *const kCreditsAuthorDataKey = @"author";
NSString *const kCreditsEmailDataKey = @"email";

NSString *const kCreditsAuthorValue = @"Vitaliy Chupryk";
NSString *const kCreditsEmailValue = @"vitaly@softmaxsg.com";
NSString *const kCreditsProfileUrlValue = @"https://www.linkedin.com/in/vchupryk";

NSString *const CFBundleShortVersionStringKey = @"CFBundleShortVersionString";
#pragma clang diagnostic pop

@interface AboutViewController ()

- (void)authorTapped:(QElement *)element;
- (void)emailTapped:(QElement *)element;

@end

@implementation AboutViewController

- (id)init
{
    return (self = [super initWithRoot:[self createRootElement]]);
}

+ (instancetype)aboutController
{
    return [[self alloc] init];
}

- (QRootElement *)createRootElement
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    id appName = infoDictionary[(NSString *)kCFBundleNameKey];
    id appVersion = infoDictionary[CFBundleShortVersionStringKey];
    id buildNUmber = infoDictionary[(NSString *)kCFBundleVersionKey];

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSDictionary *data = @
    {
        kCreditsAppNameDataKey : [NSString stringWithFormat:@"%@ v%@ (%@)", appName, appVersion, buildNUmber],
        kCreditsAuthorDataKey  : kCreditsAuthorValue,
        kCreditsEmailDataKey   : kCreditsEmailValue
    };
#pragma clang diagnostic pop

    QRootElement *root = [[QRootElement alloc] initWithJSONFile:kAboutControllerCreditsFile andData:data];

    [self configureRootElement:root];

    return root;
}

- (void)configureRootElement:(QRootElement *)root
{
    [root elementWithKey:kCreditsAuthorElementKey].controllerAction = NSStringFromSelector(@selector(authorTapped:));
    [root elementWithKey:kCreditsEmailElementKey].controllerAction = NSStringFromSelector(@selector(emailTapped:));
}

- (void)authorTapped:(__unused QElement *)element
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kCreditsProfileUrlValue]];
}

- (void)emailTapped:(__unused QElement *)element
{
    if ([MessageUIHelper canSendMail])
    {
        [MessageUIHelper presentComposeMailControllerIn:self
                                                subject:nil
                                                   body:nil
                                                 isHTML:YES
                                           toRecipients:@[kCreditsEmailValue]
                                           ccRecipients:nil
                                          bccRecipients:nil];
    }
}

@end
