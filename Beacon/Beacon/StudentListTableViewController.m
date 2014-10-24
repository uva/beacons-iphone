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
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.connectionManager = [[ConnectionManager alloc] init];
    self.connectionManager.delegate = self;
    self.studentList = [[NSArray alloc] init];
    
    [self loadData];
}

- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [self loadData];
}

-(void)loadData{
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
    NSLog(@"Data downloaded: %@", studentList);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.studentList = studentList;
        [self.tableView reloadData];
    });
}

@end
