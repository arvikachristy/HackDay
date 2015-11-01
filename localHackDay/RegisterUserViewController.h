//
//  RegisterUserViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 24/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterUserViewController : UIViewController<UIGestureRecognizerDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate>{

    UIImagePickerController *imagePicker;

}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *flatmateDP;
@property (weak, nonatomic) IBOutlet UIButton *changeDPButton;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameBox;
@property (weak, nonatomic) IBOutlet UITextField *passwordBox;
@property (nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end
