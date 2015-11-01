//
//  RegisterUserViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 24/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "RegisterUserViewController.h"
#import <Parse/Parse.h>

@interface RegisterUserViewController ()

@end

@implementation RegisterUserViewController

@synthesize flatmateDP;
@synthesize nameTextField;
@synthesize usernameBox;
@synthesize passwordBox;
@synthesize registerButton;
@synthesize errorLabel;
@synthesize scrollView;
@synthesize activeField;



- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.nameTextField.delegate = self;
    self.usernameBox.delegate = self;
    self.passwordBox.delegate = self;
    
    [self registerForKeyboardNotifications];
    
    
    passwordBox.secureTextEntry = YES;
    
    
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
    
    NSString *name = nameTextField.text;
    if(name.length < 1){
        errorLabel.text = @"Please enter your name";
        return;
    }else if (name.length > 32){
        errorLabel.text = @"Sorry, your name is too long";
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
    user[@"Name"] = name;
    user[@"TasksCompleted"] = [NSNumber numberWithInt:0];
    user.username = trimmedUsername;
    user.password = trimmedPassword;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            if (succeeded==YES) {
                errorLabel.text = @"";
                if(flatmateDP.image){
                    NSData *imageData = UIImageJPEGRepresentation(flatmateDP.image, 0.5);
                    PFFile *imageFile = [PFFile fileWithName:@"dp.jpg" data:imageData];
                    user[@"Image"] = imageFile;
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if(!error){
                            [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
                                if(!error){
                                    [self alertSuccess];
                                }
                            }];
                        }
                        else{
                            NSLog(@"%@",error);
                        }
                    }];
                }
                else{
                    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
                        if(!error){
                            [self alertSuccess];
                        }
                    }];

                }
            }
        }
        else{
            NSLog(@"%@",error);
            errorLabel.text = @"username taken :(";
        }
    }];
   
    
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


-(IBAction)changeDP:(id)sender{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    flatmateDP.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end