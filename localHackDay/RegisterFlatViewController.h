//
//  RegisterFlatViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 24/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterFlatViewController : UIViewController<UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *flatNameBox;
@property (weak, nonatomic) IBOutlet UITextField *numberOfPeopleBox;
@property (weak, nonatomic) IBOutlet UITextField *existingFlatTextField;

@property (nonatomic) UITextField *activeField;


@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end