//
//  SelectedCategoryViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 17/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "SelectedCategoryViewController.h"
#import "NewTaskViewController.h"
#import "SelectedTaskViewController.h"
#import "EditCategoryViewController.h"
#import <Parse/parse.h>

@interface SelectedCategoryViewController ()
@end

@implementation SelectedCategoryViewController

@synthesize tasksTableView;
@synthesize tasks;




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tasks = [[NSMutableArray alloc] init];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeRight];

    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.navigationItem.title = selectedCategory[@"CategoryTitle"];
    
    UIBarButtonItem *addTaskButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self
                                                                                  action:@selector(addTask)];
    UIBarButtonItem *editCategoryButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit"
                                                                          style:UIBarButtonItemStyleDone
                                                                         target:self
                                                                         action:@selector(editCategory)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:addTaskButton, editCategoryButton, nil]];
    [self fetchTasksFromDB];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(id)initWithCategory:(PFObject*)category{
    self = [super init];
    selectedCategory = category;
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tasks count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    PFObject *object = [tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = object[@"TaskTitle"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *selectedTask = [tasks objectAtIndex:indexPath.row];
    [self showViewController:[[SelectedTaskViewController alloc]initWithTask:selectedTask] sender:nil];
}

-(void) fetchTasksFromDB{
    [tasks removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"Category" equalTo:selectedCategory];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            for (PFObject *object in objects) {
                [tasks addObject:object];
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                //NSLog(@"%lu", [tasks count]);
                [tasksTableView reloadData];

            });
        }else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }

    }];
}

-(void)addTask{
    [self showViewController:[NewTaskViewController alloc]  sender:nil];
}

-(void)editCategory{
    EditCategoryViewController *editCategoryVC = [[EditCategoryViewController alloc]initWithCategory:selectedCategory];
    [self showViewController:editCategoryVC sender:nil];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
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
