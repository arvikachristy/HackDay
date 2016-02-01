//
//  LoginViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 16/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterUserViewController.h"
#import "RegisterFlatViewController.h"
#import "MainTabBarController.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize errorLabel;
@synthesize usernameBox;
@synthesize passwordBox;
@synthesize activeField;
@synthesize loginButton;
@synthesize registerButton;
@synthesize scrollView;
@synthesize FBloginPlaceholder;

-(void)viewWillAppear:(BOOL)animated{
    errorLabel.text = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    passwordBox.secureTextEntry = YES;
    
    self.usernameBox.delegate = self;
    self.passwordBox.delegate = self;
    
    [self registerForKeyboardNotifications];
    UITapGestureRecognizer *tapDismissKB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:tapDismissKB];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    FBSDKLoginButton *FBloginButton = [[FBSDKLoginButton alloc] init];
    FBloginButton.center = FBloginPlaceholder.center;
    //FBloginButton.frame = FBloginPlaceholder.frame;
    //FBloginButton.center = scrollView.center;
    //FBloginButton.delegate = self;
    FBloginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [FBloginPlaceholder addSubview:FBloginButton];


    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    NSString *trimmedUsername = [usernameBox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *trimmedPassword = [passwordBox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [PFUser logInWithUsernameInBackground:trimmedUsername password:trimmedPassword block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (!error) {
            PFUser *currentUser = [PFUser currentUser];
            PFObject *usersFlat = currentUser[@"Flat"];
            
            
            if (usersFlat.objectId) {
                MainTabBarController *home = [[MainTabBarController alloc]init];
                [self showViewController:home sender:nil];
            }else{
                RegisterFlatViewController *regFlat = [[RegisterFlatViewController alloc]init];
                [self showViewController:regFlat sender:nil];
            }
        }
        if (error) {
            NSLog(@"%@",error);
            errorLabel.text = @"Invalid Login";
            return;
        };
    }];
    
   /* if([PFUser logInWithUsername:trimmedUsername password:trimmedPassword] == nil){
        errorLabel.text = @"Invalid Login";
        return;
    }*/
    
    
    

}

- (IBAction)registerAction:(id)sender {
    [self showViewController:[RegisterUserViewController alloc] sender:nil];
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
    
    [scrollView setContentSize:self.view.frame.size];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    /*
     CGPoint activeFieldCenter;
     activeFieldCenter.x = activeField.frame.origin.x + (activeField.frame.size.width);
     activeFieldCenter.y = activeField.frame.origin.y + (activeField.frame.size.height);
     */
    
    
    //if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
    [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    //}
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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
