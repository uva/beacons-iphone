//
//  BeaconsTableViewController.m
//  Beacon
//
//  Created by Rob Kunst on 05/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import "BeaconsTableViewController.h"
#import "Beacon.h"
#import <Parse/Parse.h>

@interface BeaconsTableViewController ()

@end

@implementation BeaconsTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.beacons = [[NSMutableArray alloc] init];

    Beacon *beacon1 = [[Beacon alloc] init];
    Beacon *beacon2 = [[Beacon alloc] init];
    Beacon *beacon3 = [[Beacon alloc] init];
    
    beacon1.uuid = @"testuuidbeacon1";
    beacon2.uuid = @"testuuidbeacon2";
    beacon3.uuid = @"testuuidbeacon3";
    
    beacon1.beaconDescription = @"This is beacon 1";
    beacon2.beaconDescription = @"This is beacon 2";
    beacon3.beaconDescription = @"This is beacon 3";
    
    
    [self.beacons addObject:beacon1];
    [self.beacons addObject:beacon2];
    [self.beacons addObject:beacon3];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Beacons"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"%@",objects);
        for(PFObject *object in objects){
            Beacon *beacon = [[Beacon alloc] init];
            beacon.beaconDescription = object[@"description"];
            beacon.uuid = object[@"uuid"];
            [self.beacons addObject:beacon];
        }
        [self.tableView reloadData];

    }];
    
    
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
    Beacon *beacon = [self.beacons objectAtIndex:indexPath.row];
    cell.textLabel.text = beacon.beaconDescription;
    cell.detailTextLabel.text = beacon.uuid;
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

@end
