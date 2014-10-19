//
//  PCCUOAuthLogin.m
//  ClassComment
//
//  Created by FrankWu on 2014/2/18.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//
//  v2.0

#import "PCCUOAuthLogin.h"
//#import "ClassListViewController.h"

@implementation PCCUOAuthLogin

- (void)login {
    [self logout];
    [self goOAuth2];
    
}

- (void)logout {    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:nil forKey:@"PCCUAccessToken"];
    [defs setObject:nil forKey:@"FirstGetClassList"];
    [defs setObject:nil forKey:@"UserAccount"];
    [defs setObject:nil forKey:@"UserDept"];
    [defs setObject:nil forKey:@"UserName"];
    
//    [ClassListViewController cleanAllEntities];
    
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    if ([filemgr removeItemAtPath: [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"] error: NULL]  == YES)
        NSLog (@"Remove successful");
    else
        NSLog (@"Remove failed");
    [filemgr createDirectoryAtPath: [NSHomeDirectory() stringByAppendingString:@"/Library/Caches"] withIntermediateDirectories:NO attributes:nil error:nil];
    
//    [self resetContent];
    
    [self showLoginView];
}

- (void) resetContent
{
    NSFileManager *localFileManager = [[NSFileManager alloc] init];
    NSString * rootDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *rootURL = [NSURL fileURLWithPath:rootDir isDirectory:YES];
    
    NSArray *content = [localFileManager contentsOfDirectoryAtURL:rootURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:NULL];
    
    for (NSURL *itemURL in content) {
        [localFileManager removeItemAtURL:itemURL error:NULL];
    }
}

- (void)showLoginView {
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
//    NSLog(@"%@", [UIApplication sharedApplication].keyWindow.rootViewController);   
    NSLog(@"%@", [[[[UIApplication sharedApplication] delegate] window] rootViewController]);
    if (![rootViewController isKindOfClass:[PCCULoginViewController class]])
    {
        PCCULoginViewController *loginView = [[PCCULoginViewController alloc] init];
        
        [rootViewController presentViewController:loginView animated:YES completion:nil];
        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:loginView];
        
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginView animated:YES completion:nil];
//        [[UIApplication sharedApplication].keyWindow setRootViewController:loginView];
        
        //    loginView.view.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginView
//                                                                                     animated:YES
//                                                                                   completion:NULL];
        
//        [[UIApplication sharedApplication].keyWindow setRootViewController:nil];
//        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }
}

- (BOOL)haveAccessToken
{
    NSString* accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"PCCUAccessToken"];
    //    NSLog(@"PCCUAccessToken: %@", accessToken);
    if (accessToken == nil) {
        return NO;
    }
    return YES;
}

+ (NSString *)getClientID
{
    return [[self alloc] getClientID];
}

- (NSString *)getClientID
{
    NSString* clientID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"PCCUOAuthClientID"];
    //    NSLog(@"PCCUOAuthClientID: %@", clientID);
    if (clientID == nil)
    {
        NSLog(@"PCCUOAuthClientID not set.");
        abort();
    }
    return clientID;
}

+ (NSString *)getAccessToken
{
    return [[self alloc] getAccessToken];
}

- (NSString *)getAccessToken
{
    NSString* accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"PCCUAccessToken"];
    //    NSLog(@"PCCUAccessToken: %@", accessToken);
    if (accessToken == nil) {
        [self showLoginView];
        return NULL;
    }
    return accessToken;
}

- (NSString *)getCoustomURLScheme
{
    NSString* coustomURLScheme = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"PCCUOAuthCoustomURLScheme"];
    //    NSLog(@"PCCUCoustomURLScheme: %@", coustomURLScheme);
    if (coustomURLScheme == nil)
    {
        NSLog(@"PCCUOAuthCoustomURLScheme not set.");
        abort();
    }
    else
    {
        NSArray* bundleURLSchemes = [[[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleURLTypes"] objectAtIndex:0] valueForKey:@"CFBundleURLSchemes"];
        if ([bundleURLSchemes containsObject:coustomURLScheme])
        {
            return coustomURLScheme;
        }
        else
        {
            NSLog(@"CFBundleURLSchemes not set.");
            abort();
        }
    }
}

+ (NSURL *)getOauthUrl
{
    return [[self alloc] getOauthUrl];
}

- (NSURL *)getOauthUrl
{
    NSString* clientID = [self getClientID];
    //    NSLog(@"PCCUOAuthClientID: %@", clientID);
    NSString* coustomURLScheme = [self getCoustomURLScheme];
    //    NSLog(@"PCCUOAuthCoustomURLScheme: %@", coustomURLScheme);
    
    NSString* redirectURL = [[NSString alloc] initWithFormat:@"%@://PCCUOAuth", coustomURLScheme];
    NSString* oauthUrl = [NSString stringWithFormat:@"https://mobi.pccu.edu.tw/Login/?client_id=%@&redirect_uri=%@&response_type=token&state=pccuoauthlogin", clientID, redirectURL];
    
    return [NSURL URLWithString:oauthUrl];
}

- (void)goOAuth2
{
    NSString* clientID = [self getClientID];
    //    NSLog(@"PCCUOAuthClientID: %@", clientID);
    NSString* coustomURLScheme = [self getCoustomURLScheme];
    //    NSLog(@"PCCUOAuthCoustomURLScheme: %@", coustomURLScheme);
    
    NSString* redirectURL = [[NSString alloc] initWithFormat:@"%@://PCCUOAuth", coustomURLScheme];
    NSString* oauthUrl = [NSString stringWithFormat:@"https://mobi.pccu.edu.tw/Login/?client_id=%@&redirect_uri=%@&response_type=token&state=pccuoauthlogin", clientID, redirectURL];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:oauthUrl]];
}

