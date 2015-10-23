//
//  AvailableTasksViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 18/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailableTasksViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *availableTasksTableView;
@property NSMutableArray *availableTasks;


@end
