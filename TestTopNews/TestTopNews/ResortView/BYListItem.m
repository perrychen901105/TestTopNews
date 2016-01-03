//
//  BYSelectionView.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYListItem.h"
#define kDeleteW 6
#define kItemFont 13
#define kItemSizeChangeAdded 2

@implementation BYListItem

- (void)setItem:(ResortItem *)item
{
    _item = item;
    
    [self setTitle:item.strTitle forState:0];
    [self setTitleColor:RGBColor(111.0, 111.0, 111.0) forState:0];
    self.titleLabel.font = [UIFont systemFontOfSize:kItemFont];
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [RGBColor(200.0, 200.0, 200.0) CGColor];
    self.layer.borderWidth = 0.5;
    self.backgroundColor = [UIColor whiteColor];
    [self addTarget:self
             action:@selector(operationWithoutHidBtn)
   forControlEvents:UIControlEventTouchUpInside];
    
    self.gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pangestureOperation:)];
    self.longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    self.longGesture.minimumPressDuration = 1;
    self.longGesture.allowableMovement = 20;
    [self addGestureRecognizer:self.longGesture];
    
    if (![item.strTitle isEqualToString:@"推荐"]) {
        if (!self.deleteBtn) {
            self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(-kDeleteW+2, -kDeleteW+2, 2*kDeleteW, 2*kDeleteW)];
            self.deleteBtn.userInteractionEnabled = NO;
            [self.deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:0];
            self.deleteBtn.layer.cornerRadius = self.deleteBtn.frame.size.width/2;
            self.deleteBtn.hidden = YES;
            self.deleteBtn.backgroundColor = RGBColor(111.0, 111.0, 111.0);
            [self addSubview:self.deleteBtn];
        }
    }
    if (!self.hiddenBtn) {
        self.hiddenBtn = [[UIButton alloc] initWithFrame:self.bounds];
        self.hiddenBtn.hidden = NO;
        [self.hiddenBtn addTarget:self
                           action:@selector(operationWithHidBtn)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.hiddenBtn];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sortButtonClick)
                                                 name:@"sortBtnClick"
                                               object:nil];
}

-(void)longPress{
    if (self.hiddenBtn.hidden == NO) {
        if (self.longPressBlock) {
            self.longPressBlock();
        }
        if (self.location == top) {
            [self addGestureRecognizer:self.gesture];
        }
    }
}

-(void)sortButtonClick{
    if (self.location == top){
        self.deleteBtn.hidden = !self.deleteBtn.hidden;
    }
    self.hiddenBtn.hidden = !self.hiddenBtn.hidden;
    if (self.gestureRecognizers) {
        [self removeGestureRecognizer:self.gesture];
    }
    if (self.hiddenBtn.hidden && self.location == top) {
        [self addGestureRecognizer:self.gesture];
    }
    
}

-(void)operationWithHidBtn{
    if (!self.hiddenBtn.hidden) {
        if (self.location == top) {
            [self setTitleColor:[UIColor redColor] forState:0];
            if (self.operationBlock) {
                self.operationBlock(topViewClick,self.item,0);
            }
            [self animationForWholeView];
        }
        else if (self.location == bottom){
//            [self addGestureRecognizer:self.longGesture];
            [self changeFromBottomToTop];
        }
        else if (self.location == center){
//            [self addGestureRecognizer:self.longGesture];
            [self changeFromCenterToTop];
        }
    }
}

-(void)operationWithoutHidBtn{
    if (self.location == top){
        if (self.olocation == ocenter) {
            [self changeFromTopToCenter];
        } else if (self.olocation == obottom){
            [self changeFromTopToBottom];
        }
    }
    else if (self.location == bottom) {
        self.deleteBtn.hidden = NO;
        [self addGestureRecognizer:self.gesture];
        [self changeFromBottomToTop];
    }
    else if (self.location == center) {
        self.deleteBtn.hidden = NO;
        [self addGestureRecognizer:self.gesture];
        [self changeFromCenterToTop];
    }
}

