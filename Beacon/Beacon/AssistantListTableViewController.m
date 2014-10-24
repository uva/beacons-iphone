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
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.connectionManager = [[ConnectionManager alloc] init];
    self.connectionManager.delegate = self;
    self.assistantList = [[NSArray alloc] init];
    [self loadData];
}

- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [self loadData];
}

-(void)loadData{
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

-(void)didGetAssistantList:(NSArray *)assistantList{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.assistantList = assistantList;
        [self.tableView reloadData];
    });
}

@end
