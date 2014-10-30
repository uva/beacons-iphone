//
//  ConnectionManager.m
//  Beacon
//
//  Created by Rob Kunst on 15/10/14.
//  Copyright (c) 2014 Rob Kunst. All rights reserved.
//

#import "StartViewController.h"
#import "ConnectionManager.h"
#import "UserListDelegate.h"

@implementation ConnectionManager

-(id)init{
    self = [super init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.token = [defaults valueForKey:@"token"];
    
    return self;
}

-(NSMutableURLRequest *)createRequestWithBaseURL:(NSString *)baseURL andExtension:(NSString *)extension{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, extension];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    return request;
}

-(NSURLSession *)createURLSession{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    return session;
}

-(void)requestTokenWithPin:(NSString *)pin{
    NSMutableURLRequest *request = [self createRequestWithBaseURL:@"http://prog2.mprog.nl/tracking/register/" andExtension:@""];
    NSURLSession *session = [self createURLSession];
    
    NSString *pincode = [NSString stringWithFormat:@"code=%@",pin];
    request.HTTPBody = [pincode dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *token = [dictionary valueForKey:@"token"];
        NSLog(@"Token = %@", token);
        if(token){
            [self.delegate didGetToken:token];
        } else{
            NSLog(@"No token");
            [self.delegate didGetError];
        }
    }];
    [postDataTask resume];
    
}

-(void)getRoleWithToken:(NSString *)token{
    NSMutableURLRequest *request = [self createRequestWithBaseURL:@"http://prog2.mprog.nl/tracking/tokenized/identify/" andExtension:token];
    NSURLSession *session = [self createURLSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *userRole = [dictionary valueForKey:@"role"];
        if(userRole){
            [self.delegate didGetRole:userRole];
        } else{
            [self.delegate didGetError];
        }
    }];
    [postDataTask resume];
}

-(void)submitLocationWithMajor:(int)major andMinor:(int)minor{
    NSMutableURLRequest *request = [self createRequestWithBaseURL:@"http://prog2.mprog.nl/tracking/tokenized/ping/" andExtension:self.token];
    NSURLSession *session = [self createURLSession];
    NSString *postString = [NSString stringWithFormat:@"loca=%d&locb=%d",major, minor];
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Location submitted");
    }];
    [postDataTask resume];
    
}

-(void)getStudentList{
    NSMutableURLRequest *request = [self createRequestWithBaseURL:@"http://prog2.mprog.nl/tracking/tokenized/list_students/" andExtension:self.token];
    NSURLSession *session = [self createURLSession];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *userList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [self.delegate didGetStudentList:userList];
    }];
    [postDataTask resume];
}


-(void)getAssistantList{
    NSMutableURLRequest *request = [self createRequestWithBaseURL:@"http://prog2.mprog.nl/tracking/tokenized/list_assistants/" andExtension:self.token];
    NSURLSession *session = [self createURLSession];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *userList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [self.delegate didGetAssistantList:userList];
    }];
    [postDataTask resume];
}

-(void)setNeedsHelp:(BOOL)help{
    NSMutableURLRequest *request = [self createRequestWithBaseURL:@"http://prog2.mprog.nl/tracking/tokenized/help/" andExtension:self.token];
    NSURLSession *session = [self createURLSession];
    
    NSString *postString = [NSString stringWithFormat:@"help=%hhd", help];
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"data = %@", data);
    }];
    [postDataTask resume];
}

-(void)submitGone{
    NSMutableURLRequest *request = [self createRequestWithBaseURL:@"http://prog2.mprog.nl/tracking/tokenized/gone/" andExtension:self.token];
    NSURLSession *session = [self createURLSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
    [postDataTask resume];
    
}

@end