- (void)pangestureOperation:(UIPanGestureRecognizer *)pan{
    [self.superview exchangeSubviewAtIndex:[self.superview.subviews indexOfObject:self] withSubviewAtIndex:[[self.superview subviews] count] - 1];
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint center = pan.view.center;
    center.x += translation.x;
    center.y += translation.y;
    pan.view.center = center;
    [pan setTranslation:CGPointZero inView:pan.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            NSInteger indexX = (center.x <= kItemW+2*padding)? 0 : (center.x - kItemW-2*padding)/(padding+kItemW) + 1;
            NSInteger indexY = (center.y <= kItemH+2*padding)? 0 : (center.y - kItemH-2*padding)/(padding+kItemH) + 1;
            
            NSInteger index = indexX + indexY*itemPerLine;
            if (index == 0) {
                [self removeGestureRecognizer:self.gesture];
                [self animationForWholeView];
                return;
            }
            CGRect itemFrame = self.frame;
            [self setFrame:CGRectMake(itemFrame.origin.x-kItemSizeChangeAdded, itemFrame.origin.y-kItemSizeChangeAdded, itemFrame.size.width+kItemSizeChangeAdded*2, itemFrame.size.height+kItemSizeChangeAdded*2)];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            BOOL InTopView = [self whetherInAreaWithArray:topView Point:center];
            if (InTopView) {
                
                NSInteger indexX = (center.x <= kItemW+2*padding)? 0 : (center.x - kItemW-2*padding)/(padding+kItemW) + 1;
                NSInteger indexY = (center.y <= kItemH+2*padding)? 0 : (center.y - kItemH-2*padding)/(padding+kItemH) + 1;
                
                NSInteger index = indexX + indexY*itemPerLine;
                index = (index == 0)? 1:index;
                
                [locateView removeObject:self];
                [topView insertObject:self atIndex:index];
                locateView = topView;
                [self animationForTopView];
                if (self.operationBlock) {
                    self.operationBlock(FromTopToTop,self.item,(int)index);
                }
            }
            else if (!InTopView && center.y < [self TopViewMaxY]+50) {
                [locateView removeObject:self];
                [topView insertObject:self atIndex:topView.count];
                locateView = topView;
                [self animationForTopView];
                if (self.operationBlock) {
                    self.operationBlock(FromTopToTopLast,self.item,0);
                }
            }
//            else if (center.y > [self TopViewMaxY]+50){
//                [self changeFromTopToBottom];
//            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            [self animationForWholeView];
            break;
        default:
            break;
    }
}


-(void)changeFromTopToBottom{
    [locateView removeObject:self];
    [bottomView insertObject:self atIndex:0];
    locateView = bottomView;
    self.location = bottom;
    self.deleteBtn.hidden = YES;
    [self removeGestureRecognizer:self.gesture];
    if (self.operationBlock) {
        self.operationBlock(FromTopToBottomHead,self.item,0);
    }
    [self animationForWholeView];
}

-(void)changeFromBottomToTop{
    [locateView removeObject:self];
    [topView insertObject:self atIndex:topView.count];
    locateView = topView;
    self.location = top;
    if (self.operationBlock) {
        self.operationBlock(FromBottomToTopLast,self.item,0);
    }
    [self animationForWholeView];
}

- (void)changeFromTopToCenter{
    [locateView removeObject:self];
    [centerView insertObject:self atIndex:0];
    locateView = centerView;
    self.location = center;
    self.deleteBtn.hidden = YES;
    [self removeGestureRecognizer:self.gesture];
    if (self.operationBlock) {
        self.operationBlock(FromTopToCenterHead,self.item,0);
    }
    [self animationForWholeView];
}

- (void)changeFromCenterToTop{
    [locateView removeObject:self];
    [topView insertObject:self atIndex:topView.count];
    locateView = topView;
    self.location = top;
    if (self.operationBlock) {
        self.operationBlock(FromCenterToTopLast,self.item,0);
    }
    [self animationForWholeView];
}

