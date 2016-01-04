//
//  ViewController.m
//  TestTopNews
//
//  Created by PerryChen on 12/28/15.
//  Copyright © 2015 PerryChen. All rights reserved.
//

#import "ViewController.h"
#import "ResortViewController.h"
#import "BYListBar.h"
#import "InfoDetailViewController.h"
#import "ResortViewHeader.h"

#define kListBarH 30
#define kArrowW 40
#define kAnimationTime 0.8

@interface ViewController () <UIScrollViewDelegate>
@property (nonatomic,strong) BYListBar *listBar;
@property (nonatomic,strong) UIButton *btnAdd;
@property (nonatomic,strong) UIScrollView *mainScroller;
@property (nonatomic,strong) NSMutableArray *arrTop;
@property (nonatomic,strong) NSMutableArray *arrCenter;
@property (nonatomic,strong) NSMutableArray *arrBottom;
@property (nonatomic,strong) ResortItem *itemSelect;
@end

@implementation ViewController

/**
 将几个修改操作进行整合，调整scroll的宽度，将scroll的滚动位置调好
 */

- (void)viewDidLoad {
    [super viewDidLoad];

    self.arrTop = [@[] mutableCopy];
    self.arrCenter = [@[] mutableCopy];
    self.arrBottom = [@[] mutableCopy];
    for (int i = 0; i < 10; i++) {
        if (i < 8) {
            NSString *strT = [NSString stringWithFormat:@"TOP%d",i+1];
            ResortItem *item = [ResortItem new];
            item.strTitle = strT;
            //        item.index = i;
            item.strID = strT;
            [self.arrTop addObject:item];
        } else {
            NSString *strT = [NSString stringWithFormat:@"CENTER%d",i+1];
            ResortItem *item = [ResortItem new];
            item.strTitle = strT;
            //        item.index = i;
            item.strID = strT;
            [self.arrTop addObject:item];
        }
    }
    for ( int i = 0; i < 20; i++) {
        NSString *strT = [NSString stringWithFormat:@"CENTER%d",i+1];
        ResortItem *item = [ResortItem new];
        item.strTitle = strT;
        //        item.index = i;
        item.strID = strT;
        [self.arrCenter addObject:item];
    }
    
    for ( int i = 0; i < 9; i++) {
        NSString *strT = [NSString stringWithFormat:@"BOTTOM%d",i+1];
        ResortItem *item = [ResortItem new];
        item.strTitle = strT;
//        item.index = i;
        item.strID = strT;
        [self.arrBottom addObject:item];
    }

    __weak typeof(self) unself = self;
    self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 64.0f, kScreenW-kArrowW, kListBarH)];
    self.listBar.visibleItemList = self.arrTop;

    self.listBar.listBarItemClickBlock = ^(ResortItem *item , NSInteger itemIndex){
//        [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
        //添加scrollview
        unself.itemSelect = item;
        //移动到该位置
        unself.mainScroller.contentOffset =  CGPointMake(itemIndex * unself.mainScroller.frame.size.width, 0);
    };
    self.listBar.listBarAddItemBlock = ^(ResortItem *item, NSInteger itemIndex) {
        unself.mainScroller.contentSize = CGSizeMake(kScreenW*unself.arrTop.count,unself.mainScroller.frame.size.height);
        [unself addScrollViewWithItemName:item index:itemIndex];
    };
    self.listBar.listBarDeleteItemBlock = ^(ResortItem *item, NSInteger itemIndex) {
        [unself removeScrollViewWithItemName:item index:itemIndex];
    };
    self.listBar.listBarSwitchItemBlock = ^(NSInteger preIndex, NSInteger afterIndex) {
        [unself switchScrollViewWithPreIndex:preIndex afterIndex:afterIndex];
    };
    [self.view addSubview:self.listBar];
    
    if (!self.btnAdd) {
        self.btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnAdd.frame = CGRectMake(kScreenW-kArrowW, 64.0f, kArrowW, kListBarH);
        [self.btnAdd addTarget:self
                        action:@selector(btnActionPush:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnAdd setBackgroundColor:[UIColor blueColor]];
        [self.view addSubview:self.btnAdd];
    }
    if (!self.mainScroller) {
        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH+64.0f, kScreenW , self.view.frame.size.height-kListBarH-64.0f)];
        self.mainScroller.backgroundColor = [UIColor yellowColor];
        self.mainScroller.bounces = NO;
        self.mainScroller.pagingEnabled = YES;
        self.mainScroller.showsHorizontalScrollIndicator = NO;
        self.mainScroller.showsVerticalScrollIndicator = NO;
        self.mainScroller.delegate = self;
        self.mainScroller.contentSize = CGSizeMake(kScreenW*self.arrTop.count,self.mainScroller.frame.size.height);
        [self.view insertSubview:self.mainScroller atIndex:0];
        for (int i = 0; i < self.arrTop.count; i++) {
            [self addScrollViewWithItemName:self.arrTop[i] index:i];
        }
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnActionPush:(id)sender {
    __weak typeof(self) unself = self;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    ResortViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResortViewController"];
    vc.listBar = self.listBar;
    vc.listTop = self.arrTop;
    vc.listBottom = self.arrCenter;
    vc.listBottomTwo = self.arrBottom;
    if (self.itemSelect != nil) {
        vc.itemSelect = self.itemSelect;
    }
    // 可优化，将所有操作结果放在这里
    vc.resortRefresh = ^(NSMutableArray *arrListTop, NSMutableArray *arrListCenter, NSMutableArray *arrListBottom) {
        NSMutableArray *arrMulList = [self.childViewControllers mutableCopy];
        for (InfoDetailViewController *vc in self.childViewControllers) {
            [vc removeFromParentViewController];
        }
        for (int i = 0; i < arrListTop.count; i++) {
            ResortItem *itemOri = arrListTop[i];
            for (InfoDetailViewController *vcDetail in arrMulList) {
                if ([itemOri.strID isEqualToString:vcDetail.itemSelect.strID]) {
                    [self addChildViewController:vcDetail];
                    break;
                }
            }
        }
        self.arrTop = arrListTop;
        self.arrCenter = arrListCenter;
        self.arrBottom = arrListBottom;
        [self loopSubViews];
    };
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)addScrollViewWithItemName:(ResortItem *)item index:(NSInteger)index{
    InfoDetailViewController *detailVC = (InfoDetailViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InfoDetailViewController"];
    detailVC.view.frame = CGRectMake(index * self.mainScroller.frame.size.width, 0, self.mainScroller.frame.size.width, self.mainScroller.frame.size.height);
    detailVC.lblTitle.text = [NSString stringWithFormat:@"%ld",index];
    detailVC.itemSelect = item;
    [self addChildViewController:detailVC];
    
    detailVC.view.tag = index;
    [self.mainScroller addSubview:detailVC.view];
    
}

- (void)loopSubViews
{
    for (int i = 0; i < self.childViewControllers.count; i++) {
        InfoDetailViewController *vcD = self.childViewControllers[i];
        vcD.view.frame = CGRectMake(i * self.mainScroller.frame.size.width, 0, self.mainScroller.frame.size.width, self.mainScroller.frame.size.height);
        vcD.view.tag = i;
    }
}

- (void)removeScrollViewWithItemName:(ResortItem *)item index:(NSInteger)index {
    for (UIView *sview in self.mainScroller.subviews) {
        if (sview.tag == index) {
            [sview removeFromSuperview];
            break;
        }
    }
    InfoDetailViewController *vcD = self.childViewControllers[index];
    [vcD removeFromParentViewController];
    [self loopSubViews];
    self.mainScroller.contentSize = CGSizeMake(kScreenW*self.arrTop.count,self.mainScroller.frame.size.height);
}

- (void)switchScrollViewWithPreIndex:(NSInteger)preIndex afterIndex:(NSInteger)afterIndex
{
    InfoDetailViewController *vcPre = self.childViewControllers[preIndex];
    InfoDetailViewController *vcAfter = self.childViewControllers[afterIndex];
    if (vcPre == nil || vcAfter == nil) {
        return;
    }
    UIView *preView = [self.mainScroller viewWithTag:preIndex];
    UIView *afterView = [self.mainScroller viewWithTag:afterIndex];
    CGRect tempRect = CGRectZero;
    tempRect = preView.frame;
    preView.frame = afterView.frame;
    afterView.frame = tempRect;
    
    NSMutableArray *arrTempControllers = [self.childViewControllers mutableCopy];
    arrTempControllers[preIndex] = vcAfter;
    arrTempControllers[afterIndex] = vcPre;
    for (InfoDetailViewController *vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    for (InfoDetailViewController *vc in arrTempControllers) {
        [self addChildViewController:vc];
    }

    NSInteger tempTag = vcPre.view.tag;
    vcPre.view.tag = vcAfter.view.tag;
    vcAfter.view.tag = tempTag;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.listBar itemClickByScrollerWithIndex:scrollView.contentOffset.x / self.mainScroller.frame.size.width];
}

@end
