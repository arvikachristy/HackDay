//
//  AppDelegate.m
//  localHackDay
//
//  Created by Apple on 10/10/2015.
//  Copyright (c) 2015 team. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "MainTabBarController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize savedUser;

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    // Override point for customization after application launch.
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    
    [Parse setApplicationId:@"ln1VewIXReIBZQPkqihuUeHkLmCOa2RdOzgin31r"
                  clientKey:@"MYnq3yc5BiY5LToZj1FXPjQWbubDid9zyRr5UJNe"];
    [self tryAutoLogin];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    
    [self tryAutoLogin];
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   
    
}


-(void)tryAutoLogin{
    
    if([PFUser currentUser]){
      
        MainTabBarController *home = [[MainTabBarController alloc]init];
        self.window.rootViewController = home;
        [self.window makeKeyAndVisible];
    }else{
        LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = loginView;
        [self.window makeKeyAndVisible];
    };
    /*
    NSLog(@"%@",[PFUser currentUser].objectId);
    LoginViewController *loginView = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = loginView;
    [self.window makeKeyAndVisible];
    */
}

@end
