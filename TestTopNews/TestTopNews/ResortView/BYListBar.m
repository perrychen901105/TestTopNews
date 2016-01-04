//
//  BYConditionBar.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYListBar.h"
#import "ResortViewHeader.h"
#import "UIButton+ResortItem.h"

#define kDistanceBetweenItem 32
#define kExtraPadding 15
#define itemFont 13

@interface BYListBar()

@property (nonatomic, assign) CGFloat maxWidth;
//@property (nonatomic, strong) UIView *btnBackView;
@property (nonatomic, strong) UIView *viewBarBottom;
@property (nonatomic, strong) UIButton *btnSelect;
@property (nonatomic, strong) NSMutableArray *btnLists;

@end

@implementation BYListBar

-(NSMutableArray *)btnLists{
    if (_btnLists == nil) {
        _btnLists = [NSMutableArray array];
    }
    return _btnLists;
}

-(void)setVisibleItemList:(NSMutableArray *)visibleItemList{
    
    _visibleItemList = visibleItemList;
    
    if (!self.viewBarBottom) {
        self.maxWidth = 20;
        ResortItem *itemR = visibleItemList[0];
        CGFloat itemW = [self calculateSizeWithFont:itemFont Text:itemR.strTitle].size.width;
        self.viewBarBottom = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 2, itemW+kExtraPadding, 2)];
        self.viewBarBottom.backgroundColor = ColorListBarHighlight;
        [self addSubview:self.viewBarBottom];
        
        
        self.backgroundColor = RGBColor(238.0, 238.0, 238.0);
//        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 50);
        self.showsHorizontalScrollIndicator = NO;
        for (int i =0; i<visibleItemList.count; i++) {
            [self makeItemWithTitle:visibleItemList[i]];
        }
        self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
    }
}


-(void)makeItemWithTitle:(ResortItem *)itemTitle{
    CGFloat itemW = [self calculateSizeWithFont:itemFont Text:itemTitle.strTitle].size.width;
    UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
//    item.tag = itemTitle.index;
    item.itemID = itemTitle.strID;
    item.titleLabel.font = [UIFont systemFontOfSize:itemFont];
    [item setTitle:itemTitle.strTitle forState:0];
    [item setTitleColor:ColorListBarNormal forState:UIControlStateNormal];
    [item setTitleColor:ColorListBarNormal forState:UIControlStateHighlighted];
    [item setTitleColor:ColorListBarHighlight forState:UIControlStateSelected];
    [item addTarget:self
             action:@selector(itemClick:)
   forControlEvents:UIControlEventTouchUpInside];
    
//    item.backgroundColor = [UIColor redColor];
    self.maxWidth += itemW+kDistanceBetweenItem;
    [self.btnLists addObject:item];
    [self addSubview:item];
    if (!self.btnSelect) {
        [item setTitleColor:ColorListBarHighlight forState:UIControlStateNormal];
        self.btnSelect = item;
    }
    self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
}

