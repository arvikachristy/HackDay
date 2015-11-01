//
//  EditCategoryViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 27/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditCategoryViewController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>{
    PFObject *editingCategory;
}

-(id)initWithCategory:(PFObject*)category;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UITextField *editCategoryTitle;
@property (nonatomic) UITextField *activeField;


@end
