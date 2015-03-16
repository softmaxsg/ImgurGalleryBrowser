//
//  GalleryDataSource.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryDataSource.h"
#import "DataSourceProtocol.h"
#import "GalleryGridViewCell.h"
#import "GalleryStaggeredGridViewCell.h"
#import "GalleryListViewCell.h"
#import "ReuseIdentifierProviderProtocol.h"

@interface GalleryDataSource ()

@property (nonatomic) id <DataSourceProtocol> viewModel;

- (void)validateViewModelIsIncrementalLoading;

@end

@implementation GalleryDataSource

- (instancetype)initWithViewModel:(id <DataSourceProtocol>)viewModel
{
    if ((self = [super init]))
    {
        self.viewModel = viewModel;
    }

    return self;
}

+ (instancetype)dataSourceWithViewModel:(id <DataSourceProtocol>)viewModel
{
    return [[self alloc] initWithViewModel:viewModel];
}

- (void)registerCollectionViewReusableClasses:(UICollectionView *)collectionView
{
    Class gridViewCellClass = [GalleryGridViewCell class];
    Class staggeredGridViewCellClass = [GalleryStaggeredGridViewCell class];
    Class listViewCellClass = [GalleryListViewCell class];

    [collectionView registerClass:gridViewCellClass forCellWithReuseIdentifier:NSStringFromClass(gridViewCellClass)];
    [collectionView registerClass:staggeredGridViewCellClass forCellWithReuseIdentifier:NSStringFromClass(staggeredGridViewCellClass)];
    [collectionView registerClass:listViewCellClass forCellWithReuseIdentifier:NSStringFromClass(listViewCellClass)];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier;
    if ([collectionView.delegate conformsToProtocol:@protocol(ReuseIdentifierProviderProtocol)])
    {
        reuseIdentifier = [(id <ReuseIdentifierProviderProtocol>)collectionView.delegate reuseIdentifierForIndexPath:indexPath];
    }

    if (reuseIdentifier == nil) reuseIdentifier = NSStringFromClass([GalleryGridViewCell class]);

    GalleryImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.item = [self.viewModel itemForIndexPath:indexPath];
    return cell;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    if (aProtocol == @protocol(IncrementalDataLoadingProtocol))
    {
        return [self.viewModel conformsToProtocol:aProtocol];
    }

    return [super conformsToProtocol:aProtocol];
}

- (void)validateViewModelIsIncrementalLoading
{
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSAssert([self.viewModel conformsToProtocol:@protocol(IncrementalDataLoadingProtocol)], @"ViewModel should conforms to IncrementalDataLoadingProtocol protocol");
#pragma clang diagnostic pop
}

- (BOOL)loadingInProgress
{
    [self validateViewModelIsIncrementalLoading];
    return [(id <IncrementalDataLoadingProtocol>)self.viewModel loadingInProgress];
}

- (BOOL)nextBatchAvailable
{
    [self validateViewModelIsIncrementalLoading];
    return [(id <IncrementalDataLoadingProtocol>)self.viewModel nextBatchAvailable];
}

- (void)loadNextBatch
{
    [self validateViewModelIsIncrementalLoading];
    [(id <IncrementalDataLoadingProtocol>)self.viewModel loadNextBatch];
}

@end
