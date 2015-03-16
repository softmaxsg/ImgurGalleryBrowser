//
//  UISegmentedControlEx.m
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "UISegmentedControlEx.h"

@interface UISegmentedControlEx ()

@property (nonatomic) NSMutableArray *values;

- (void)clearSelection;

@end

@implementation UISegmentedControlEx

- (id)selectedSegmentValue
{
    NSInteger selectedSegmentIndex = self.selectedSegmentIndex;
    return [self valueForSegmentAtIndex:selectedSegmentIndex >= 0 ? selectedSegmentIndex : NSNotFound];
}

- (void)setSelectedSegmentValue:(id)selectedSegmentValue
{
    NSUInteger segmentIndex = [self.values indexOfObject:selectedSegmentValue];
    self.selectedSegmentIndex = segmentIndex != NSNotFound ? segmentIndex : UISegmentedControlNoSegment;
}

- (instancetype)initWithItems:(NSArray *)items values:(NSArray *)values
{
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSAssert(items.count == values.count, @"Number of items and values should match");
#pragma clang diagnostic pop

    if ((self = [super initWithItems:items]))
    {
        self.values = values.mutableCopy ?: [NSMutableArray array];
    }

    return self;
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [super removeSegmentAtIndex:segment animated:animated];

    [self.values removeObjectAtIndex:segment];
}

- (void)removeAllSegments
{
    [super removeAllSegments];

    [self.values removeAllObjects];
}

- (id)valueForSegmentAtIndex:(NSUInteger)segment
{
    return segment != NSNotFound ? self.values[segment] : nil;
}

- (void)setValue:(id)value forSegmentAtIndex:(NSUInteger)segment
{
    self.values[segment] = value;
}

- (void)insertSegmentWithItem:(id)item value:(id)value atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    if ([item isKindOfClass:[NSString class]])
    {
        [super insertSegmentWithTitle:item atIndex:segment animated:animated];
    }
    else if ([item isKindOfClass:[UIImage class]])
    {
        [super insertSegmentWithImage:item atIndex:segment animated:animated];
    }
    else
    {
#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
        NSAssert(NO, @"Only NSString and UIImage items are supproted");
#pragma clang diagnostic pop
        return;
    }

    [self.values insertObject:value atIndex:segment];
}

- (void)insertSegmentWithTitle:(NSString *)title value:(id)value atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [self insertSegmentWithItem:title value:value atIndex:segment animated:animated];
}

- (void)insertSegmentWithImage:(UIImage *)image value:(id)value atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    [self insertSegmentWithItem:image value:value atIndex:segment animated:animated];
}

- (void)clearSelection
{
    self.selectedSegmentIndex = UISegmentedControlNoSegment;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (self.selectedSegmentIndex == selectedSegmentIndex) return;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
    NSString *const selectedSegmentValuePropertyName = @"selectedSegmentValue";
#pragma clang diagnostic pop

    [self willChangeValueForKey:selectedSegmentValuePropertyName];
    [super setSelectedSegmentIndex:selectedSegmentIndex];
    [self didChangeValueForKey:selectedSegmentValuePropertyName];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSInteger previousSelectedIndex = self.selectedSegmentIndex;

    [super touchesBegan:touches withEvent:event];

    if (self.allowsDeselection && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0)
    {
        if (previousSelectedIndex == self.selectedSegmentIndex)
        {
            [self clearSelection];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSInteger previousSelectedIndex = self.selectedSegmentIndex;

    [super touchesEnded:touches withEvent:event];

    if (self.allowsDeselection && kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
    {
        if (previousSelectedIndex == self.selectedSegmentIndex)
        {
            [self clearSelection];
        }
    }
}

@end
