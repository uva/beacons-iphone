//
//  StartViewController.m
//  Beacon
//
//  Created by Rob Kunst on 14/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import "StartViewController.h"
#import "ConnectionManager.h"

@implementation StartViewController

- (IBAction) restart:(UIStoryboardSegue *)segue
{
    [self retrieveRole];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self retrieveRole];
}

- (void) retrieveRole
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.token = [defaults valueForKey:@"token"];
    self.connectionManager = [[ConnectionManager alloc] init];
    self.connectionManager.delegate = self;
    [self.connectionManager getRoleWithToken:self.token];
}

- (void) didGetRole:(NSString *)role
{
    if([role isEqualToString:@"student"]){
        NSLog(@"Student");
        [self performSegueWithIdentifier:@"menuSegue" sender:self];
    } else if([role isEqualToString:@"assistant"]){
        NSLog(@"Assistant");
        [self performSegueWithIdentifier:@"menuSegue" sender:self];
    } else{
        NSLog(@"Login");
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}

- (void) didGetError
{
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

@end
