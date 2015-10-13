//
//  NewCategoryViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 13/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "NewCategoryViewController.h"
#import "TaskViewController.h"

@interface NewCategoryViewController ()


@end

@implementation NewCategoryViewController

@synthesize createCategoryTitle;
@synthesize submitNewCategory;


-(void)swipeBack{
    [self showViewController:[TaskViewController alloc] sender:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeBack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeRight];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addSubmitNewCategory:(id)sender{
    [self showViewController:[TaskViewController alloc] sender:nil];
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
