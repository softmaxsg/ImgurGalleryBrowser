//
//  UICollectionViewControllerEx.m
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "UICollectionViewControllerEx.h"
#import "IncrementalDataLoadingProtocol.h"

@interface UICollectionViewControllerEx ()

@property (nonatomic, weak) UIRefreshControl *refreshControl;

@property (nonatomic) CGPoint lastContentOffset;

- (void)createRefreshControl;

@end

@implementation UICollectionViewControllerEx

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createRefreshControl];
}

- (void)createRefreshControl
{
    [self.refreshControl removeFromSuperview];

    UICollectionView *collectionView = self.collectionView;
    collectionView.alwaysBounceVertical = YES;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [collectionView addSubview:refreshControl];
    self.refreshControl = refreshControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    if (contentOffset.y > self.lastContentOffset.y)
    {
        CGFloat nextBatchLoadingOffset = MAX(scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds), 0);
        if (contentOffset.y >= nextBatchLoadingOffset)
        {
            if ([self.collectionView.dataSource conformsToProtocol:@protocol(IncrementalDataLoadingProtocol)])
            {
                id <IncrementalDataLoadingProtocol> incrementalDataSource = (id <IncrementalDataLoadingProtocol>)self.collectionView.dataSource;
                if (![incrementalDataSource loadingInProgress] && [incrementalDataSource nextBatchAvailable])
                {
                    [incrementalDataSource loadNextBatch];
                }
            }
        }
    }

    self.lastContentOffset = contentOffset;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.lastContentOffset = scrollView.contentOffset;
}

@end
