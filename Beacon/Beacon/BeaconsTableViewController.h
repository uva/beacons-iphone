//
//  BeaconsTableViewController.h
//  Beacon
//
//  Created by Rob Kunst on 07/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BeaconsTableViewController : UITableViewController <CLLocationManagerDelegate>

@property NSMutableArray *beacons;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