-(void)itemClick:(UIButton *)sender{
    if (self.btnSelect != sender) {
        [self.btnSelect setTitleColor:ColorListBarNormal forState:0];
        [sender setTitleColor:[UIColor redColor] forState:0];
        self.btnSelect = sender;
        
        if (self.listBarItemClickBlock) {
//            self.listBarItemClickBlock(sender.titleLabel.text,[self findIndexOfListsWithTitle:sender.titleLabel.text]);
            //TODO: 需要修改成匹配ID
            for (int i = 0; i < self.visibleItemList.count; i++) {
                ResortItem *curItem = self.visibleItemList[i];
                if ([curItem.strID isEqualToString:sender.itemID]) {
                    self.listBarItemClickBlock(curItem,[self findIndexOfListsWithID:curItem]);
                    
                    break;
                }
            }
        }
    }
    //TODO: 需要修改成匹配ID
    NSInteger intSelect = 0;
    for (int i = 0; i < self.visibleItemList.count; i++) {
        ResortItem *curItem = self.visibleItemList[i];
        if ([curItem.strID isEqualToString:sender.itemID]) {
            intSelect = [self findIndexOfListsWithID:curItem];
            break;
        }
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect btnBackViewRect = self.viewBarBottom.frame;
        btnBackViewRect.size.width = sender.frame.size.width+kExtraPadding;
        self.viewBarBottom.frame = btnBackViewRect;
        CGFloat changeW = sender.frame.origin.x-(btnBackViewRect.size.width-sender.frame.size.width)/2-10;
        self.viewBarBottom.transform  = CGAffineTransformMakeTranslation(changeW, 0);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint changePoint;
            NSLog(@"the sender frame is %@, content size is %@, view frame is %@",NSStringFromCGRect(sender.frame),NSStringFromCGSize(self.contentSize),NSStringFromCGRect(self.frame));
//            if (sender.frame.origin.x >= kScreenW - 150 && sender.frame.origin.x < self.contentSize.width-200) {
//                changePoint = CGPointMake(sender.frame.origin.x - 200, 0);
//            }
////            else if (sender.frame.origin.x >= self.contentSize.width-200){
//            else if (sender.frame.origin.x >= self.contentSize.width-40-sender.frame.size.width-kExtraPadding){
//
//                changePoint = CGPointMake(self.contentSize.width-350, 0);
//            }
//            else{
//                changePoint = CGPointMake(0, 0);
//            }
            if (sender.frame.origin.x >= self.contentSize.width - 150 && sender.frame.origin.x < self.contentSize.width-200) {
                changePoint = CGPointMake(sender.frame.origin.x - 200, 0);
            }
            else if (sender.frame.origin.x + sender.frame.size.width < self.frame.size.width) {
                changePoint = CGPointMake(0, 0);
            }
            //            else if (sender.frame.origin.x >= self.contentSize.width-200){
            else if (sender.frame.origin.x >= self.contentSize.width-200-20){
                changePoint = CGPointMake(self.contentSize.width-350, 0);
            }
            else if (sender.frame.origin.x <= self.contentSize.width-[self getRemainWidth:intSelect]){
                
                changePoint = CGPointMake(sender.frame.origin.x-sender.frame.size.width, 0);
            }
            else{
                changePoint = CGPointMake(0, 0);
            }
            self.contentOffset = changePoint;
        }];
    }];
}

- (CGFloat)getRemainWidth:(NSInteger)indexRemain
{
    CGFloat almostWidth = 0.0f;
    for (int i = (int)indexRemain; i < self.visibleItemList.count; i++) {
        ResortItem *itemRemain = self.visibleItemList[i];
        CGFloat itemW = [self calculateSizeWithFont:itemFont Text:itemRemain.strTitle].size.width;
        almostWidth += itemW+kDistanceBetweenItem;
    }
    return almostWidth;
}

-(void)itemClickByScrollerWithIndex:(NSInteger)index{
    UIButton *item = (UIButton *)self.btnLists[index];
    [self itemClick:item];
}

