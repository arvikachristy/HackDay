//
//  LoginViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 16/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UITextField *usernameBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordBox;
@property (nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *FBloginPlaceholder;

@end
