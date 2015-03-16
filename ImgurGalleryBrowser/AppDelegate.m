//
//  AppDelegate.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "AppDelegate.h"
#import "GalleryViewController.h"
#import "AboutViewController.h"
#import "UINavigationController+TabBarUtils.h"
#import "GalleryViewModel+Localization.h"
#import "ImgurService.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
NSString *const kImgurClientID = @"75db6f831444d33";
#pragma clang diagnostic pop

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ImgurService registerService];

    [IMGSession anonymousSessionWithClientID:kImgurClientID withDelegate:self];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [self createInitialViewController];
    [window makeKeyAndVisible];
    self.window = window;

    return YES;
}

- (UIViewController *)createInitialViewController
{
    GalleryViewModel *hotGalleryViewModel = [GalleryViewModel modelWithSectionKind:GallerySectionKindHot];
    GalleryViewModel *topGalleryViewModel = [GalleryViewModel modelWithSectionKind:GallerySectionKindTop];
    GalleryViewModel *userGalleryViewModel = [GalleryViewModel modelWithSectionKind:GallerySectionKindUser];

    GalleryViewController *hotGalleryController = [GalleryViewController controllerWithViewModel:hotGalleryViewModel];
    GalleryViewController *topGalleryController = [GalleryViewController controllerWithViewModel:topGalleryViewModel];
    GalleryViewController *userGalleryController = [GalleryViewController controllerWithViewModel:userGalleryViewModel];
    AboutViewController *aboutViewController = [AboutViewController aboutController];

    UITabBarItem *hotTabBarItem = [[UITabBarItem alloc] initWithTitle:[GalleryViewModel localizedTitleForSectionKind:GallerySectionKindHot]
                                                                image:[UIImage imageNamed:@"Icon-Rocket"]
                                                        selectedImage:[UIImage imageNamed:@"Icon-Rocket-Selected"]];

    UITabBarItem *topTabBarItem = [[UITabBarItem alloc] initWithTitle:[GalleryViewModel localizedTitleForSectionKind:GallerySectionKindTop]
                                                                image:[UIImage imageNamed:@"Icon-Star"]
                                                        selectedImage:[UIImage imageNamed:@"Icon-Star-Selected"]];

    UITabBarItem *userTabBarItem = [[UITabBarItem alloc] initWithTitle:[GalleryViewModel localizedTitleForSectionKind:GallerySectionKindUser]
                                                                 image:[UIImage imageNamed:@"Icon-User"]
                                                         selectedImage:[UIImage imageNamed:@"Icon-User-Selected"]];

    UITabBarItem *aboutTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"About", nil)
                                                                  image:[UIImage imageNamed:@"Icon-About"]
                                                          selectedImage:[UIImage imageNamed:@"Icon-About-Selected"]];

    UITabBarController *mainTabController = [[UITabBarController alloc] init];
    mainTabController.viewControllers = @
    [
        [[UINavigationController alloc] initWithRootViewController:hotGalleryController tabBarItem:hotTabBarItem],
        [[UINavigationController alloc] initWithRootViewController:topGalleryController tabBarItem:topTabBarItem],
        [[UINavigationController alloc] initWithRootViewController:userGalleryController tabBarItem:userTabBarItem],
        [[UINavigationController alloc] initWithRootViewController:aboutViewController tabBarItem:aboutTabBarItem]
    ];

    return mainTabController;
}

@end