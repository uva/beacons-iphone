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

-(id)initWithToken:(NSString *)token{
    self = [super init];
    
    //self.token = token;
    
    return self;
}

-(void)requestTokenWithPin:(NSString *)pin{
    NSURL *url = [NSURL URLWithString:@"http://prog2.mprog.nl/tracking/register/"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *pincode = [NSString stringWithFormat:@"code=%@",pin];
    request.HTTPBody = [pincode dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
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
    
    NSString *urlString = [NSString stringWithFormat:@"http://prog2.mprog.nl/tracking/tokenized/identify/%@",token];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://prog2.mprog.nl/tracking/tokenized/ping/%@", token];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *postString = [NSString stringWithFormat:@"loca=%d&locb=%d",major, minor];
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //Handle response
    }];
    [postDataTask resume];
    
}

-(void)getStudentList{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://prog2.mprog.nl/tracking/tokenized/list_students/%@", token];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSArray *userList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [self.delegate didGetStudentList:userList];
        //[self.delegate didGetAssistantList:dictionary];
        //NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }];
    [postDataTask resume];
}


-(void)getAssistantList{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://prog2.mprog.nl/tracking/tokenized/list_assistants/%@", token];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSArray *userList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        [self.delegate didGetAssistantList:userList];
        //[self.delegate didGetAssistantList:dictionary];
        //NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }];
    [postDataTask resume];
}

-(void)setNeedsHelp:(BOOL)help{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://prog2.mprog.nl/tracking/tokenized/help/%@", token];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *postString = [NSString stringWithFormat:@"help=%hhd", help];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"data = %@", data);
    }];
    [postDataTask resume];
}

-(void)submitGone{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults valueForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:@"http://prog2.mprog.nl/tracking/tokenized/gone/%@", token];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
    [postDataTask resume];
    
}

@end