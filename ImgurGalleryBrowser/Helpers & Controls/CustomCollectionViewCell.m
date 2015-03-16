//
//  CustomCollectionViewCell.m
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self configureCell];
    }

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self configureCell];
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    [self clearControls];
}

- (void)configureCell
{

}

- (void)clearControls
{
}

@end
