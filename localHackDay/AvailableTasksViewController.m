//
//  AvailableTasksViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 18/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "AvailableTasksViewController.h"
#import "NewTaskViewController.h"
#import "SelectedTaskViewController.h"
#import <Parse/parse.h>
#import "loggedFlatmate.h"

@interface AvailableTasksViewController ()

@end

@implementation AvailableTasksViewController

@synthesize availableTasksTableView;
@synthesize availableTasks;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    // Do any additional setup after loading the view from its nib.
    availableTasks = [[NSMutableArray alloc] init];
  }

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.title = @"Available Tasks";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self fetchCategoriesFromDB];
    
    loggedFlatmate *sharedLoggedFlatmate = [loggedFlatmate sharedLoggedFlatmate];
    NSLog(@"%@", sharedLoggedFlatmate.test);
    
   // pagesTabBar.selectedItem = avaliableTasksTabBarItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTasksButton:(id)sender {
    
    [self showViewController:[NewTaskViewController alloc]  sender:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [availableTasks count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    if ([availableTasks count] < 1) {
        [availableTasksTableView reloadData];
        return cell;
    }
    PFObject *object = [availableTasks objectAtIndex:indexPath.row];
    cell.textLabel.text = object[@"TaskTitle"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *selectedTask = [availableTasks objectAtIndex:indexPath.row];
    SelectedTaskViewController *selectedVC = [[SelectedTaskViewController alloc]initWithTask:selectedTask];
    [self showViewController:selectedVC sender:nil];
    //[self showViewController:[[SelectedTaskViewController alloc]initWithTask:selectedTask] sender:nil];
}


-(void) fetchCategoriesFromDB{
    [availableTasks removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    [query whereKey:@"Owner" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable categories, NSError * _Nullable error) {
        if(!error){
            for (PFObject *category in categories) {
                
                PFQuery *query = [PFQuery queryWithClassName:@"Task"];
                [query whereKey:@"Category" equalTo:category];
                [query whereKey:@"Status" equalTo:@"Needs Action"];
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    if(!error){
                        for (PFObject *object in objects) {
                            [availableTasks addObject:object];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [availableTasksTableView reloadData];
                        });
                    }else{
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            
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
