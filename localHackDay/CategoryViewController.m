//
//  CategoryViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 16/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "CategoryViewController.h"
#import "NewCategoryViewController.h"
#import "SelectedCategoryViewController.h"
#import "AvailableTasksViewController.h"
#import  <Parse/parse.h>

@interface CategoryViewController ()

@end

@implementation CategoryViewController

@synthesize categoriesTableView;
@synthesize categories;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    categories = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    self.navigationItem.title = @"Categories";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(addCategories)];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self fetchCategoriesFromDB];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCategories{
    [self showViewController:[NewCategoryViewController alloc]  sender:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [categories count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    if ([categories count] < 1) {
        return cell;
    }
    PFObject *object = [categories objectAtIndex:indexPath.row];
    
    cell.textLabel.text = object[@"CategoryTitle"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *selectedCategory = [categories objectAtIndex:indexPath.row];
    [self showViewController:[[SelectedCategoryViewController alloc]initWithCategory:selectedCategory] sender:nil];
}


-(void) fetchCategoriesFromDB{
    [categories removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    PFUser *currentUser = [PFUser currentUser];
    [query whereKey:@"Owner" equalTo:currentUser[@"Flat"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            for (PFObject *object in objects) {
                [categories addObject:object];
            }
           dispatch_async(dispatch_get_main_queue(), ^ {
                [categoriesTableView reloadData];
           });
        }else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
