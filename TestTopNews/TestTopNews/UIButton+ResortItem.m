//
//  UIButton+ResortItem.m
//  TestTopNews
//
//  Created by PerryChen on 1/4/16.
//  Copyright © 2016 PerryChen. All rights reserved.
//
#import "UIButton+ResortItem.h"
#import <objc/runtime.h>

const char* const kItemIDKey   = "kItemIDKey";

@implementation UIButton (ResortItem)

- (void)setItemID:(NSString *)itemID
{
    objc_setAssociatedObject(self, kItemIDKey, itemID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)itemID
{
    return objc_getAssociatedObject(self, kItemIDKey);
}

@end
