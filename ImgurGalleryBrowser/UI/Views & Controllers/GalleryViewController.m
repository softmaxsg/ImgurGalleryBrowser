//
//  GalleryViewController.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryViewController+Layout.h"
#import <libextobjc/EXTScope.h>
#import <libextobjc/EXTKeyPathCoding.h>
#import <BlocksKit/UIActionSheet+BlocksKit.h>
#import "UISegmentedControlEx.h"
#import "GalleryViewModel+Localization.h"
#import "GalleryDataSource.h"
#import "NSArray+BlocksKit.h"
#import "GalleryItemDetailsViewController.h"
#import "GalleryViewController+Observers.h"

GalleryLayoutMode const kDefaultGalleryLayoutMode = GalleryLayoutModeGrid;

@interface GalleryViewController ()

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"
@property (nonatomic) GalleryDataSource *dataSource;
#pragma clang diagnostic pop

@property (nonatomic) GalleryLayoutMode layoutMode;

@property (nonatomic, weak) UISegmentedControlEx *layoutModeSegmentedControl;
@property (nonatomic, weak) UISegmentedControlEx *windowKindSegmentedControl;
@property (nonatomic, weak) UISegmentedControlEx *sortModeSegmentedControl;
@property (nonatomic, weak) UISegmentedControlEx *viralItemsSegmentedControl;

@property (nonatomic) UIBarButtonItem *layoutModeSegmentedBarItem;
@property (nonatomic) UIBarButtonItem *windowKindSegmentedBarItem;
@property (nonatomic) UIBarButtonItem *sortModeSegmentedBarItem;
@property (nonatomic) UIBarButtonItem *windowKindButtonBarItem;
@property (nonatomic) UIBarButtonItem *sortModeButtonBarItem;
@property (nonatomic) UIBarButtonItem *viralItemsSegmentedBarItem;

- (void)bindViewModel;

- (void)createDataBarItems;
- (void)updateBarItemsVisibility;

- (void)configureCollectionView;

- (void)startRefresh;

- (void)segmentedControlValueChanged:(UISegmentedControlEx *)segmentedControl;

- (void)showDropDownMenuForButtonItem:(UIBarButtonItem *)barButtonItem
                            withTitle:(NSArray *)titles
                               values:(NSArray *)values
                              keyPath:(NSString *)keyPath;

- (void)windowKindButtonTapped:(id)sender;
- (void)sortModeButtonTapped:(id)sender;

@end

@implementation GalleryViewController

- (void)setViewModel:(GalleryViewModel *)viewModel
{
    if (_viewModel != viewModel)
    {
        [self unbindViewModel];

        _viewModel = viewModel;

        if (self.isViewLoaded)
        {
            [self bindViewModel];
        }
    }
}

- (void)setLayoutMode:(GalleryLayoutMode)layoutMode
{
    if (_layoutMode != layoutMode)
    {
        _layoutMode = layoutMode;

        if (self.isViewLoaded)
        {
            self.layoutModeSegmentedControl.selectedSegmentValue = @(layoutMode);

            [self updateGalleryLayoutForInterfaceOrientation:self.interfaceOrientation];
        }
    }
}

- (instancetype)init
{
    return [self initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
}

- (instancetype)initWithViewModel:(GalleryViewModel *)viewModel
{
    if ((self = [self init]))
    {
        self.viewModel = viewModel;
    }

    return self;
}

+ (instancetype)controllerWithViewModel:(GalleryViewModel *)viewModel
{
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIRefreshControl *refreshControl = self.refreshControl;
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];

    [self createStandardBarItems];

    [self bindViewModel];

    self.layoutMode = kDefaultGalleryLayoutMode;
}

- (void)dealloc
{
    [self unbindViewModel];
}

- (void)bindViewModel
{
    GalleryViewModel *viewModel = self.viewModel;
    viewModel.delegate = self;
    [viewModel startLoading];

    [self createDataBarItems];
    [self updateBarItemsVisibility];
    [self configureCollectionView];

    [[self.class observingViewModelKeyPaths] bk_each:^(NSString *keyPath)
    {
        [viewModel addObserver:self
                    forKeyPath:keyPath
                       options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial
                       context:nil];
    }];
}

