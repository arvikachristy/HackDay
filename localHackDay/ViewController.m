//
//  ViewController.m
//  localHackDay
//
//  Created by Apple on 10/10/2015.
//  Copyright (c) 2015 team. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize passcodeBox;
@synthesize loginButton;
@synthesize registerButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    passcodeBox.secureTextEntry = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    NSLog(passcodeBox.text);
}

- (IBAction)registerAction:(id)sender {
    NSLog(@"Register button clicked");
}

@end
