//
//  LoginViewController.h
//  Beacon
//
//  Created by Rob Kunst on 15/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@interface LoginViewController : UIViewController <ConnectionManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pinTextField;
@property ConnectionManager *connectionManager;

- (IBAction)submitPin:(UIButton *)sender;


@end
