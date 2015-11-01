//
//  NewTaskViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 11/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "NewTaskViewController.h"
#import "NewCategoryViewController.h"
#import <Parse/parse.h>

@interface NewTaskViewController ()

@end

@implementation NewTaskViewController

@synthesize errorLabel;

@synthesize createTaskTitle;
@synthesize activeField;

@synthesize createTaskCategoryPicker;
@synthesize categories;
@synthesize selectedCategory;

@synthesize submitNewTaskButton;


-(void)viewWillAppear:(BOOL)animated{
    animated = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.navigationItem.title = @"New Task";
    [self fetchCategoriesFromDB];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    errorLabel.text = @"";
    createTaskTitle.delegate = self;
    createTaskCategoryPicker.dataSource = self;
    createTaskCategoryPicker.delegate = self;
    
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
    
    PFObject *object = [categories objectAtIndex:row];
    NSString *pickerRowTitle = object[@"CategoryTitle"];
    return pickerRowTitle;
     
   // return [taskCategories objectAtIndex:row];
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
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"Owner" equalTo:currentUser[@"Flat"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            for (PFObject *object in objects) {
                [categories addObject:object];
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                [createTaskCategoryPicker reloadAllComponents];
                if([categories count] < 1){
                    selectedCategory = nil;
                    return;
                }
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


-(IBAction)addSubmitNewTaskButton:(id)sender{
    NSString *trimmedTitle = [createTaskTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(trimmedTitle.length < 1){
        errorLabel.text = @"task title can't be blank";
        return;
    }
    
    
    PFObject *task = [PFObject objectWithClassName:@"Task"];
    task[@"TaskTitle"] = trimmedTitle;
    task[@"Category"] = selectedCategory;
    task[@"Status"] = @"Needs Action";
    task[@"StatusOwner"] = [PFUser currentUser];
    task[@"StatusDate"] = [NSDate date];
    
    [task saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            if (succeeded==YES) {
                [self goBack];
            }
        }else{
            NSLog(@"%@",error);
        }
        
    }];
    
}


-(void)dismissKB{
    [activeField resignFirstResponder];
    activeField = nil;
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
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
