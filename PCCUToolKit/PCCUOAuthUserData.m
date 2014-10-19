//
//  PCCUOAuthUserData.m
//  ClassComment
//
//  Created by FrankWu on 2014/2/20.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import "PCCUOAuthUserData.h"
#import "PCCUOAuthLogin.h"
#import "FWToolKit/FWJSONPrint.h"
//#import <AFNetworking/AFNetworking.h>
//#import <SVProgressHUD/SVProgressHUD.h>

@implementation PCCUOAuthUserData

- (BOOL)getUserData
{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
//    [MBProgressHUD showHUDAddedTo:rootViewController.view animated:YES];
    
//    [SVProgressHUD showWithStatus:@"Doing Stuff"];
    //parameterEncoding to AFJSONParameterEncoding
    NSString *url = [[NSString alloc] initWithFormat:@"https://mobi.pccu.edu.tw/DataAPI/userdata/%@/%@/basic",
                     [PCCUOAuthLogin getClientID],
                     [PCCUOAuthLogin getAccessToken]];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        
        if (![self haveUserData]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"錯誤"
                                                                message:[NSString stringWithFormat:@"%d %@", (int)[error code], [[error userInfo] valueForKey:@"NSLocalizedDescription"]]
                                                               delegate:self
                                                      cancelButtonTitle:@"確定"
                                                      otherButtonTitles:nil];
            [alertView show];
            return NO;
        }
        else
        {
//            [MBProgressHUD showHUDAddedTo:rootViewController.view animated:YES];
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.50 * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                // Do something...
//                [MBProgressHUD hideHUDForView:rootViewController.view animated:YES];
//            });
            return YES;
        }
    }
    
    // Construct a String around the Data from the response
    NSString *myData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON data = %@", myData);
    
    //parsing the JSON response
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:urlData
                     options:NSJSONReadingAllowFragments
                     error:&jsonError];
    
    NSLog(@"%@", [[FWJSONPrint alloc] describeDictionary:jsonObject]);
    
    BOOL haveError = NO;
    if ([jsonObject isKindOfClass: [NSDictionary class]]) {
        if ([jsonObject objectForKey:@"Error"]) {
            haveError = YES;
            NSLog(@"Error : %@", [jsonObject objectForKey:@"Error"]);
            
            return NO;
        }
    }
    
    if (!haveError) {
        NSLog(@"UserData count: %lu", (unsigned long)[jsonObject count] );
        if ([jsonObject count] == 1) {
            NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
            
            NSString *UserAccountStr = [[jsonObject[0] objectForKey:@"UserAccount"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *UserDeptStr = [[jsonObject[0] objectForKey:@"UserDept"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *UserNameStr = [[jsonObject[0] objectForKey:@"UserName"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [defs setObject:UserAccountStr forKey:@"UserAccount"];
            [defs setObject:UserDeptStr forKey:@"UserDept"];
            [defs setObject:UserNameStr forKey:@"UserName"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
//            [MBProgressHUD showHUDAddedTo:rootViewController.view animated:YES];
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.50 * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                // Do something...
//                [MBProgressHUD hideHUDForView:rootViewController.view animated:YES];
//            });
            return YES;
        }
        else {
            
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

- (BOOL)haveUserData
{
    if ([self haveUserAccount] && [self haveUserDept] && [self haveUserName]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)checkUserData
{
//    if (![self haveUserData]) {
        if ([self getUserData])
        {
            NSLog(@"getUserData ok");
            return YES;
        }
        else
        {
            return NO;
        }
//    }
    
}

- (NSString *)haveUserAccount
{
    NSString* userAccount = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserAccount"];
    return userAccount;
}

+ (NSString *)getUserAccount
{
    return [[self alloc] getUserAccount];
}

- (NSString *)getUserAccount
{
    NSString* userAccount = [self haveUserAccount];
//    NSLog(@"UserAccount: %@", userAccount);
    if (userAccount == nil)
    {
        NSLog(@"UserAccount not set.");
//        abort();
    }
    return userAccount;
}

+ (NSString *)getUserDept
{
    return [[self alloc] getUserDept];
}

- (NSString *)haveUserDept
{
    NSString* userDept = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserDept"];
    return userDept;
}


+ (NSString *)getUserName
{
    return [[self alloc] getUserName];
}

- (NSString *)getUserDept
{
    NSString* userDept = [self haveUserDept];
//    NSLog(@"UserDept: %@", userDept);
    if (userDept == nil)
    {
        NSLog(@"UserDept not set.");
//        abort();
    }
    return userDept;
}

- (NSString *)haveUserName
{
    NSString* userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    return userName;
}

- (NSString *)getUserName
{
    NSString* userName = [self haveUserName];
//    NSLog(@"UserName: %@", userName);
    if (userName == nil)
    {
        NSLog(@"UserName not set.");
//        abort();
    }
    return userName;
}

@end