- (void)hideWebView:(BOOL)animated
{
//    [UIApplication sharedApplication].keyWindow.rootViewController
//    [self topViewController]
    
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[PCCULoginViewController class]]) {
        NSLog(@"Is PCCULoginViewController.");
        if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController != nil) {
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:animated completion:nil];
        }
    }
}

//- (UIViewController *)topViewController{
//    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
//}
//
//- (UIViewController *)topViewController:(UIViewController *)rootViewController
//{
//    if (rootViewController.presentedViewController == nil) {
//        return rootViewController;
//    }
//    
//    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
//        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
//        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
//        return [self topViewController:lastViewController];
//    }
//    
//    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
//    return [self topViewController:presentedViewController];
//}

+ (BOOL)canHandleURL:(NSURL *)url
{
    NSString* coustomURLScheme = [[self alloc] getCoustomURLScheme];
    //    NSLog(@"PCCUOAuthCoustomURLScheme: %@", coustomURLScheme);
    
    if ([[url scheme] isEqualToString:coustomURLScheme]) {
        if ([[url host] isEqualToString:@"PCCUOAuth"]) {
            // gat params
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if([elts count] < 2) continue;
                [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
            }
            
            // check state
            if ([[params objectForKey:@"state"] isEqualToString:@"pccuoauthlogin"])
            {
                return YES;
            }
            //else if (<#expression#>)
            else
            {
                return NO;
            }
        }
        //else if (<#expression#>)
        else
        {
            return NO;
        }
    }
    //else if (<#expression#>)
    else
    {
        return NO;
    }
}

