//
//  GalleryViewController(Layout)
//  ImgurGalleryBrowser
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryViewController+Layout.h"
#import <BlocksKit/NSObject+BKAssociatedObjects.h>
#import "GalleryGridViewCell.h"
#import "GalleryStaggeredGridViewCell.h"
#import "GalleryListViewCell.h"

@implementation GalleryViewController (Layout)

- (UICollectionViewFlowLayout *)gridLayout
{
    return [self bk_associatedValueForKey:@selector(gridLayout)];
}

- (void)setGridLayout:(UICollectionViewFlowLayout *)gridLayout
{
    [self bk_associateValue:gridLayout withKey:@selector(gridLayout)];
}

- (CHTCollectionViewWaterfallLayout *)staggeredGridLayout
{
    return [self bk_associatedValueForKey:@selector(staggeredGridLayout)];
}

- (void)setStaggeredGridLayout:(CHTCollectionViewWaterfallLayout *)staggeredGridLayout
{
    [self bk_associateValue:staggeredGridLayout withKey:@selector(staggeredGridLayout)];
}

- (UICollectionViewFlowLayout *)listLayout
{
    return [self bk_associatedValueForKey:@selector(listLayout)];
}

- (void)setListLayout:(UICollectionViewFlowLayout *)listLayout
{
    [self bk_associateValue:listLayout withKey:@selector(listLayout)];
}

- (void)updateGalleryLayoutForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    UICollectionView *collectionView = self.collectionView;
    UICollectionViewLayout *collectionLayout;

    CGRect collectionViewBounds = collectionView.bounds;
    CGFloat collectionViewWidth = CGRectGetWidth(collectionViewBounds);
    CGFloat collectionViewHeight = CGRectGetHeight(collectionViewBounds);

    if ((collectionViewWidth > collectionViewHeight && UIInterfaceOrientationIsPortrait(interfaceOrientation)) ||
        (collectionViewWidth < collectionViewHeight && UIInterfaceOrientationIsLandscape(interfaceOrientation)))
    {
        CGFloat tmp = collectionViewWidth;
        collectionViewWidth = collectionViewHeight;
        collectionViewHeight = tmp;
    }

    GalleryLayoutMode layoutMode = self.layoutMode;
    if (layoutMode == GalleryLayoutModeGrid || layoutMode == GalleryLayoutModeStaggeredGrid)
    {
        CGFloat itemWidth;
        if (collectionViewWidth < collectionViewHeight) // Portrait mode
        {
            if (collectionViewWidth >= 768) itemWidth = 180;
            else if (collectionViewWidth >= 414) itemWidth = 130;
            else if (collectionViewWidth >= 375) itemWidth = 120;
            else itemWidth = 100;
        }
        else // Landscape mode
        {
            if (collectionViewWidth >= 1024) itemWidth = 180;
            else if (collectionViewWidth >= 736) itemWidth = 130;
            else if (collectionViewWidth >= 667) itemWidth = 120;
            else itemWidth = 100;
        }

        NSUInteger cellsPerRow = (NSUInteger)floorf(collectionViewWidth / itemWidth);
        CGFloat itemSpacing = floorf((collectionViewWidth - cellsPerRow * itemWidth) / (cellsPerRow - 1));
        CGSize itemSize = CGSizeMake(itemWidth, itemWidth);

        if (layoutMode == GalleryLayoutModeStaggeredGrid)
        {
            CHTCollectionViewWaterfallLayout *waterfallLayout = self.staggeredGridLayout;
            if (waterfallLayout == nil)
            {
                waterfallLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
                self.staggeredGridLayout = waterfallLayout;
            }

            [waterfallLayout bk_associateValue:[NSValue valueWithCGSize:itemSize] withKey:@selector(itemSize)];

            waterfallLayout.itemRenderDirection = CHTCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst;
            waterfallLayout.columnCount = cellsPerRow;
            waterfallLayout.minimumColumnSpacing = itemSpacing;
            waterfallLayout.minimumInteritemSpacing = itemSpacing;

            collectionLayout = waterfallLayout;
        }
        else // GalleryLayoutModeGrid
        {
            UICollectionViewFlowLayout *gridLayout = self.gridLayout;
            if (gridLayout == nil)
            {
                gridLayout = [[UICollectionViewFlowLayout alloc] init];
                self.gridLayout = gridLayout;
            }

            gridLayout.itemSize = itemSize;
            gridLayout.minimumInteritemSpacing = itemSpacing;
            gridLayout.minimumLineSpacing = itemSpacing;

            collectionLayout = gridLayout;
        }
    }
    else if (layoutMode == GalleryLayoutModeList)
    {
        CGFloat itemSpacing = 10;

        CGFloat itemHeight;
        NSUInteger cellsPerRow;
        if (collectionViewWidth >= 1024)
        {
            itemHeight = 160;
            cellsPerRow = 3;
        }
        else if (collectionViewWidth >= 768)
        {
            itemHeight = 160;
            cellsPerRow = 2;
        }
        else if (collectionViewWidth >= 480)
        {
            itemHeight = 90;
            cellsPerRow = 2;
        }
        else
        {
            itemHeight = 90;
            cellsPerRow = 1;
        }

        UICollectionViewFlowLayout *listLayout = self.listLayout;
        if (listLayout == nil)
        {
            listLayout = [[UICollectionViewFlowLayout alloc] init];
            self.listLayout = listLayout;
        }

        listLayout.itemSize = CGSizeMake((collectionViewWidth - itemSpacing * (cellsPerRow - 1)) / cellsPerRow, itemHeight);;
        listLayout.minimumInteritemSpacing = itemSpacing;
        listLayout.minimumLineSpacing = itemSpacing;

        collectionLayout = listLayout;
    }
    else
    {
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
        NSAssert(NO, @"Should not happen");
#pragma clang diagnostic pop
    }

    if (collectionView.collectionViewLayout != collectionLayout)
    {
        [collectionView performBatchUpdates:^
        {
            [collectionView setCollectionViewLayout:collectionLayout animated:NO];
            [collectionLayout invalidateLayout];

            [collectionView reloadItemsAtIndexPaths:collectionView.indexPathsForVisibleItems];
        } completion:nil];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.layoutMode == GalleryLayoutModeStaggeredGrid)
    {
        CGSize itemSize = [[collectionViewLayout bk_associatedValueForKey:@selector(itemSize)] CGSizeValue];
        CGSize originalSize = [self.viewModel sizeForItemAtIndexPath:indexPath bestFittingWidth:itemSize.width];

        // We should do some height limitation because some images are very long and it looks weird
        CGFloat scale = originalSize.width / itemSize.width;
        return CGSizeMake(itemSize.width, MIN(originalSize.height / scale, itemSize.height * 2));
    }
    else
    {
        if ([collectionViewLayout respondsToSelector:@selector(itemSize)])
        {
            return [(id)collectionViewLayout itemSize];
        }
    }

    return CGSizeZero;
}

- (NSString *)reuseIdentifierForIndexPath:(NSIndexPath *)indexPath
{
    if (self.layoutMode == GalleryLayoutModeGrid) return NSStringFromClass([GalleryGridViewCell class]);
    else if (self.layoutMode == GalleryLayoutModeStaggeredGrid) return NSStringFromClass([GalleryStaggeredGridViewCell class]);
    else if (self.layoutMode == GalleryLayoutModeList) return NSStringFromClass([GalleryListViewCell class]);

    return nil;
}

@end