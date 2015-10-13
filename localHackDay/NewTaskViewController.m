//
//  NewTaskViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 11/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "NewTaskViewController.h"

@interface NewTaskViewController ()

@end

@implementation NewTaskViewController

@synthesize createTaskTitle;
@synthesize createTaskCategory;
@synthesize taskCategories;
@synthesize submitNewTask;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  
    
    taskCategories = [[NSArray alloc] initWithObjects:@"Bills", @"Groceries", @"Lightbulbs", nil];
   
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return taskCategories.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [taskCategories objectAtIndex:row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
