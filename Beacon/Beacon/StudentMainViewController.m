//
//  StudentMainViewController.m
//  Beacon
//
//  Created by Rob Kunst on 15/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import "StudentMainViewController.h"

@interface StudentMainViewController ()

@end

@implementation StudentMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Retrieve user token from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.token = [defaults valueForKey:@"token"];

    //Set title for navigation bar
    self.title = @"Start";
    
    //Setup the location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    
    //Declare the region and start monitoring
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF524"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"minprog"];
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    self.connectionManager = [[ConnectionManager alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)UserNeedsHelp:(UIButton *)sender {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    self.needsHelp = YES;
}

#pragma mark CLLocationDelegate methods
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    self.beaconLabel.text = @"Region entered";
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.beaconLabel.text = @"Region left";
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    //Retrieve data from the closest beacon.
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons firstObject];
    self.beacon = beacon;
    int minor = beacon.minor.intValue;
    int major = beacon.major.intValue;
    NSString *beaconLabelString = [NSString stringWithFormat:@"Location = %d-%d", major, minor];
    self.beaconLabel.text = beaconLabelString;
    [self.connectionManager submitLocationWithMajor:major andMinor:minor];
    
    //If the user has asked for help since the last update, update the help status as well.
    if(self.needsHelp){
        NSLog(@"Needs help");
        [self.connectionManager setNeedsHelp:self.needsHelp];
    }
    NSLog(@"Beacon found, %@", beaconLabelString);

    //When location is submitted, stop ranging.
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

@end
