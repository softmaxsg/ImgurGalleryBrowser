//
//  NSMutableDictionary(SafeExtras)
//
// Copyright (c) 2015 Vitaly Chupryk. All rights reserved.
//

#import "NSMutableDictionary+SafeExtras.h"

@implementation NSMutableDictionary (SafeExtras)

- (id)safeObjectForKey:(id)aKey unwrapNilValue:(BOOL)unwrapNilValue
{
    id anObject = self[aKey];
    if (unwrapNilValue && [anObject isKindOfClass:[NSNull class]])
    {
        return nil;
    }

    return anObject;
}

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey wrapNilValue:(BOOL)wrapNilValue
{
    if (anObject == nil && !wrapNilValue) return;
    self[aKey] = anObject ?: [NSNull null];
}

@end