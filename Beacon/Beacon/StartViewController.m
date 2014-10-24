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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.token = [defaults valueForKey:@"token"];
    self.connectionManager = [[ConnectionManager alloc] init];
    self.connectionManager.delegate = self;
    [self.connectionManager getRoleWithToken:self.token];
}

-(void)didGetRole:(NSString *)role{
    if([role isEqualToString:@"student"]){
        NSLog(@"Student");
        [self performSegueWithIdentifier:@"studentSegue" sender:self];
    } else if([role isEqualToString:@"assistant"]){
        [self performSegueWithIdentifier:@"studentSegue" sender:self];
    } else{
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
}

-(void)didGetError{
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}


@end
