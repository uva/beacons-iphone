//
//  BeaconsTableViewController.m
//  Beacon
//
//  Created by Rob Kunst on 07/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import "BeaconsTableViewController.h"

@interface BeaconsTableViewController ()

@end

@implementation BeaconsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager requestWhenInUseAuthorization];
    
    [self initRegion];
    
    [self locationManager:self.locationManager didStartMonitoringForRegion:self.beaconRegion];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.beacons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [self.beacons objectAtIndex:indexPath.row];
    
    NSString *majMin = [NSString stringWithFormat:@"Major: %@ Minor: %@", beacon.major, beacon.minor];
    NSString *uuid = beacon.proximityUUID.UUIDString;
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
        NSString *rssi = [NSString stringWithFormat:@"%li", (long)beacon.rssi];
    cell.textLabel.text = uuid;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@",majMin, proximity, rssi];
    
    //    self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    //    self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark Beacon methods

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
    //self.statusLabel.text = @"No";
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *beacon = [[CLBeacon alloc] init];
    beacon = [beacons lastObject];
    
    self.beacons = beacons;
    [self.tableView reloadData];
    
    //self.statusLabel.text = @"Yes";
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

@end
