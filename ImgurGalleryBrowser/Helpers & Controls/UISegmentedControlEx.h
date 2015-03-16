//
//  UISegmentedControlEx.h
//
//  Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import UIKit;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
@interface UISegmentedControlEx : UISegmentedControl

@property (nonatomic) BOOL allowsDeselection;
@property (nonatomic) id selectedSegmentValue;

- (instancetype)initWithItems:(NSArray *)items values:(NSArray *)values;

- (id)valueForSegmentAtIndex:(NSUInteger)segment;
- (void)setValue:(id)value forSegmentAtIndex:(NSUInteger)segment;

- (void)insertSegmentWithItem:(id)item value:(id)value atIndex:(NSUInteger)segment animated:(BOOL)animated;
- (void)insertSegmentWithTitle:(NSString *)title value:(id)value atIndex:(NSUInteger)segment animated:(BOOL)animated;
- (void)insertSegmentWithImage:(UIImage *)image value:(id)value  atIndex:(NSUInteger)segment animated:(BOOL)animated;

@end

@interface UISegmentedControlEx (Unavailable)

- (instancetype)initWithItems:(NSArray *)items __attribute__((unavailable("Use initWithItems:values: instead")));
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated __attribute__((unavailable("Use insertSegmentWithTitle:value:atIndex:animated instead")));
- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated __attribute__((unavailable("Use insertSegmentWithImage:value:atIndex:animated instead")));

@end

#pragma clang diagnostic pop