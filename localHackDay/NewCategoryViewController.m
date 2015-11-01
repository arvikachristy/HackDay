//
//  NewCategoryViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 13/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "NewCategoryViewController.h"
#import "CategoryViewController.h"
#import <Parse/parse.h>

@interface NewCategoryViewController ()


@end

@implementation NewCategoryViewController

@synthesize errorLabel;
@synthesize createCategoryTitle;
@synthesize submitNewCategory;
@synthesize activeField;


-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    errorLabel.text = @"";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"New Category";
    
    createCategoryTitle.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeRight];
    
    UITapGestureRecognizer *tapDismissKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKB)];
    tapDismissKB.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapDismissKB];
    
    
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addSubmitNewCategory:(id)sender{
    NSString *trimmedTitle = [createCategoryTitle.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(trimmedTitle.length < 1){
        errorLabel.text = @"category title can't be blank";
        return;
    }
    
    PFObject *category = [PFObject objectWithClassName:@"Category"];
    category[@"CategoryTitle"] = trimmedTitle;
    PFUser *currentUser = [PFUser currentUser];
    category[@"Owner"] = currentUser[@"Flat"];
    [category saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            if (succeeded==YES) {
                [self goBack];
            }
        }else{
            NSLog(@"%@",error);
        }
        
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self dismissKB];
}

-(void)dismissKB{
    [activeField resignFirstResponder];
    activeField = nil;
}

-(void)goBack{
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
