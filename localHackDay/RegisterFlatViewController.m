//
//  RegisterFlatViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 24/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "RegisterFlatViewController.h"
#import "MainTabBarController.h"
#import <Parse/Parse.h>

@interface RegisterFlatViewController ()

@end

@implementation RegisterFlatViewController

@synthesize flatNameBox;
@synthesize numberOfPeopleBox;
@synthesize registerButton;
@synthesize errorLabel;
@synthesize scrollView;
@synthesize activeField;
@synthesize existingFlatTextField;



- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.flatNameBox.delegate = self;
    self.numberOfPeopleBox.delegate = self;
    self.existingFlatTextField.delegate = self;
    
    [self registerForKeyboardNotifications];
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
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *trimmedFlatId =[existingFlatTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(trimmedFlatId.length > 0){
        PFQuery *query = [PFQuery queryWithClassName:@"Flat"];
        [query getObjectInBackgroundWithId:trimmedFlatId block:^(PFObject *existingFlat, NSError *error){
            if(!error){
                NSLog(@"%@",existingFlat.objectId);
                currentUser[@"Flat"] = existingFlat;
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error) {
                        if (succeeded==YES) {
                            MainTabBarController *home = [[MainTabBarController alloc]init];
                            [self showViewController:home sender:nil];
                        }
                    }else{
                        NSLog(@"%@",error);
                    }
                }];
            }else{
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                errorLabel.text = @"Wrong Code?";
                [PFUser logOutInBackground];
                return;
            }
        }];
    }else{
        NSLog(@"wrong output");
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
        
        
        PFObject *flat = [PFObject objectWithClassName:@"Flat"];
        flat[@"FlatName"] = flatNameBox.text;
        flat[@"NumberOfPeople"] = myNumber;
        [flat saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                if (succeeded==YES) {
                    currentUser[@"Flat"] = flat;
                    [currentUser save];
                    MainTabBarController *home = [[MainTabBarController alloc]init];
                    [self showViewController:home sender:nil];
                }
            }
            else{
                NSLog(@"%@",error);
            }
        }];
        
        
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
