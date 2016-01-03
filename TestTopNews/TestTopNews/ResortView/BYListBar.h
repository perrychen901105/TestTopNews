//
//  BYConditionBar.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResortViewHeader.h"
@interface BYListBar : UIScrollView

@property (nonatomic,copy) void(^arrowChange)();
@property (nonatomic,copy) void(^listBarItemClickBlock)(ResortItem *item , NSInteger itemIndex);
@property (nonatomic,copy) void(^listBarAddItemBlock)(ResortItem *item , NSInteger itemIndex);
@property (nonatomic,copy) void(^listBarDeleteItemBlock)(ResortItem *item , NSInteger itemIndex);
@property (nonatomic,copy) void(^listBarSwitchItemBlock)(NSInteger preIndex, NSInteger afterIndex);
@property (nonatomic,strong) NSMutableArray *visibleItemList;

-(void)operationFromBlock:(animateType)type item:(ResortItem *)item index:(int)index;
-(void)itemClickByScrollerWithIndex:(NSInteger)index;

@end