-(void)operationFromBlock:(animateType)type item:(ResortItem *)item index:(int)index{
    switch (type) {
        case topViewClick:
//            [self itemClick:self.btnLists[[self findIndexOfListsWithTitle:item]]];
            [self itemClick:self.btnLists[[self findIndexOfListsWithID:item]]];
            if (self.arrowChange) {
                self.arrowChange();
            }
            break;
        case FromTopToTop:
            [self switchPositionWithItemName:item index:index];
            break;
        case FromTopToTopLast:
            [self switchPositionWithItemName:item index:self.visibleItemList.count-1];
            break;
        case FromTopToBottomHead:
            if ([self.btnSelect.itemID isEqualToString:item.strID]) {
                [self itemClick:self.btnLists[0]];
            }
//            NSInteger intS = [self findIndexOfListsWithTitle:item];
            NSInteger intS = [self findIndexOfListsWithID:item];
            [self removeItemWithTitle:item];
            [self resetFrame];
            if (self.listBarDeleteItemBlock) {
                
                self.listBarDeleteItemBlock(item, intS);
            }
            break;
        case FromBottomToTopLast:
            [self.visibleItemList addObject:item];
            if (self.listBarAddItemBlock) {
                self.listBarAddItemBlock(item, self.visibleItemList.count-1);
            }
            [self makeItemWithTitle:item];
            break;
        case FromTopToCenterHead:
            if ([self.btnSelect.itemID isEqualToString:item.strID]) {
                [self itemClick:self.btnLists[0]];
            }
//            NSInteger intS2 = [self findIndexOfListsWithTitle:item];
            NSInteger intS2 = [self findIndexOfListsWithID:item];
            [self removeItemWithTitle:item];
            [self resetFrame];
            if (self.listBarDeleteItemBlock) {
                
                self.listBarDeleteItemBlock(item, intS2);
            }
            break;
        case FromCenterToTopLast:
            [self.visibleItemList addObject:item];
            if (self.listBarAddItemBlock) {
                self.listBarAddItemBlock(item, self.visibleItemList.count-1);
            }
            [self makeItemWithTitle:item];
            break;
        default:
            break;
    }
}

-(void)switchPositionWithItemName:(ResortItem *)item index:(NSInteger)index{
    NSLog(@"the pre index is %d, after index is %d",[self findIndexOfListsWithID:item],index);
//    UIButton *button = self.btnLists[[self findIndexOfListsWithTitle:item]];
    UIButton *button = self.btnLists[[self findIndexOfListsWithID:item]];
    [self.visibleItemList removeObject:item];
    [self.btnLists removeObject:button];
    [self.visibleItemList insertObject:item atIndex:index];
    [self.btnLists insertObject:button atIndex:index];
    [self itemClick:self.btnSelect];
//    NSInteger preInd = [self findIndexOfListsWithTitle:item];
    NSInteger preInd = [self findIndexOfListsWithID:item];
    NSInteger afterInd = index;
    if (preInd != index) {
        if (self.listBarSwitchItemBlock) {
            self.listBarSwitchItemBlock(preInd, index);
        }
    }
    [self resetFrame];
}

-(void)removeItemWithTitle:(ResortItem *)itemTitle{
//    NSInteger index = [self findIndexOfListsWithTitle:itemTitle];
    NSInteger index = [self findIndexOfListsWithID:itemTitle];
    UIButton *select_button = self.btnLists[index];
    [self.btnLists[index] removeFromSuperview];
    [self.btnLists removeObject:select_button];
    [self.visibleItemList removeObject:itemTitle];
}

- (NSInteger)findIndexOfListsWithID:(ResortItem *)item {
    for (int i =0; i < self.visibleItemList.count; i++) {
        ResortItem *curItem = self.visibleItemList[i];
        if ([item.strID isEqualToString:curItem.strID]) {
            return i;
        }
    }
    return 0;
}

//-(NSInteger)findIndexOfListsWithTitle:(ResortItem *)itemTitle{
//    for (int i =0; i < self.visibleItemList.count; i++) {
//        ResortItem *curItem = self.visibleItemList[i];
//        if ([itemTitle.strTitle isEqualToString:curItem.strTitle]) {
//            return i;
//        }
//    }
//    return 0;
//}

-(void)resetFrame{
    self.maxWidth = 20;
    for (int i = 0; i < self.visibleItemList.count; i++) {
        [UIView animateWithDuration:0.0001 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            ResortItem *itemF = (ResortItem *)self.visibleItemList[i];
            CGFloat itemW = [self calculateSizeWithFont:itemFont Text:itemF.strTitle].size.width;
            [[self.btnLists objectAtIndex:i] setFrame:CGRectMake(self.maxWidth, 0, itemW, self.frame.size.height)];
            self.maxWidth += kDistanceBetweenItem + itemW;
        } completion:^(BOOL finished){
        }];
    }
    self.contentSize = CGSizeMake(self.maxWidth, self.frame.size.height);
}

-(CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}

@end