- (BOOL)whetherInAreaWithArray:(NSMutableArray *)array Point:(CGPoint)point{
    int row = (array.count%itemPerLine == 0)? itemPerLine : array.count%itemPerLine;
    int column =  (int)(array.count-1)/itemPerLine+1;
    if ((point.x > 0 && point.x <=kScreenW &&point.y > 0 && point.y <= (kItemH + padding)*(column-1)+padding)||
        (point.x > 0 && point.x <= (row*(padding+kItemW)+padding)&& point.y > (kItemH + padding)*(column -1)+padding && point.y <= (kItemH+padding) * column+padding)){
        return YES;
    }
    return NO;
}

- (unsigned long)TopViewMaxY{
    unsigned long y = 0;
    y = ((topView.count-1)/itemPerLine+1)*(kItemH + padding) + padding;
    return y;
}

- (unsigned long)CenterViewMaxY{
    unsigned long y = 0;
    y = ((centerView.count-1)/itemPerLine+1)*(kItemH + padding) + padding;
    return y;
}

- (void)animationForTopView{
    for (int i = 0; i < topView.count; i++){
        if ([topView objectAtIndex:i] != self){
            [self animationWithView:[topView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine), padding/2+(kItemH + padding)*(i/itemPerLine)+kDeleteBarHeight, kItemW, kItemH)];
        }
    }
}
-(void)animationForBottomView{
    for (int i = 0; i < bottomView.count; i++) {
        if ([bottomView objectAtIndex:i] != self) {
            [self animationWithView:[bottomView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine), [self TopViewMaxY]+50+(kItemH+padding)*(i/itemPerLine), kItemW, kItemH)];
        }
    }
    [self animationWithView:self.hitTextLabel frame:CGRectMake(0,[self TopViewMaxY],kScreenW,30)];
}

- (void)animationForWholeView{
    for (int i = 0; i <topView.count; i++) {
        [self animationWithView:[topView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine), padding/2+(padding+kItemH)*(i/itemPerLine)+kDeleteBarHeight, kItemW, kItemH)];
    }
    [self animationWithView:self.hitTextLabel frame:CGRectMake(0,[self TopViewMaxY]+kDeleteBarHeight-padding,kScreenW,channelHeight)];
    [self animationWithView:self.sectionOneTitle frame:CGRectMake(20,CGRectGetMaxY(self.hitTextLabel.frame)+padding/2,kScreenW,channelHeight)];
    [self animationWithView:self.sectionTwoTitle frame:CGRectMake(20,CGRectGetMaxY(self.sectionOneTitle.frame) +[self CenterViewMaxY]-padding/2,kScreenW,channelHeight)];
    for (int i = 0; i < centerView.count; i++) {
//        [self animationWithView:[centerView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine),[self TopViewMaxY] + padding+(padding+kItemH)*(i/itemPerLine)+kDeleteBarHeight, kItemW, kItemH)];
        [self animationWithView:[centerView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine),CGRectGetMaxY(self.sectionOneTitle.frame) + padding/2+(padding+kItemH)*(i/itemPerLine), kItemW, kItemH)];
    }
    for (int i = 0; i < bottomView.count; i++) {
//        [self animationWithView:[bottomView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine), [self TopViewMaxY]+[self CenterViewMaxY]+50+(kItemH+padding)*(i/itemPerLine)+kDeleteBarHeight+20, kItemW, kItemH)];
        [self animationWithView:[bottomView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine), CGRectGetMaxY(self.sectionOneTitle.frame)+[self CenterViewMaxY]+(kItemH+padding)*(i/itemPerLine)+padding, kItemW, kItemH)];
    }
    
}

-(void)animationWithView:(UIView *)view frame:(CGRect)frame{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [view setFrame:frame];
    } completion:^(BOOL finished){}];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
