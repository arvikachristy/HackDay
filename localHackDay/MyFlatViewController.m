//
//  MyFlatViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 21/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "MyFlatViewController.h"
#import "NewFlatmateViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface MyFlatViewController ()

@end

@implementation MyFlatViewController
@synthesize flatImage;
@synthesize leaderboardTableview;
@synthesize flatMates;
@synthesize addFlatmateButton;
@synthesize changeUserButton;
@synthesize signOutButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    PFUser *myFlat = [PFUser currentUser];
    self.navigationItem.title = myFlat[@"flatName"];
    UIImage *settingsIcon = [UIImage imageNamed:@"settingsIcon2.png"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:settingsIcon style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //[self fetchFlatmatesFromDB];
    flatMates = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [self fetchFlatmatesFromDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [flatMates count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        static NSString *CellIdentifier = @"Cell";
        
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                                forIndexPath:indexPath];
        
        if ([flatMates count] < 1) {
            return cell;
        }
        PFObject *flatmate = [flatMates objectAtIndex:indexPath.row];
        
        cell.textLabel.text = flatmate[@"Name"];
    
        return cell;

}

-(void) fetchFlatmatesFromDB{
    [flatMates removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Flatmate"];
    [query whereKey:@"Flat" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            for (PFObject *object in objects) {
                [flatMates addObject:object];
            }
            dispatch_async(dispatch_get_main_queue(), ^ {
                [leaderboardTableview reloadData];
            });
        }else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(IBAction)addflatMates:(id)sender{
    [self showViewController:[NewFlatmateViewController alloc] sender:nil];
}

-(IBAction)signOutFlat:(id)sender{
    [PFUser logOut];
    
    [self.tabBarController dismissViewControllerAnimated:NO completion:nil];
    //[self showViewController:[LoginViewController alloc] sender:nil];
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