+ (NSString *)checkHandleURL:(NSURL *)url
{
    if (![self canHandleURL:url]) {
        [[self alloc] hideWebView:NO];
        NSLog(@"Error: URL Can't Handle.");
        return @"error, url can't handle.";
    }
    
    NSString* coustomURLScheme = [[self alloc] getCoustomURLScheme];
    //    NSLog(@"PCCUOAuthCoustomURLScheme: %@", coustomURLScheme);
    
    if ([[url scheme] isEqualToString:coustomURLScheme]) {
        
        // get params
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        // check state
        if ([[params objectForKey:@"state"] isEqualToString:@"pccuoauthlogin"])
        {
            NSString *error = [params objectForKey:@"error"];
            if (error != nil)
            {
                [[self alloc]  hideWebView:NO];
                NSLog(@"Error: %@.", error);
                //                NSLog(@"%@", NSLocalizedStringFromTable(@"access_denied", @"PCCUOAuth",nil));
                if ([error isEqualToString:@"access_denied"])
                {
                    error = NSLocalizedStringFromTable(@"access_denied", @"PCCUOAuth", nil);
                }
                return [NSString stringWithFormat:@"error,%@", error];
            }
            
            NSString *accessToken = [params objectForKey:@"access_token"];
            if (accessToken == nil) {
                [[self alloc]  hideWebView:NO];
                NSLog(@"Error: Not Found AccessToken.");
                return @"error,not found access_token";
            }
            else
            {
                //                NSLog(@"AccessToken: %@", accessToken);
                
                if ([[params objectForKey:@"token_type"] isEqualToString:@"Bearer"]) {
                    // 明碼
                    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
                    [defs setObject:accessToken forKey:@"PCCUAccessToken"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    
                    [[self alloc]  hideWebView:YES];
                    return @"success";
                }
                //else if (<#expression#>)
                else
                {
                    [[self alloc]  hideWebView:NO];
                    NSLog(@"Error: Unknown TokenType.");
                    return @"error,unknown token_type";
                }
            }
        }
        //else if (<#expression#>)
        else
        {
            [[self alloc]  hideWebView:NO];
            return @"";
        }
    }
    //else if (<#expression#>)
    else
    {
        [[self alloc]  hideWebView:NO];
        return @"";
    }
}

@end










////
////  PCCUOAuthLogin.m
////  ClassComment
////
////  Created by FrankWu on 2014/2/18.
////  Copyright (c) 2014年 FrankWu. All rights reserved.
////
//
//#import "PCCUOAuthLogin.h"
//
//@interface PCCUOAuthLogin ()
//
//@property (nonatomic, strong) NSString *coustomURLScheme;
//@property (nonatomic, strong) NSString *clientID;
//
//@end
//
//@implementation PCCUOAuthLogin
//
//- (void)alloc {
//    self.coustomURLScheme = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"PCCUOAuthCoustomURLScheme"];
//    NSLog(@"PCCUOAuthCoustomURLScheme: %@", self.coustomURLScheme);
//    if (self.coustomURLScheme == nil)
//    {
//        NSLog(@"PCCUOAuthCoustomURLScheme not set.");
//        abort();
//    }
//
//    self.clientID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"PCCUOAuthClientID"];
//    NSLog(@"PCCUOAuthClientID: %@", self.clientID);
//    if (self.clientID == nil)
//    {
//        NSLog(@"PCCUOAuthClientID not set.");
//        abort();
//    }
//}
//
//- (void)login {
//    [self logout];
//    [self goOAuth2];
//}
//
//- (void)logout {
//    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
//    [defs setObject:nil forKey:@"PCCUAccessToken"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (BOOL)haveAccessToken
//{
//    NSString* accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"PCCUAccessToken"];
//    NSLog(@"PCCUAccessToken: %@", accessToken);
//    if (accessToken == nil) {
//        return NO;
//    }
//    return YES;
//}
//
//- (NSString *)getClientID
//{
//    return self.clientID;
//}
//
//- (NSString *)getAccessToken
//{
//    NSString* accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"PCCUAccessToken"];
//    NSLog(@"PCCUAccessToken: %@", accessToken);
//    if (accessToken == nil) {
//        [self logout];
//        [self goOAuth2];
//        return @"No AccessToken";
//    }
//    return accessToken;
//}
//
//- (void)goOAuth2
//{
//    NSLog(@"PCCUOAuthCoustomURLScheme: %@", self.coustomURLScheme);
//    NSLog(@"PCCUOAuthClientID: %@", self.clientID);
//
//    NSString* redirectURL = [[NSString alloc] initWithFormat:@"%@://PCCUOAuth", self.coustomURLScheme];
//    NSString* oauthUrl = [NSString stringWithFormat:@"https://mobi.pccu.edu.tw/Login/?client_id=%@&redirect_uri=%@&response_type=token&state=pccuoauthlogin", self.clientID, redirectURL];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:oauthUrl]];
//}
//
//-(BOOL)canHandleURL:(NSURL *)url
//{
//    if ([[url scheme] isEqualToString:self.coustomURLScheme]) {
//        if ([[url host] isEqualToString:@"PCCUOAuth"]) {
//            // gat params
//            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//            for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
//                NSArray *elts = [param componentsSeparatedByString:@"="];
//                if([elts count] < 2) continue;
//                [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
//            }
//
//            // check state
//            if ([[params objectForKey:@"state"] isEqualToString:@"pccuoauthlogin"])
//            {
//                return YES;
//            }
//            //else if (<#expression#>)
//            else
//            {
//                return NO;
//            }
//        }
//        //else if (<#expression#>)
//        else
//        {
//            return NO;
//        }
//    }
//    //else if (<#expression#>)
//    else
//    {
//        return NO;
//    }
//}
//
//- (NSString *)checkHandleURL:(NSURL *)url
//{
//    if (![self canHandleURL:url]) {
//        NSLog(@"Error: URL Can't Handle.");
//        return @"error, url can't handle.";
//    }
//
//    if ([[url scheme] isEqualToString:self.coustomURLScheme]) {
//
//        // get params
//        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//        for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
//            NSArray *elts = [param componentsSeparatedByString:@"="];
//            if([elts count] < 2) continue;
//            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
//        }
//
//        // check state
//        if ([[params objectForKey:@"state"] isEqualToString:@"pccuoauthlogin"])
//        {
//            NSString *error = [params objectForKey:@"error"];
//            if (error != nil)
//            {
//                NSLog(@"Error: %@", error);
//                return [NSString stringWithFormat:@"error, %@.", error];
//            }
//
//            NSString *accessToken = [params objectForKey:@"access_token"];
//            if (accessToken == nil) {
//                NSLog(@"Error: Not Found AccessToken.");
//                return @"error, not found access_token.";
//            }
//            else
//            {
//                NSLog(@"AccessToken: %@", accessToken);
//
//                if ([[params objectForKey:@"token_type"] isEqualToString:@"Bearer"]) {
//                    // 明碼
//                    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
//                    [defs setObject:accessToken forKey:@"PCCUAccessToken"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//
//                    return @"success";
//                }
//                //else if (<#expression#>)
//                else
//                {
//                    NSLog(@"Error: Unknown TokenType.");
//                    return @"error, unknown token_type.";
//                }
//            }
//        }
//        //else if (<#expression#>)
//        else
//        {
//            return NO;
//        }
//    }
//    //else if (<#expression#>)
//    else return NO;
//}
//
//+ (BOOL)haveAccessToken
//{
//    return [[self alloc] haveAccessToken];
//}
//
//+ (NSString *)getClientID
//{
//    return [[self alloc] getClientID];
//}
//
//+ (NSString *)getAccessToken
//{
//    return [[self alloc] getAccessToken];
//}
//
//+ (BOOL)canHandleURL:(NSURL *)url
//{
//    return [[self alloc] canHandleURL:url];
//}
//
//+ (NSString *)checkHandleURL:(NSURL *)url
//{
//    return [[self alloc] checkHandleURL:url];
//}
//
//@end

