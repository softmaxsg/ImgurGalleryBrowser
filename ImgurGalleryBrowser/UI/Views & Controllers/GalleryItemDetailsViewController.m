//
//  GalleryItemDetailsViewController.m
//  ImgurGalleryBrowser
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "GalleryItemDetailsViewController.h"
#import "NSArray+BlocksKit.h"
#import "UIImageView+WebCache.h"
#import "UIImage+CreationUtils.h"
#import "IMGGalleryImage+Title.h"
#import "IMGGalleryAlbum+Title.h"

@interface GalleryItemDetailsViewController ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imagesViewWidthConstraint;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *ownerLabel;
@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *upVotesLabel;
@property (nonatomic, weak) IBOutlet UILabel *downVotesLabel;
@property (nonatomic, weak) IBOutlet UIView *imagesView;
@property (nonatomic, weak) IBOutlet UIImageView *scoreImageView;
@property (nonatomic, weak) IBOutlet UIImageView *upVotesImageView;
@property (nonatomic, weak) IBOutlet UIImageView *downVotesImageView;

@property (nonatomic) NSArray *imageViewsArray;

- (void)adjustConstraints;

- (void)configureControls;
- (void)updateControls;

- (void)shareTapped:(id)sender;

@end

@implementation GalleryItemDetailsViewController

- (instancetype)initWithItem:(id)item
{
    if ((self = [super initWithNibName:nil bundle:nil]))
    {
        self.item = item;
    }

    return self;
}

+ (instancetype)controllerWithItem:(id)item
{
    return [[self alloc] initWithItem:item];
}

- (void)setItem:(id)item
{
    if (_item != item)
    {
        _item = item;

        if (self.isViewLoaded)
        {
            [self updateControls];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareTapped:)];

    [self configureControls];
    [self updateControls];
}

- (void)adjustConstraints
{
    CGFloat contentWidth = CGRectGetWidth(self.view.bounds);
    self.titleLabel.preferredMaxLayoutWidth = contentWidth - 16;
    self.descriptionLabel.preferredMaxLayoutWidth = contentWidth - 16;

    self.imagesViewWidthConstraint.constant = contentWidth;
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];

    [self adjustConstraints];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self adjustConstraints];
}

- (void)configureControls
{
    void (^tintImageView)(UIImageView *) = ^(UIImageView *imageView)
    {
        imageView.image = [imageView.image imageWithTintColor:imageView.tintColor];
    };

    tintImageView(self.upVotesImageView);
    tintImageView(self.downVotesImageView);
    tintImageView(self.scoreImageView);
}

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
- (void)updateControls
{
    id item = self.item;

    self.navigationItem.title = [[item class] localizedKindString];

    NSString *title = [item title];
    NSString *itemOwner = [item accountURL];
    NSInteger score = [item score];
    NSInteger upVotes = [item ups];
    NSInteger downVotes = [item downs];

    NSString *itemDescription;
    NSArray *images;
    if ([item isKindOfClass:[IMGGalleryAlbum class]])
    {
        IMGGalleryAlbum *galleryAlbum = item;
        itemDescription = galleryAlbum.albumDescription;
        images = galleryAlbum.images;
    }
    else if ([item isKindOfClass:[IMGGalleryImage class]])
    {
        IMGGalleryImage *galleryImage = item;
        itemDescription = galleryImage.imageDescription;
        images = @[galleryImage];
    }
    else
    {
        NSAssert(NO, @"Should not happen");
    }

    self.titleLabel.text = title;
    self.descriptionLabel.text = itemDescription;
    self.ownerLabel.text = itemOwner;
    self.scoreLabel.text = @(score).stringValue;
    self.upVotesLabel.text = @(upVotes).stringValue;
    self.downVotesLabel.text = @(downVotes).stringValue;

    [self.imageViewsArray bk_each:^(UIImageView *imageView)
    {
        [imageView sd_cancelCurrentImageLoad];
        [imageView removeFromSuperview];
    }];

    __block UIImageView *previousImageView = nil;

    UIView *imagesView = self.imagesView;
    self.imageViewsArray = [images bk_map:^id(IMGImage *currentImage)
    {
        UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        currentImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [imagesView addSubview:currentImageView];

        NSURL *imageUrl = currentImage.url;
        [currentImageView sd_setImageWithURL:imageUrl
                            placeholderImage:nil
                                     options:SDWebImageProgressiveDownload
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                                   {
                                       if (error != nil)
                                       {
                                           NSLog(@"[ERROR] Can't load image %@. %@", imageUrl.absoluteString, error);
                                       }
                                   }];

        [currentImageView addConstraint:[NSLayoutConstraint constraintWithItem:currentImageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:currentImageView
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:currentImage.height / currentImage.width
                                                                      constant:0]];

        [imagesView addConstraint:[NSLayoutConstraint constraintWithItem:currentImageView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:previousImageView ?: imagesView
                                                               attribute:previousImageView != nil ? NSLayoutAttributeBottom : NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:0]];

        [imagesView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[currentImageView]-0-|"
                                                                           options:(NSLayoutFormatOptions)0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(currentImageView)]];

        previousImageView = currentImageView;

        return currentImageView;
    }];

    if (previousImageView != nil)
    {
        [imagesView addConstraint:[NSLayoutConstraint constraintWithItem:previousImageView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:imagesView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:0]];
    }
}
#pragma clang diagnostic pop

- (void)shareTapped:(id)sender
{
    id item = self.item;
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSArray *items = @[
        [NSString stringWithFormat:@"%@\n%@", [item title] ?: @"", [[item url] absoluteString] ?: @""],
        [self.imageViewsArray.firstObject image]
    ];
#pragma clang diagnostic pop

    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnavailableInDeploymentTarget"
    if ([activityController respondsToSelector:@selector(popoverPresentationController)])
    {
        if ([sender isKindOfClass:[UIBarButtonItem class]])
        {
            activityController.popoverPresentationController.barButtonItem = sender;
        }
        else if ([sender isKindOfClass:[UIView class]])
        {
            activityController.popoverPresentationController.sourceView = sender;
            activityController.popoverPresentationController.sourceRect = [sender bounds];
        }
    }
#pragma clang diagnostic pop
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