- (void)unbindViewModel
{
    [self removeObservers];
}

- (void)createStandardBarItems
{
    UISegmentedControlEx *layoutModeSegmentedControl = [[UISegmentedControlEx alloc] initWithItems:@
    [
        [UIImage imageNamed:@"Icon-Grid"],
        [UIImage imageNamed:@"Icon-Stack"],
        [UIImage imageNamed:@"Icon-List"]
    ] values:@
    [
        @(GalleryLayoutModeGrid),
        @(GalleryLayoutModeStaggeredGrid),
        @(GalleryLayoutModeList)
    ]];

    [layoutModeSegmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];

    self.layoutModeSegmentedControl = layoutModeSegmentedControl;
    self.layoutModeSegmentedBarItem = [[UIBarButtonItem alloc] initWithCustomView:layoutModeSegmentedControl];
    self.navigationItem.leftBarButtonItems = @[self.layoutModeSegmentedBarItem];
}

- (void)createDataBarItems
{
    GalleryViewModel *viewModel = self.viewModel;

    NSArray *allowedWindowKinds = viewModel.allowedWindowKinds;
    NSArray *allowedSortModes = viewModel.allowedSortModes;

    if (allowedWindowKinds.count > 0)
    {
        UISegmentedControlEx *windowKindSegmentedControl = [[UISegmentedControlEx alloc] initWithItems:viewModel.localizedAllowedWindowKindsTitles values:allowedWindowKinds];
        [windowKindSegmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.windowKindSegmentedBarItem = [[UIBarButtonItem alloc] initWithCustomView:windowKindSegmentedControl];
        self.windowKindSegmentedControl = windowKindSegmentedControl;

        self.windowKindButtonBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Calendar"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(windowKindButtonTapped:)];
    }
    else
    {
        self.windowKindSegmentedBarItem = nil;
        self.windowKindButtonBarItem = nil;
    }

    if (allowedSortModes.count > 0)
    {
        UISegmentedControlEx *sortModeSegmentedControl = [[UISegmentedControlEx alloc] initWithItems:viewModel.localizedAllowedSortModesTitles values:allowedSortModes];
        [sortModeSegmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.sortModeSegmentedBarItem = [[UIBarButtonItem alloc] initWithCustomView:sortModeSegmentedControl];
        self.sortModeSegmentedControl = sortModeSegmentedControl;

        self.sortModeButtonBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Icon-Sort"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(sortModeButtonTapped:)];
    }
    else
    {
        self.sortModeSegmentedBarItem = nil;
        self.sortModeButtonBarItem = nil;
    }

    if (viewModel.allowedShowViralOption)
    {
        UISegmentedControlEx *viralItemsSegmentedControl = [[UISegmentedControlEx alloc] initWithItems:@[NSLocalizedString(@"Show Viral", nil)] values:@[@YES]];
        viralItemsSegmentedControl.allowsDeselection = YES;
        [viralItemsSegmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.viralItemsSegmentedBarItem = [[UIBarButtonItem alloc] initWithCustomView:viralItemsSegmentedControl];
        self.viralItemsSegmentedControl = viralItemsSegmentedControl;
    }
    else
    {
        self.viralItemsSegmentedBarItem = nil;
    }
}

- (void)updateBarItemsVisibility
{
#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"
    BOOL wideMode = [self respondsToSelector:@selector(traitCollection)] ?
        self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular :
        UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#pragma clang diagnostic pop

    UIBarButtonItem *viralModeBarItem = self.viralItemsSegmentedBarItem;
    UIBarButtonItem *windowKindBarItem;
    UIBarButtonItem *sortModeBarItem;
    if (wideMode)
    {
        windowKindBarItem = self.windowKindSegmentedBarItem;
        sortModeBarItem = self.sortModeSegmentedBarItem;
    }
    else
    {
        windowKindBarItem = self.windowKindButtonBarItem;
        sortModeBarItem = self.sortModeButtonBarItem;
    }

    NSMutableArray *rightBarButtonItems = [NSMutableArray array];
    if (sortModeBarItem != nil) [rightBarButtonItems addObject:sortModeBarItem];
    if (windowKindBarItem != nil) [rightBarButtonItems addObject:windowKindBarItem];
    if (viralModeBarItem != nil) [rightBarButtonItems addObject:viralModeBarItem];
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
}

- (void)configureCollectionView
{
    UICollectionView *collectionView = self.collectionView;

    GalleryDataSource *dataSource = [GalleryDataSource dataSourceWithViewModel:self.viewModel];
    [dataSource registerCollectionViewReusableClasses:collectionView];
    collectionView.dataSource = dataSource;
    self.dataSource = dataSource;
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];

    [self updateBarItemsVisibility];
}
#pragma clang diagnostic pop

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"
    if ([UITraitCollection class] == nil)
    {
        [self updateBarItemsVisibility];
    }
#pragma clang diagnostic pop

    [self updateGalleryLayoutForInterfaceOrientation:toInterfaceOrientation];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [self.viewModel itemForIndexPath:indexPath];
    if (item != nil)
    {
        GalleryItemDetailsViewController *detailsViewController = [GalleryItemDetailsViewController controllerWithItem:item];
        [self.navigationController pushViewController:detailsViewController animated:YES];
    }
}

- (void)startRefresh
{
    [self.viewModel startLoading:NO];
}

- (void)segmentedControlValueChanged:(UISegmentedControlEx *)segmentedControl
{
    if (segmentedControl == self.layoutModeSegmentedControl)
    {
        [self setValue:segmentedControl.selectedSegmentValue forKeyPath:@keypath(self.layoutMode)];
    }
    else
    {
        NSString *keyPath = [self viewModelKeyPathForSegmentedControl:segmentedControl];
        if (keyPath != nil)
        {
            GalleryViewModel *viewModel = self.viewModel;
            [viewModel setValue:(segmentedControl.selectedSegmentValue ?: @0) forKeyPath:keyPath];
            [viewModel startLoading];
        }
    }
}

- (void)showDropDownMenuForButtonItem:(UIBarButtonItem *)barButtonItem
                            withTitle:(NSArray *)titles
                               values:(NSArray *)values
                              keyPath:(NSString *)keyPath
{
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSAssert(titles.count == values.count, @"Number of titles and values should match");
#pragma clang diagnostic pop

    GalleryViewModel *viewModel = self.viewModel;
    @weakify(viewModel);

    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop)
    {
        id value = values[idx];

        [actionSheet bk_addButtonWithTitle:title handler:^
        {
            @strongify(viewModel);

            id existingValue = [viewModel valueForKeyPath:keyPath];
            if (![existingValue isEqual:value])
            {
                [viewModel setValue:value forKeyPath:keyPath];
                [viewModel startLoading];
            }
        }];
    }];

    [actionSheet bk_setCancelButtonWithTitle:NSLocalizedString(@"Cancel", nil) handler:nil];
    [actionSheet showFromBarButtonItem:barButtonItem animated:YES];

}

- (void)windowKindButtonTapped:(id)sender
{
    GalleryViewModel *viewModel = self.viewModel;

    [self showDropDownMenuForButtonItem:sender
                              withTitle:viewModel.localizedAllowedWindowKindsTitles
                                 values:viewModel.allowedWindowKinds
                                keyPath:@keypath(viewModel.windowKind)];
}

- (void)sortModeButtonTapped:(id)sender
{
    GalleryViewModel *viewModel = self.viewModel;

    [self showDropDownMenuForButtonItem:sender
                              withTitle:viewModel.localizedAllowedSortModesTitles
                                 values:viewModel.allowedSortModes
                                keyPath:@keypath(viewModel.sortMode)];
}

- (void)viewModelDataLoadingStarted:(GalleryViewModel *)viewModel withClearingItems:(BOOL)itemsCleared
{
    if (itemsCleared) [self.collectionView reloadData];
}

- (void)viewModelDataLoaded:(GalleryViewModel *)viewModel
{
    [self.refreshControl endRefreshing];
    [self.collectionView reloadData];
}

- (void)viewModel:(GalleryViewModel *)viewModel dataLoadingFailed:(NSError *)error
{
    [self.refreshControl endRefreshing];
}

@end
