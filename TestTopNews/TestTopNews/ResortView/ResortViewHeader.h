//
//  ResortViewHeader.h
//  TestTopNews
//
//  Created by PerryChen on 12/28/15.
//  Copyright © 2015 PerryChen. All rights reserved.
//
#import "ResortItem.h"
#ifndef ResortViewHeader_h
#define ResortViewHeader_h

#define kStatusHeight 20
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define ColorListBarHighlight [UIColor redColor]
#define ColorListBarNormal [UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1.0]

#define padding 15
#define itemPerLine 4
#define kItemW (kScreenW-padding*(itemPerLine+1))/itemPerLine
#define kItemH 25

#define kBtnCancelTop 10
#define kBtnCancelWidth 80
#define kBtnCancelHeight 20
#define kBtnCancelRight 10

#define kDeleteBarHeight 30     // 我的频道 高度

#define channelHeight 20        // 频道高度

typedef enum{
    topViewClick = 0,
    FromTopToTop = 1,
    FromTopToTopLast = 2,
    FromTopToBottomHead = 3,
    FromBottomToTopLast = 4,
    FromTopToCenterHead = 5,
    FromCenterToTopLast = 6,
} animateType;

#endif /* ResortViewHeader_h */
