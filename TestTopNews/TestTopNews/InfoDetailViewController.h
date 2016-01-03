//
//  InfoDetailViewController.h
//  TestTopNews
//
//  Created by PerryChen on 12/31/15.
//  Copyright © 2015 PerryChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResortItem.h"

@interface InfoDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) ResortItem *itemSelect;
@end
