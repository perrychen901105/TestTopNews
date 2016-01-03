//
//  BYSelectionView.h
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResortViewHeader.h"
typedef enum{
    top = 0,
    bottom = 1,
    center = 2,
}itemLocation;

typedef enum{
    otop = 0,
    obottom = 1,
    ocenter = 2,
}itemOriLocation;

@interface BYListItem : UIButton
{
    @public
    NSMutableArray *locateView;
    NSMutableArray *topView;
    NSMutableArray *centerView;
    NSMutableArray *bottomView;
}
@property (nonatomic,strong) UIView   *hitTextLabel;
@property (nonatomic, strong) UIView *sectionOneTitle;
@property (nonatomic, strong) UIView *sectionTwoTitle;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UIButton *hiddenBtn;
@property (nonatomic,assign) itemLocation location;
@property (nonatomic, assign) itemOriLocation olocation;
@property (nonatomic,copy) ResortItem *item;

@property (nonatomic,copy) void(^longPressBlock)();
@property (nonatomic,copy) void(^operationBlock)(animateType type, ResortItem *item, int index);


@property (nonatomic,strong) UIPanGestureRecognizer *gesture;
@property (nonatomic,strong) UILongPressGestureRecognizer *longGesture;

@end
