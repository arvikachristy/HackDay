//
//  RegisterViewController.m
//  localHackDay
//
//  Created by Apple on 10/10/2015.
//  Copyright (c) 2015 team. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize flatNameBox;
@synthesize numberOfPeopleBox;
@synthesize passcodeBox;
@synthesize registerButton;
@synthesize errorLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    passcodeBox.secureTextEntry = YES;
    [numberOfPeopleBox setKeyboardType:UIKeyboardTypeNumberPad];
    errorLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {
    if (flatNameBox.text.length < 5) {
        errorLabel.text = @"Flatname too short";
        return;
    } else if (flatNameBox.text.length > 32) {
        errorLabel.text = @"Flatname too long";
        return;
    }
    
    if (passcodeBox.text.length < 5) {
        errorLabel.text = @"passcode too short";
        return;
    } else if (passcodeBox.text.length > 16) {
        errorLabel.text = @"passcode too long";
        return;
    }
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
