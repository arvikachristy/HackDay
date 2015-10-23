//
//  NewFlatmateViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 22/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFlatmateViewController : UIViewController<UIGestureRecognizerDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *flatmateDP;
@property (weak, nonatomic) IBOutlet UIButton *changeDPButton;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UITextField *flatmateNameTextField;
@property (nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end
