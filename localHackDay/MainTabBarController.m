//
//  MainTabBarController.m
//  localHackDay
//
//  Created by Johnson Cheung on 17/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "MainTabBarController.h"
#import "CategoryViewController.h"
#import "AvailableTasksViewController.h"
#import "MyFlatViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];

    UIColor *myMintGreen = [UIColor colorWithRed:0.39 green:1.00 blue:0.47 alpha:1.0];
    UIColor *myGrey = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    
    [[UITabBar appearance] setTintColor:myMintGreen];
    [[UITabBar appearance] setBarTintColor:myGrey];
    [[UITabBar appearance] setBackgroundColor:myGrey];
    
     // Do any additional setup after loading the view from its nib.
    //self.tabBarController.viewControllers = [[NSArray alloc]initWithObjects:categories, avaliableTasks, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(instancetype)init{
    self = [super init];
    
    CategoryViewController *categories = [[CategoryViewController alloc]init];
    UINavigationController *categoriesNav = [[UINavigationController alloc]initWithRootViewController:categories];
    AvailableTasksViewController *availableTasks = [[AvailableTasksViewController alloc]init];
    UINavigationController *availableTasksNav = [[UINavigationController alloc]initWithRootViewController:availableTasks];
    MyFlatViewController *myFlat = [[MyFlatViewController alloc]init];
    UINavigationController *myFlatNav = [[UINavigationController alloc]initWithRootViewController:myFlat];
   
    
   /*
    UIColor *myMintGreen = [UIColor colorWithRed:0.46 green:0.98 blue:0.56 alpha:1.0];
    UIColor *myGrey = [UIColor colorWithRed:0.26 green:0.25 blue:0.25 alpha:1.0];
    
    categoriesNav.navigationBar.barTintColor = myGrey;
    categoriesNav.navigationBar.tintColor = myMintGreen;
    [categoriesNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: myMintGreen}];
    availableTasksNav.navigationBar.barTintColor = myGrey;
    availableTasksNav.navigationBar.tintColor = myMintGreen;
    */
    
    [self setNavigationStyle:categoriesNav];
    [self setNavigationStyle:availableTasksNav];
    [self setNavigationStyle:myFlatNav];
    
    categoriesNav.tabBarItem.title = @"Categories";
    availableTasksNav.tabBarItem.title = @"Available Tasks";
    myFlatNav.tabBarItem.title = @"Settings";
    
   // categories.tabBarItem.image = ;
    //availableTasks.tabBarItem.image = ;

    self.viewControllers = [[NSArray alloc]initWithObjects:availableTasksNav, categoriesNav, myFlatNav, nil];
    
    
    return self;
}

-(void)setNavigationStyle:(UINavigationController*)navController{
    UIColor *myMintGreen = [UIColor colorWithRed:0.39 green:1.00 blue:0.47 alpha:1.0];
    UIColor *myGrey = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    navController.navigationBar.backgroundColor = myGrey;
    navController.navigationBar.barTintColor = myGrey;
    navController.navigationBar.tintColor = myMintGreen;
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: myMintGreen}];
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
