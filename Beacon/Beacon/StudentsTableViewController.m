//
//  StudentsTableViewController.m
//  Beacon
//
//  Created by Rob Kunst on 08/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import "StudentsTableViewController.h"
#import "UserLocationTableViewCell.h"
#import <Parse/Parse.h>

@implementation StudentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.users = [[NSArray alloc] init];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    [self loadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)refreshTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    [self loadData];
}

-(void)loadData{
    //Request the user-checkins from the database
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.users = objects;
        [self.tableView reloadData];
    }];
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
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    PFObject *object = [self.users objectAtIndex:indexPath.row];
    cell.textLabel.text = object[@"username"];
    NSNumber *minor = object[@"minor"];
    NSDate *updated = [object updatedAt];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMM d, h:mm a"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Locatie: %@, %@",object[@"minor"], [dateFormat stringFromDate:updated]];
    if([object[@"needsHelp"] isEqual:[NSNumber numberWithBool:YES]]){
        [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
    } else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    //cell.imageView.image = [UIImage imageNamed:@"Question.png"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadData];
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [query whereKey:@"username" equalTo:cell.textLabel.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        PFObject *user = [objects firstObject];
        user[@"needsHelp"] = @NO;
        [user saveInBackground];
        [self loadData];
    }];
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
