//
//  StudentListTableViewController.m
//  Beacon
//
//  Created by Rob Kunst on 15/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import "StudentListTableViewController.h"

@interface StudentListTableViewController ()

@property NSArray *studentList;

@end

@implementation StudentListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set title for navigation bar
    self.title = @"Students";
    
    //Add refresh control to tableView to reload data with a pulldown.
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //Setup the connection manager
    self.connectionManager = [[ConnectionManager alloc] init];
    self.connectionManager.delegate = self;
    self.studentList = [[NSArray alloc] init];
    
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
    
    [self.connectionManager getStudentList];
}

//TODO - Overleg met martijn of dit gewenst is.
-(void)viewWillAppear:(BOOL)animated{
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}


//Reload data when refreshControl is dragged down.
- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [self.connectionManager getStudentList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.studentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    //Retrieve data from the user and setup the tableview cell.
    NSDictionary *user = [self.studentList objectAtIndex:indexPath.row];
    NSString *name = [user valueForKey:@"name"];
    int help = [[user valueForKey:@"help"] integerValue];
    NSString *helpString;
    if(help == 0){
        helpString = @"";
    } else{
        helpString = @"Needs help!";
    }
    NSString *minor = [user valueForKey:@"loca"];
    NSString *major = [user valueForKey:@"locb"];
    
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Locatie: %@, %@, %@", minor, major, helpString];
    
    return cell;
}

#pragma mark - ConnectionManager delegate methods

-(void)didGetStudentList:(NSArray *)studentList{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.studentList = studentList;
        [self.tableView reloadData];
    });
}

#pragma mark CLLocationDelegate methods

//Start ranging if the user enters the beacon's region
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

//Stop ranging when the user leaves (power efficient).
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

//Send closest beacon data to server.
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    CLBeacon *beacon = [[CLBeacon alloc] init];
    
    beacon = [beacons firstObject];
    int minor = beacon.minor.intValue;
    int major = beacon.major.intValue;
    
    NSLog(@"Location = %d-%d", major, minor);
    
    //When location is submitted, stop ranging.
    [self.connectionManager submitLocationWithMajor:major andMinor:minor];
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}


@end
