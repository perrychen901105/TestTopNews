//
//  NSArray+Map.m
//  TestTopNews
//
//  Created by PerryChen on 1/4/16.
//  Copyright © 2016 PerryChen. All rights reserved.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)
- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
}
@end
