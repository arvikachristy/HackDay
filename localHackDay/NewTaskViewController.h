//
//  NewTaskViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 11/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NewTaskViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UITextField *createTaskTitle;
@property (nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UIPickerView *createTaskCategoryPicker;
@property (strong, nonatomic) NSMutableArray *categories;
@property (nonatomic) PFObject *selectedCategory;

@property (weak, nonatomic) IBOutlet UIButton *submitNewTaskButton;

@end
