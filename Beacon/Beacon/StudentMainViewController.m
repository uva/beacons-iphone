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
    
    self.connectionManager = [[ConnectionManager alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.token = [defaults valueForKey:@"token"];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF524"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"minprog"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//Send major and minor value of closest beacon to server.
- (IBAction)submitLocation:(UIButton *)sender {
    CLBeacon *beacon = self.beacon;
    int major = beacon.major.intValue;
    int minor = beacon.minor.intValue;
    [self.connectionManager submitLocationWithMajor:major andMinor:minor];
}

- (IBAction)helpSwitchChanged:(UISwitch *)sender {
    [self.connectionManager setNeedsHelp:sender.isOn];
}

#pragma mark CLLocationDelegate methods
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.beaconLabel.text = @"Region left";
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    self.beacon = beacon;
    self.beaconLabel.text = @"Beacon found, Submit?";
}

@end
