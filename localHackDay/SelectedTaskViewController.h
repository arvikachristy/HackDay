//
//  SelectedTaskViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 18/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SelectedTaskViewController : UIViewController<UIGestureRecognizerDelegate>{
    PFObject *selectedTask;
}

-(id)initWithTask: (PFObject*)task;


@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;


@property (weak, nonatomic) IBOutlet UILabel *currentStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusOwnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStatusDateLabel;


@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end
