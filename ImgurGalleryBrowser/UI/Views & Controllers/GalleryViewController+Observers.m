//
//  GalleryViewController(Observers)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryViewController+Observers.h"
#import <libextobjc/EXTKeyPathCoding.h>
#import <BlocksKit/NSArray+BlocksKit.h>
#import "UISegmentedControlEx.h"

@implementation GalleryViewController (Observers)

+ (NSArray *)observingViewModelKeyPaths
{
    static NSArray *observingViewModelKeyPaths;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        observingViewModelKeyPaths = @
        [
                @keypath(GalleryViewModel.new, windowKind),
                @keypath(GalleryViewModel.new, sortMode),
            @keypath(GalleryViewModel.new, showViral)
        ];
    });

    return observingViewModelKeyPaths;
}

- (NSString *)viewModelKeyPathForSegmentedControl:(UISegmentedControlEx *)segmentedControl
{
    if (segmentedControl == self.windowKindSegmentedControl) return @keypath(GalleryViewModel.new, windowKind);
    else if (segmentedControl == self.sortModeSegmentedControl) return @keypath(GalleryViewModel.new, sortMode);
    if (segmentedControl == self.viralItemsSegmentedControl) return @keypath(GalleryViewModel.new, showViral);

    return nil;
}

- (UISegmentedControlEx *)segmentedControlForViewModelKeyPath:(NSString *)keyPath
{
    if ([keyPath isEqual:@keypath(GalleryViewModel.new, windowKind)]) return self.windowKindSegmentedControl;
    else if ([keyPath isEqual:@keypath(GalleryViewModel.new, sortMode)]) return self.sortModeSegmentedControl;
    else if ([keyPath isEqual:@keypath(GalleryViewModel.new, showViral)]) return self.viralItemsSegmentedControl;

    return nil;
}

- (void)removeObservers
{
    GalleryViewModel *viewModel = self.viewModel;
    [[self.class observingViewModelKeyPaths] bk_each:^(NSString *keyPath)
    {
        [viewModel removeObserver:self forKeyPath:keyPath];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    GalleryViewModel *viewModel = self.viewModel;
    if (object == viewModel)
    {
        UISegmentedControlEx *segmentedControl = [self segmentedControlForViewModelKeyPath:keyPath];
        if (segmentedControl != nil) segmentedControl.selectedSegmentValue = change[NSKeyValueChangeNewKey];
    }
}

@end