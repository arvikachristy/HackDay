//
//  loggedFlatmate.m
//  localHackDay
//
//  Created by Johnson Cheung on 23/10/2015.
//  Copyright © 2015 team. All rights reserved.
//

#import "loggedFlatmate.h"

@implementation loggedFlatmate
@synthesize flatmate;
@synthesize test;


+ (id)sharedLoggedFlatmate {
    static loggedFlatmate *sharedLoggedFlatmate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLoggedFlatmate = [[self alloc] init];
    });
    return sharedLoggedFlatmate;
}

- (id)init {
    if (self = [super init]) {
        flatmate = nil;
        test = @"hi";
    }
    return self;
}

-(void)setTest:(NSString *)testTemp{
    test = testTemp;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}


@end
