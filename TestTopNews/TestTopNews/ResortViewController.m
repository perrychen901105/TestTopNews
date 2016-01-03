//
//  ResortViewController.m
//  TestTopNews
//
//  Created by PerryChen on 12/28/15.
//  Copyright © 2015 PerryChen. All rights reserved.
//

#import "ResortViewController.h"

#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"

#define kListBarH 30
#define kArrowW 40
#define kAnimationTime 0.8

@interface ResortViewController ()





@property (nonatomic,strong) BYDetailsList *detailsList;

@property (nonatomic,strong) BYArrow *arrow;

@end

@implementation ResortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(kScreenW - kBtnCancelWidth - kBtnCancelRight, kBtnCancelTop+64.0f, kBtnCancelWidth, kBtnCancelHeight);
    [btnCancel addTarget:self
                  action:@selector(popToPre) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnCancel];

    __weak typeof(self) unself = self;
    if (!self.detailsList) {
        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, 64.0f + 2 * kBtnCancelTop + kBtnCancelHeight, kScreenW, kScreenH-64.0f-2*kBtnCancelTop)];
        self.detailsList.listAll = [NSMutableArray arrayWithObjects:self.listTop,self.listBottom,self.listBottomTwo, nil];
//        self.detailsList.longPressedBlock = ^(){
//            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
//        };
        if (self.itemSelect) {
            [self.detailsList itemRespondFromListBarClickWithItemName:self.itemSelect];
        }
        self.detailsList.opertionFromItemBlock = ^(animateType type, ResortItem *item, int index){
            NSLog(@"%d,%@,%d",type,item.strID,index);
            [unself.listBar operationFromBlock:type item:item index:index];
            [unself popToPre];
        };
        [self.view addSubview:self.detailsList];
    }
//    if (!self.listBar) {
//        self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 64.0f, kScreenW, kListBarH)];
//        self.listBar.visibleItemList = listTop;
//        self.listBar.arrowChange = ^(){
//            if (unself.arrow.arrowBtnClick) {
//                unself.arrow.arrowBtnClick();
//            }
//        };
//        self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
//            [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
//            //添加scrollview
//            
//            //移动到该位置
////            unself.mainScroller.contentOffset =  CGPointMake(itemIndex * unself.mainScroller.frame.size.width, 0);
//        };
//        [self.view addSubview:self.listBar];
//    }
//    if (!self.deleteBar) {
//        self.deleteBar = [[BYDeleteBar alloc] initWithFrame:CGRectMake(0, 64.0f + 2 * kBtnCancelTop + kBtnCancelHeight, kScreenW, kListBarH)];
//        [self.view addSubview:self.deleteBar];
//    }
    // Do any additional setup after loading the view.
}

- (void)popToPre
{
    NSLog(@"the arr is %@",self.listTop);
    if (self.resortRefresh) {
        self.resortRefresh(self.listTop);
    }
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
