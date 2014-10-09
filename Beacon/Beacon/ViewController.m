//
//  ViewController.m
//  Beacon
//
//  Created by Rob Kunst on 04/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    
    [self initRegion];
    
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
    
    self.userName = @"user1";
    [self loadState];
    
}

-(void)loadState{
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"username" equalTo:self.userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *user = [objects firstObject];
        if([user[@"needsHelp"] isEqual:[NSNumber numberWithBool:YES]]){
            [self.helpSwitch setOn:YES animated:YES];
        } else{
            [self.helpSwitch setOn:NO animated:NO];
        }
    }];
}


-(void)sendLocationToDatabase{
    CLBeacon *beacon = self.beacon;
//    if(!beacon){
//        NSLog(@"No beacon found");
//        return;
//    }
    
    int major = beacon.major.intValue;
    int minor = beacon.minor.intValue;
    NSString *proximity;
    if (beacon.proximity == CLProximityUnknown) {
        proximity = @"Unknown Proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
        proximity = @"Immediate";
    } else if (beacon.proximity == CLProximityNear) {
        proximity = @"Near";
    } else if (beacon.proximity == CLProximityFar) {
        proximity = @"Far";
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"username" equalTo:self.userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *user = [objects firstObject];
        user[@"major"] = [NSNumber numberWithInt:major];
        user[@"minor"] = [NSNumber numberWithInt:minor];
        [user saveInBackground];
    }];
//    
//    PFObject *userCheckIn = [PFObject objectWithClassName:@"Check_Ins"];
//    userCheckIn[@"major"] = [NSNumber numberWithInt:major];
//    userCheckIn[@"minor"] = [NSNumber numberWithInt:minor];
//    userCheckIn[@"user"] = @"user1";
//    
//    userCheckIn[@"proximity"] = proximity;
//    [userCheckIn saveInBackground];
    
    NSLog(@"Object should have been saved");
    
    return;
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)initRegion{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"EBEFD083-70A2-47C8-9837-E7B5634DF524"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"minprog"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}


- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.statusLabel.text = @"No";
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {

    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    self.beacon = beacon;
    
    self.statusLabel.text = @"Beacon found, Submit?";
    //NSLog(@"Beacon found");

    
//    self.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
//    self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
//    self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
//    self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
//    if (beacon.proximity == CLProximityUnknown) {
//        self.distanceLabel.text = @"Unknown Proximity";
//    } else if (beacon.proximity == CLProximityImmediate) {
//        self.distanceLabel.text = @"Immediate";
//    } else if (beacon.proximity == CLProximityNear) {
//        self.distanceLabel.text = @"Near";
//    } else if (beacon.proximity == CLProximityFar) {
//        self.distanceLabel.text = @"Far";
//    }
//    self.rssiLabel.text = [NSString stringWithFormat:@"%i", beacon.rssi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userSelected:(UISegmentedControl *)sender {
    switch(self.segmentedControl.selectedSegmentIndex){
        case 0:
            self.userName = @"user1";
            break;
        case 1:
            self.userName = @"user2";
            break;
        case 2:
            self.userName = @"user3";
            break;
    }
    [self loadState];
    //NSLog(self.userName);
}

- (IBAction)submitLocation:(UIButton *)sender {
    [self sendLocationToDatabase];
    NSLog(@"submitted location");
}

- (IBAction)helpSwitchChanged:(UISwitch *)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"username" equalTo:self.userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *user = [objects firstObject];
        if([sender isOn]){
            user[@"needsHelp"] = [NSNumber numberWithBool:YES];
        } else{
            user[@"needsHelp"] = [NSNumber numberWithBool:NO];
        }
        [user saveInBackground];
    }];
}
@end