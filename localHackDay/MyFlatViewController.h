//
//  MyFlatViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 21/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFlatViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *flatImage;

@property (weak, nonatomic) IBOutlet UITableView *leaderboardTableview;
@property (nonatomic) NSMutableArray *flatMates;

@property (weak, nonatomic) IBOutlet UIButton *addFlatmateButton;

@property (weak, nonatomic) IBOutlet UIButton *signOutButton;


@end
