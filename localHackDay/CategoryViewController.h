//
//  CategoryViewController.h
//  localHackDay
//
//  Created by Johnson Cheung on 16/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property NSMutableArray *categories;

@end
