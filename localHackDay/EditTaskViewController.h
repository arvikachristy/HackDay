//
//  EditTaskViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 19/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditTaskViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>{
    PFObject *editingTask;
}

-(id)initWithTask:(PFObject*)task;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UITextField *editTaskTitle;
@property (nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UIPickerView *editTaskCategoryPicker;
@property (strong, nonatomic) NSMutableArray *categories;
@property (nonatomic) PFObject *selectedCategory;

@property (weak, nonatomic) IBOutlet UIButton *submitEditedTaskButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteTaskButton;

@end
