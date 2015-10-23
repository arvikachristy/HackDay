//
//  loggedFlatmate.h
//  localHackDay
//
//  Created by Johnson Cheung on 23/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface loggedFlatmate : NSObject{
    PFObject *flatmate;
    NSString *test;
}

@property (nonatomic, retain) PFObject *flatmate;
@property (nonatomic, retain) NSString *test;

+(id)sharedLoggedFlatmate;

@end
