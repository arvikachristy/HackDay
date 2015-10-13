//
//  NewTaskViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 11/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTaskViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *createTaskTitle;

@property (weak, nonatomic) IBOutlet UIPickerView *createTaskCategory;
@property (strong, nonatomic) NSArray *taskCategories;

@property (weak, nonatomic) IBOutlet UIButton *submitNewTask;

@end
