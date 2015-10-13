//
//  TaskViewController.m
//  localHackDay
//
//  Created by Burns on 10/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "TaskViewController.h"
#import "NewCategoryViewController.h"

@interface TaskViewController ()

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addCategoriesButton:(id)sender {
    [self showViewController:[NewCategoryViewController alloc]  sender:nil];
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
