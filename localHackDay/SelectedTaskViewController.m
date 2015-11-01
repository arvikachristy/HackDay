//
//  SelectedTaskViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 18/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "SelectedTaskViewController.h"
#import "EditTaskViewController.h"
#import <Parse/parse.h>

@interface SelectedTaskViewController ()

@end

@implementation SelectedTaskViewController

@synthesize categoryLabel;
@synthesize currentStatusLabel;
@synthesize statusOwnerLabel;
@synthesize currentStatusDateLabel;
@synthesize actionButton;

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.navigationItem.title = selectedTask[@"TaskTitle"];

    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(editTask)];
    [self.navigationItem setRightBarButtonItem:edit animated:YES];


    PFObject *parentCategory = selectedTask[@"Category"];
    [parentCategory fetchInBackgroundWithBlock:^(PFObject * _Nullable category, NSError * _Nullable error) {
        if (!error) {
            categoryLabel.text = category[@"CategoryTitle"];
        }else{
            NSLog(@"%@",error);
        };
    }];
   
    
    currentStatusLabel.text = selectedTask[@"Status"];
    
    PFUser *statusOwner = selectedTask[@"StatusOwner"];
    [statusOwner fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            statusOwnerLabel.text = statusOwner[@"Name"];
        }else{
            NSLog(@"%@",error);
        };
    }];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *statusDate = selectedTask[@"StatusDate"];
    currentStatusDateLabel.text =[dateFormat stringFromDate:statusDate];
    
    if([currentStatusLabel.text isEqualToString:@"Needs Action"]){
        actionButton.hidden = false;
        [actionButton setTitle:@"Check Out" forState:UIControlStateNormal];
    } else if([currentStatusLabel.text isEqualToString:@"Checked Out"]){
        actionButton.hidden = false;
        [actionButton setTitle:@"Mark Completed" forState:UIControlStateNormal];
    } else{
        actionButton.hidden = true;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeRight];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)initWithTask:(PFObject *)task{
    self = [super init];
    selectedTask = task;
    return self;
}

-(void)editTask{
    EditTaskViewController *editTaskVC = [[EditTaskViewController alloc]initWithTask:selectedTask];
    [self showViewController:editTaskVC sender:nil];
}

-(IBAction)addActionButton:(id)sender{
    NSString *currentStatus = selectedTask[@"Status"];
    if([currentStatus isEqualToString:@"Needs Action"]){
        actionButton.hidden = false;
        selectedTask[@"Status"] = @"Checked Out";
        selectedTask[@"StatusOwner"] = [PFUser currentUser];
        selectedTask[@"StatusDate"] = [NSDate date];
        [selectedTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                if (succeeded == YES) {
                    [self goBack];
                }
                else{
                    return;
                }
            }else{
                NSLog(@"%@",error);
            }
        }];
    } else if([currentStatus isEqualToString:@"Checked Out"]){
        actionButton.hidden = false;
        selectedTask[@"Status"] = @"Completed";
        selectedTask[@"StatusOwner"] = [PFUser currentUser];
        selectedTask[@"StatusDate"] = [NSDate date];
        [selectedTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                if (succeeded == YES) {
                    
                    PFUser *currentUser = [PFUser currentUser];
                    NSNumber *tasksCompleted = currentUser[@"TasksCompleted"];
                    NSInteger tasksInt = [tasksCompleted integerValue];
                    tasksInt ++;
                    currentUser[@"TasksCompleted"] = [NSNumber numberWithInteger:tasksInt];
                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(!error){
                            [self goBack];
                        }else{
                            NSLog(@"%@", error);
                        }
                    }];
                }
                else{
                    return;
                }
            }else{
                NSLog(@"%@",error);
            }
        }];
    }

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
