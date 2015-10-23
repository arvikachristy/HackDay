//
//  SelectedCategoryViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 17/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SelectedCategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>{
    PFObject *selectedCategory;
}

-(id)initWithCategory: (PFObject*)category;

@property (weak, nonatomic) IBOutlet UITableView *tasksTableView;
@property NSMutableArray *tasks;

@property (weak, nonatomic) IBOutlet UIButton *addTaskButton;

@end
