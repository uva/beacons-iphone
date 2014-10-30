//
//  StudentListTableViewController.h
//  Beacon
//
//  Created by Rob Kunst on 15/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ConnectionManager.h"

@interface StudentListTableViewController : UITableViewController <ConnectionManagerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property ConnectionManager *connectionManager;

@property NSString *token;
@property CLBeacon *beacon;

@end
