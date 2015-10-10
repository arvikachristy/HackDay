//
//  RegisterViewController.h
//  localHackDay
//
//  Created by Apple on 10/10/2015.
//  Copyright (c) 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *flatNameBox;
@property (weak, nonatomic) IBOutlet UITextField *numberOfPeopleBox;
@property (weak, nonatomic) IBOutlet UITextField *passcodeBox;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end
