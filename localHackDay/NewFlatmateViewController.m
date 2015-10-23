//
//  NewFlatmateViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 22/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "NewFlatmateViewController.h"
#import <Parse/Parse.h>

@interface NewFlatmateViewController ()

@end

@implementation NewFlatmateViewController
@synthesize flatmateDP;
@synthesize changeDPButton;
@synthesize errorLabel;
@synthesize flatmateNameTextField;
@synthesize activeField;
@synthesize doneButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
       self.navigationItem.title = @"New Flatmate";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeRight];
    
    UITapGestureRecognizer *tapDismissKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:tapDismissKB];
    
    errorLabel.text = @"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self dismissKB];
}

-(void)dismissKB{
    [activeField resignFirstResponder];
    activeField = nil;
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clickedDoneButton:(id)sender{
    NSString *flatmateName = flatmateNameTextField.text;
    if(flatmateName.length < 1) {
        errorLabel.text = @"Please Enter A Name";
        return;
    }else if (flatmateName.length > 32){
        errorLabel.text = @"Your Name Is Too Long...Sorry!";
        return;
    }
    PFObject *flatmate = [PFObject objectWithClassName:@"Flatmate"];
    flatmate[@"Name"] = flatmateName;
    flatmate[@"TasksCompleted"] = [NSNumber numberWithInteger:0];
    flatmate[@"Flat"] = [PFUser currentUser];
    [flatmate save];
    [self.navigationController popViewControllerAnimated:YES];
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
