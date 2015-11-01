//
//  MyTasksViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 31/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTasksViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTasksTableView;
@property NSMutableArray *myTasks;


@end
