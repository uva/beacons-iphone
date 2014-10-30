//
//  AssistantListTableViewController.m
//  Beacon
//
//  Created by Rob Kunst on 15/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import "AssistantListTableViewController.h"

@interface AssistantListTableViewController ()

@property NSArray *assistantList;

@end

@implementation AssistantListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set title for navigation bar
    self.title = @"Assistants";
    
    //Add refresh control to tableView to reload data with a pulldown.
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //Setup the connection manager
    self.connectionManager = [[ConnectionManager alloc] init];
    self.connectionManager.delegate = self;
    self.assistantList = [[NSArray alloc] init];
    [self.connectionManager getAssistantList];
}

//Reload data when refreshControl is dragged down.
- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [self.connectionManager getAssistantList];
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
    return self.assistantList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    //Retrieve data from the user and setup the tableview cell.
    NSDictionary *user = [self.assistantList objectAtIndex:indexPath.row];
    NSString *name = [user valueForKey:@"name"];
    NSString *minor = [user valueForKey:@"loca"];
    NSString *major = [user valueForKey:@"locb"];
    
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Locatie: %@, %@", minor, major];
    
    NSLog(@"Item: %@", [self.assistantList objectAtIndex:indexPath.row]);
    return cell;
}

#pragma mark - ConnectionManager delegate methods

//Update tableView when data is loaded
-(void)didGetAssistantList:(NSArray *)assistantList{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.assistantList = assistantList;
        [self.tableView reloadData];
    });
}

@end
