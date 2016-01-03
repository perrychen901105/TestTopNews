//
//  BYSelectNewBar.m
//  BYDailyNews
//
//  Created by bassamyan on 15/1/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BYDeleteBar.h"

@interface BYDeleteBar()

@end

@implementation BYDeleteBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeNewBar];
//        self.hidden= YES;
    }
    return self;
}
-(void)makeNewBar
{
    self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:(238.0)/255.0 green:(238.0)/255.0 blue:(238.0)/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.text = @"我的频道";
    [self addSubview:label];
    
    if (!self.hitText) {
        self.hitText = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10,10, 100, 11)];
        self.hitText.font = [UIFont systemFontOfSize:11];
        self.hitText.text = @"拖拽可以排序";
        self.hitText.textColor = [UIColor colorWithRed:(170.0)/255.0 green:(170.0)/255.0 blue:(170.0)/255.0 alpha:1.0];
        self.hitText.hidden = YES;
//        [self addSubview:self.hitText];
    }
    
    if (!self.sortBtn) {
        self.sortBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100, 5, 50, 20)];
        [self.sortBtn setTitle:@"排序" forState:0];
        [self.sortBtn setTitleColor:[UIColor redColor] forState:0];
        self.sortBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.sortBtn.layer.cornerRadius = 5;
        self.sortBtn.layer.borderWidth = 0.5;
        [self.sortBtn.layer setMasksToBounds:YES];
        self.sortBtn.layer.borderColor = [[UIColor redColor] CGColor];
        [self.sortBtn addTarget:self
                         action:@selector(sortBtnClick:)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sortBtn];
    }
    
}

-(void)sortBtnClick:(UIButton *)sender{
    if (sender.selected) {
        [sender setTitle:@"排序" forState:0];
        self.hitText.hidden = YES;
    }
    else{
        [sender setTitle:@"完成" forState:0];
        self.hitText.hidden = NO;
    }
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sortBtnClick"
                                                        object:sender
                                                      userInfo:nil];
}

@end
