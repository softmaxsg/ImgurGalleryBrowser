//
//  UINavigationController(TabBarUtils)
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "UINavigationController+TabBarUtils.h"

@implementation UINavigationController (TabBarUtils)

- (instancetype)initWithRootViewController:(UIViewController *)viewController tabBarItem:(UITabBarItem *)tabBarItem
{
    if ((self = [self initWithRootViewController:viewController]))
    {
        self.tabBarItem = tabBarItem;
    }

    return self;
}

@end