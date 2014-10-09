//
//  ViewController.h
//  Beacon
//
//  Created by Rob Kunst on 04/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>


@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property CLBeacon *beacon;
@property NSString *userName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *helpSwitch;

- (IBAction)userSelected:(UISegmentedControl *)sender;

- (IBAction)submitLocation:(UIButton *)sender;

- (IBAction)helpSwitchChanged:(UISwitch *)sender;
@end

