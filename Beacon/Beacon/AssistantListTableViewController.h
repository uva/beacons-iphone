//
//  AssistantListTableViewController.h
//  Beacon
//
//  Created by Rob Kunst on 15/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@interface AssistantListTableViewController : UITableViewController <ConnectionManagerDelegate>

@property ConnectionManager *connectionManager;
@property NSString *token;
@property UIRefreshControl *refreshControl;


@end
