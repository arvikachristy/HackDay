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
#import <QuartzCore/QuartzCore.h>

@interface MyFlatViewController ()

@end

@implementation MyFlatViewController
@synthesize flatImage;
@synthesize leaderboardTableview;
@synthesize flatMates;
@synthesize addFlatmateButton;
@synthesize signOutButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    PFUser *me = [PFUser currentUser];
    PFObject *myFlat = me[@"Flat"];
    [myFlat fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable flat, NSError * _Nullable error) {
        if (!error) {
            self.navigationItem.title = myFlat[@"FlatName"];
        }else{
            NSLog(@"%@",error);
        }
    }];
    
    UIImage *settingsIcon = [UIImage imageNamed:@"settingsIcon2.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:settingsIcon style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
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

//    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell2.indentationLevel = 0;
    
    UIColor *myMintGreen = [UIColor colorWithRed:0.39 green:1.00 blue:0.47 alpha:1.0];

    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = myMintGreen;
    [cell2 setSelectedBackgroundView:bgColorView];
    
    [tableView registerClass:[cell2 class] forCellReuseIdentifier:@"Cell"];
    
    
    //UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
  //                                                          forIndexPath:indexPath];
    
    if ([flatMates count] < 1) {
        return cell2;
    }
    
    
    PFObject *flatmate = [flatMates objectAtIndex:indexPath.row];
    cell2.textLabel.text = flatmate[@"Name"];
    NSNumber *countComplete = flatmate[@"TasksCompleted"];
    cell2.detailTextLabel.text = [countComplete stringValue];
    PFFile *flatmateDP = flatmate[@"Image"];
    [flatmateDP getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        if(!error){
            UIImage *dp = [UIImage imageWithData:imageData];
            cell2.imageView.layer.cornerRadius = dp.size.width / 2;
            cell2.imageView.layer.masksToBounds = YES;
            cell2.imageView.image = dp;

            //return cell;
            
        }else{
            NSLog(@"%@",error);
            
        }
    }];
    
    return cell2;

}

-(void) fetchFlatmatesFromDB{
    [flatMates removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"Flat" equalTo:currentUser[@"Flat"]];
    [query orderByDescending:@"TasksCompleted"];
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
    [self alertSuccess];
}

-(IBAction)signOutFlat:(id)sender{
    [PFUser logOut];

    UIViewController *root =  [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([root isKindOfClass:[LoginViewController class]]) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        LoginViewController *login = [[LoginViewController alloc]init];
        [[UIApplication sharedApplication].keyWindow setRootViewController:login];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}


-(void)alertSuccess{
    
    
    
    PFUser *currentUser = [PFUser currentUser];
    PFObject *myFlat = currentUser[@"Flat"];

    NSString *inviteCode = myFlat.objectId;
    
    UIAlertController *sucess = [UIAlertController alertControllerWithTitle:inviteCode message:@"Share this code with your flatmates to invite them! (SCREENSHOT)" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [sucess addAction:ok];
    
    [self presentViewController:sucess animated:YES completion:nil];
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
