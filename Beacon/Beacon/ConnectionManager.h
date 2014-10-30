//
//  ConnectionManager.h
//  Beacon
//
//  Created by Rob Kunst on 15/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionManagerDelegate <NSObject>
@optional
- (void)didGetToken:(NSString*)token;
- (void)didGetRole:(NSString *)role;
- (void)didGetStudentList:(NSArray *)studentList;
- (void)didGetAssistantList:(NSArray *)assistantList;
- (void)didGetError;

@end

@interface ConnectionManager : NSObject  <NSURLSessionDataDelegate, NSURLSessionDelegate>

@property (weak, nonatomic) id <ConnectionManagerDelegate> delegate;
@property (strong, nonatomic) NSString *token;

-(void)submitLocationWithMajor:(int)major andMinor:(int)minor;
-(void)getRoleWithToken:(NSString *)token;
-(void)requestTokenWithPin:(NSString*)pin;
-(void)getAssistantList;
-(void)getStudentList;
-(void)submitGone;
-(void)setNeedsHelp:(BOOL)help;

@end
