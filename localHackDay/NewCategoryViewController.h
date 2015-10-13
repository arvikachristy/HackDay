//
//  NewCategoryViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 13/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewCategoryViewController : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *createCategoryTitle;
@property (weak, nonatomic) IBOutlet UIButton *submitNewCategory;

@end
