//
//  MyTasksViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 31/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "MyTasksViewController.h"
#import "NewTaskViewController.h"
#import "SelectedTaskViewController.h"
#import <Parse/parse.h>

@interface MyTasksViewController ()

@end

@implementation MyTasksViewController

@synthesize myTasksTableView;
@synthesize myTasks;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Do any additional setup after loading the view from its nib.
    myTasks = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style: UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    self.navigationItem.title = @"My Tasks";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                          target:self
                                                                                          action:@selector(addTask)];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self fetchTasksFromDB];
    
    
    // pagesTabBar.selectedItem = avaliableTasksTabBarItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTask{
    [self showViewController:[NewTaskViewController alloc]  sender:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myTasks count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    if ([myTasks count] < 1) {
        //[myTasksTableView reloadData];
        return cell;
    }
    PFObject *object = [myTasks objectAtIndex:indexPath.row];
    cell.textLabel.text = object[@"TaskTitle"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *selectedTask = [myTasks objectAtIndex:indexPath.row];
    SelectedTaskViewController *selectedVC = [[SelectedTaskViewController alloc]initWithTask:selectedTask];
    [self showViewController:selectedVC sender:nil];
    //[self showViewController:[[SelectedTaskViewController alloc]initWithTask:selectedTask] sender:nil];
}


-(void) fetchTasksFromDB{
    [myTasks removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    PFUser *currentUser = [PFUser currentUser];
    [currentUser fetch];
    [query whereKey:@"StatusOwner" equalTo:currentUser];
    [query whereKey:@"Status" equalTo:@"Checked Out"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable tasks, NSError * _Nullable error) {
        if(!error){
            for (PFObject *task in tasks) {
                [myTasks addObject:task];
                NSLog(@"%@",task.objectId);
            }
            //dispatch_async(dispatch_get_main_queue(), ^ {
            [myTasksTableView reloadData];
            //});
        }else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
