//
//  EditTaskViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 19/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "EditTaskViewController.h"
#import "NewCategoryViewController.h"
#import <Parse/Parse.h>

@interface EditTaskViewController ()

@end

@implementation EditTaskViewController

@synthesize errorLabel;

@synthesize editTaskTitle;
@synthesize activeField;

@synthesize editTaskCategoryPicker;
@synthesize categories;
@synthesize selectedCategory;


-(void)viewWillAppear:(BOOL)animated{
    animated = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.navigationItem.title = @"Edit Task";
    
    editTaskTitle.text = editingTask[@"TaskTitle"];
    selectedCategory = editingTask[@"Category"];
    
    
    [self fetchCategoriesFromDB];
    
    [editTaskCategoryPicker selectRow:0 inComponent:0 animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    errorLabel.text = @"";
    editTaskTitle.delegate = self;
    editTaskCategoryPicker.dataSource = self;
    editTaskCategoryPicker.delegate = self;
    
    categories = [[NSMutableArray alloc] init];
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeRight];
    
    UITapGestureRecognizer *tapDismissKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:tapDismissKB];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self dismissKB];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [categories count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    PFObject *pickerCategory = [categories objectAtIndex:row];
    NSString *pickerRowTitle = pickerCategory[@"CategoryTitle"];
    
    return pickerRowTitle;
  }

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedCategory = [categories objectAtIndex:row];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) fetchCategoriesFromDB{
    [categories removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    [query whereKey:@"Owner" equalTo:[PFUser currentUser]];
    [query whereKey:@"objectId" notEqualTo:selectedCategory.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            for (PFObject *object in objects) {
                [categories addObject:object];
            }
            
            [categories insertObject:editingTask[@"Category"] atIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^ {
                [editTaskCategoryPicker reloadAllComponents];
                selectedCategory = [categories objectAtIndex:0];
            });
        }else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)addCategoriesButton:(id)sender {
    [self showViewController:[NewCategoryViewController alloc]  sender:nil];
}

-(IBAction)addSubmitEditedTaskButton:(id)sender{
    editingTask[@"TaskTitle"] = editTaskTitle.text;
    editingTask[@"Category"] = selectedCategory;
    [editingTask save];
    [self goBack];
}

-(IBAction)addDeleteTaskButton:(id)sender{
    
    [self alertDelete];
//    [self goBackTwice];
}

-(void)dismissKB{
    [activeField resignFirstResponder];
    activeField = nil;
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)goBackTwice{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(id)initWithTask:(PFObject*)task{
    self = [super init];
    editingTask = task;
    return self;
}


-(void)alertDelete{
    
    UIAlertController *delete = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *confirmDelete = [UIAlertAction actionWithTitle:@"Delete Task" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [editingTask deleteInBackground];
                             [self goBackTwice];
                             
                         }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [delete addAction:confirmDelete];
    [delete addAction:cancel];
    
    [self presentViewController:delete animated:YES completion:nil];
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
