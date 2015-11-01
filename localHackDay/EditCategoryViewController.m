//
//  EditCategoryViewController.m
//  localHackDay
//
//  Created by Johnson Cheung on 27/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "EditCategoryViewController.h"

@interface EditCategoryViewController ()

@end

@implementation EditCategoryViewController

@synthesize errorLabel;
@synthesize editCategoryTitle;
@synthesize activeField;


-(void)viewWillAppear:(BOOL)animated{
    animated = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.navigationItem.title = @"Edit Category";
    
    editCategoryTitle.text = editingCategory[@"CategoryTitle"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    errorLabel.text = @"";
    editCategoryTitle.delegate = self;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipeRight];
    
    UITapGestureRecognizer *tapDismissKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKB)];
    [self.view addGestureRecognizer:tapDismissKB];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self dismissKB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addSubmitEditedCategoryButton:(id)sender{
    editingCategory[@"CategoryTitle"] = editCategoryTitle.text;
    [editingCategory saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            if (succeeded == YES) {
                [self goBack];
            }
            else{
                return;
            }
        }else{
            NSLog(@"%@",error);
        }
    }];
}

-(IBAction)addDeleteTaskButton:(id)sender{
    
    [self alertDelete];
}

-(void)dismissKB{
    [activeField resignFirstResponder];
    activeField = nil;
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goBackTwice{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(id)initWithCategory:(PFObject*)category{
    self = [super init];
    editingCategory = category;
    return self;
}


-(void)alertDelete{
    
    UIAlertController *delete = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *confirmDelete = [UIAlertAction actionWithTitle:@"Delete Category" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action)
                                    {
                                        //Do some thing here
                                        [editingCategory deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                            if(!error){
                                                [self goBackTwice];
                                            }else{
                                                NSLog(@"%@",error);
                                            }
                                        }];
                                    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [delete addAction:confirmDelete];
    [delete addAction:cancel];
    
    [self presentViewController:delete animated:YES completion:nil];
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
