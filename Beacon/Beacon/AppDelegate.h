//
//  AppDelegate.h
//  Beacon
//
//  Created by Rob Kunst on 04/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ConnectionManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

