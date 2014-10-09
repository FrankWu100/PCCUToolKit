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
#import <AFNetworking/AFNetworking.h>

@implementation PCCUOAuthUserData

- (void)getUserData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //parameterEncoding to AFJSONParameterEncoding
    NSString *url = [[NSString alloc] initWithFormat:@"https://mobi.pccu.edu.tw/DataAPI/userdata/%@/%@/basic",
                     [PCCUOAuthLogin getClientID],
                     [PCCUOAuthLogin getAccessToken]];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             //             NSLog(@"JSON: %@", responseObject);
             
             NSLog(@"JSON: %@", [[FWJSONPrint alloc] describeDictionary:responseObject]);
             
             //             NSError *error;
             //             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject
             //                                                                options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
             //                                                                  error:&error];
             //
             //             if (! jsonData) {
             //                 NSLog(@"Got an error: %@", error);
             //             } else {
             //                 NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             //
             //                 NSLog(@"JSON: %@", jsonString);
             //             }

             BOOL haveError = NO;
             if ([responseObject isKindOfClass: [NSDictionary class]]) {
                 if ([responseObject objectForKey:@"Error"]) {
                     haveError = YES;
                     NSLog(@"Error : %@", [responseObject objectForKey:@"Error"]);
                 }
             }
             
             if (!haveError) {
                 NSLog(@"UserData count: %lu", (unsigned long)[responseObject count] );
                 if ([responseObject count] == 1) {
                     NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
                     
                     //                 [defs setObject:[[responseObject[0] objectForKey:@"UserAccount"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"UserAccount"];
                     //                 [defs setObject:[[responseObject[0] objectForKey:@"UserDept"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"UserDept"];
                     //                 [defs setObject:[[responseObject[0] objectForKey:@"UserName"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"UserName"];
                     
                     NSString *UserAccountStr = [[responseObject[0] objectForKey:@"UserAccount"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                     NSString *UserDeptStr = [[responseObject[0] objectForKey:@"UserDept"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                     NSString *UserNameStr = [[responseObject[0] objectForKey:@"UserName"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                     
                     [defs setObject:UserAccountStr forKey:@"UserAccount"];
                     [defs setObject:UserDeptStr forKey:@"UserDept"];
                     [defs setObject:UserNameStr forKey:@"UserName"];
                     
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 else {
                     //
                 }
             }

//             for(NSDictionary* dict in [self.jsonData allObjects])
//             {
//
//             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
//             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error"
//                                                                 message:[[NSString alloc] initWithFormat:@"%@", error]
//                                                                delegate:nil
//                                                       cancelButtonTitle:@"OK"
//                                                       otherButtonTitles:nil, nil];
             
             if (![self haveUserData]) {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"錯誤"
                                                                     message:[NSString stringWithFormat:@"%d %@", [error code], [[error userInfo] valueForKey:@"NSLocalizedDescription"]]
                                                                    delegate:self
                                                           cancelButtonTitle:@"確定"
                                                           otherButtonTitles:nil];
                 [alertView show];
             }
         }];
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

- (void)checkUserData
{
//    if (![self haveUserData]) {
        [self getUserData];
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
        abort();
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
        abort();
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
        abort();
    }
    return userName;
}

@end
