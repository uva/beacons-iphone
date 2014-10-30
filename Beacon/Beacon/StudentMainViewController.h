//
//  StudentMainViewController.h
//  Beacon
//
//  Created by Rob Kunst on 15/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ConnectionManager.h"

@interface StudentMainViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) ConnectionManager *connectionManager;

@property NSString *token;
@property CLBeacon *beacon;
@property BOOL needsHelp;

@property (weak, nonatomic) IBOutlet UILabel *beaconLabel;

- (IBAction)UserNeedsHelp:(UIButton *)sender;

@end
