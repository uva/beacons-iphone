//
//  StartViewController.h
//  Beacon
//
//  Created by Rob Kunst on 14/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@interface StartViewController : UIViewController <ConnectionManagerDelegate>

@property ConnectionManager *connectionManager;

@property NSString *token;
@property NSString *beaconID;

@end
