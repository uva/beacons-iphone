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

- (IBAction)submitPin:(UIButton *)sender {
    [self.pinTextField endEditing:YES];
    [ProgressHUD show:@"Please wait" Interaction:NO];
    NSString *pin = self.pinTextField.text;
    [self.connectionManager requestTokenWithPin:pin];
}

#pragma mark - ConnectionManagerDelegate

//If token is recieved, save token to userDefaults and go to the starting view controller.
-(void)didGetToken:(NSString *)token{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"token"];
    [defaults synchronize];
    
    [self performSegueWithIdentifier:@"startViewSegue" sender:self];
}

- (void)didGetError{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showError:@"Invalid pairing code, Please try again"];
    });
}
@end
