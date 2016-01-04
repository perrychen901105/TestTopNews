//
//  NSArray+Map.h
//  TestTopNews
//
//  Created by PerryChen on 1/4/16.
//  Copyright © 2016 PerryChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)
- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;
@end
