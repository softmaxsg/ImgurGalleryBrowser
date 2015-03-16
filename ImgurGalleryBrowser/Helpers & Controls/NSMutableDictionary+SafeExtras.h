//
//  NSMutableDictionary(SafeExtras)
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

@import Foundation;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
@interface NSMutableDictionary (SafeExtras)

- (id)safeObjectForKey:(id)aKey unwrapNilValue:(BOOL)unwrapNilValue;
- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey wrapNilValue:(BOOL)wrapNilValue;

@end
#pragma clang diagnostic pop