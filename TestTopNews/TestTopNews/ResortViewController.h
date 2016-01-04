//
//  ResortViewController.h
//  TestTopNews
//
//  Created by PerryChen on 12/28/15.
//  Copyright © 2015 PerryChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYListBar.h"

@interface ResortViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *listTop;
@property (nonatomic,strong) NSMutableArray *listBottom;
@property (nonatomic,strong) NSMutableArray *listBottomTwo;

@property (nonatomic,strong) BYListBar *listBar;
@property (nonatomic,strong) ResortItem *itemSelect;
@property (nonatomic,copy) void(^resortRefresh)(NSMutableArray *arrListTop, NSMutableArray *arrListCenter, NSMutableArray *arrListBottom);
@end
