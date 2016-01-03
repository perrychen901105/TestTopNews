//
//  BYSelectionDetails.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResortViewHeader.h"
@interface BYDetailsList : UIScrollView

@property (nonatomic,strong) NSMutableArray *topView;
@property (nonatomic,strong) NSMutableArray *centerView;
@property (nonatomic,strong) NSMutableArray *bottomView;
@property (nonatomic,strong) NSMutableArray *listAll;

@property (nonatomic,copy) void(^longPressedBlock)();
@property (nonatomic,copy) void(^opertionFromItemBlock)(animateType type, ResortItem *item, int index);
-(void)itemRespondFromListBarClickWithItemName:(ResortItem *)item;


@end
