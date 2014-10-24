//
//  LoginViewController.m
//  Beacon
//
//  Created by Rob Kunst on 15/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import "LoginViewController.h"
#import "ProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.connectionManager = [[ConnectionManager alloc] init];
    self.connectionManager.delegate = self;
    [self.pinTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)getTokenWithPin:(NSString *)pin{
    [ProgressHUD show:@"Please wait" Interaction:NO];
    [self.connectionManager requestTokenWithPin:pin];
}


#pragma mark - ConnectionManagerDelegate

-(void)didGetToken:(NSString *)token{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"token"];
    [defaults synchronize];
    
    [self performSegueWithIdentifier:@"startViewSegue" sender:self];
    
    //[self.connectionManager getRoleWithToken:token];
}

//-(void)didGetRole:(NSString *)role{
//    if([role isEqualToString:@"student"]){
//        [self performSegueWithIdentifier: @"studentSegue" sender: self];
//    } else if([role isEqualToString:@"assistant"]){
//        [self performSegueWithIdentifier:@"studentSegue" sender:self];
//    }
//}

- (IBAction)submitPin:(UIButton *)sender {
    [self.pinTextField endEditing:YES];
    NSString *pin = self.pinTextField.text;
    [self getTokenWithPin:pin];
}

- (void)didGetError{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showError:@"Invalid pairing code, Please try again"];
    });
}
@end
