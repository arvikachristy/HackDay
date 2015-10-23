//
//  RegisterViewController.m
//  localHackDay
//
//  Created by Apple on 10/10/2015.
//  Copyright (c) 2015 team. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize flatNameBox;
@synthesize numberOfPeopleBox;
@synthesize usernameBox;
@synthesize passwordBox;
@synthesize registerButton;
@synthesize errorLabel;
@synthesize scrollView;
@synthesize activeField;



- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.flatNameBox.delegate = self;
    self.numberOfPeopleBox.delegate = self;
    self.usernameBox.delegate = self;
    self.passwordBox.delegate = self;
    
    [self registerForKeyboardNotifications];
    
    
    passwordBox.secureTextEntry = YES;
    [numberOfPeopleBox setKeyboardType:UIKeyboardTypeNumberPad];
    
    
    errorLabel.text = @"";

    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeRight];
    
    
    UITapGestureRecognizer *tapDismissKB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:tapDismissKB];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {
    
    if (flatNameBox.text.length < 1) {
        errorLabel.text = @"Flatname too short";
        return;
    } else if (flatNameBox.text.length > 32) {
        errorLabel.text = @"Flatname too long";
        return;
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:numberOfPeopleBox.text];
    if ([myNumber integerValue] < 1) {
        errorLabel.text = @"too few people";
        return;
    }
    
    
    NSString *trimmedUsername = [usernameBox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([trimmedUsername containsString:@" "]){
        errorLabel.text = @"can't have space in username";
        return;
    }else if (trimmedUsername.length < 6) {
        errorLabel.text = @"username too short";
        return;
    } else if (trimmedUsername.length > 16) {
        errorLabel.text = @"username too long";
        return;
    }
    
    NSString *trimmedPassword = [passwordBox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([trimmedPassword containsString:@" "]){
        errorLabel.text = @"can't have space in password";
        return;
    }else if (trimmedPassword.length < 6) {
        errorLabel.text = @"password too short";
        return;
    } else if (trimmedPassword.length > 32) {
        errorLabel.text = @"password too long";
        return;
    }
    
    
    PFUser *user = [PFUser user];
    user[@"flatName"] = flatNameBox.text;
    user[@"numberOfPeople"] = myNumber;
    user.username = trimmedUsername;
    user.password = trimmedPassword;
    
    if ([user signUp] == YES) {
        errorLabel.text = @"";
        [self alertSuccess];
    }else{
        errorLabel.text = @"username taken :(";
        return;
    };
    
   }

-(void)alertSuccess{
    
    UIAlertController *sucess = [UIAlertController alertControllerWithTitle:@"Congratulations!" message:@"You can now login using your username and password" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [sucess addAction:ok];
    
    [self presentViewController:sucess animated:YES completion:nil];
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self dismissKB];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
      
    [scrollView setContentSize:scrollView.frame.size];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
   
    
    
    //if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
    [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    //}*/
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
   UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}


-(void)dismissKB{
    [activeField resignFirstResponder];
    activeField = nil;
}


-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
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
