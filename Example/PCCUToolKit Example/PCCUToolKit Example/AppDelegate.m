//
//  AppDelegate.m
//  PCCUToolKit Example
//
//  Created by FrankWu on 2014/10/9.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import "AppDelegate.h"
#import "PCCU.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([[PCCUOAuthLogin alloc] haveAccessToken] == NO)
    {
        NSLog(@"No AccessToken.");
        
        self.window.rootViewController = [[PCCULoginViewController alloc] init];
        [self.window makeKeyAndVisible];
        
    }
    else
    {
        
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        [MBProgressHUD showHUDAddedTo:rootViewController.view animated:YES];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.00 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            
            [[PCCUOAuthUserData alloc] checkUserData];
            [MBProgressHUD hideHUDForView:rootViewController.view animated:YES];
        });
        
        [self openFirstView];
    }
    return YES;
}

- (void)openFirstView
{
    UINavigationController *navigationController = [PCCUDefaultStyle theNavigationController];
    
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view.backgroundColor = [UIColor whiteColor];
    [navigationController setViewControllers:@[controller] animated:NO];
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登入資料"
                                                        message:[NSString stringWithFormat:@"AccessToken: %@\nUserAccount: %@\nUserDept: %@\nUserName: %@", [PCCUOAuthLogin getAccessToken],
[PCCUOAuthUserData getUserAccount], [PCCUOAuthUserData getUserDept], [PCCUOAuthUserData getUserName]]
                                                       delegate:self
                                              cancelButtonTitle:@"確認"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([PCCUOAuthLogin canHandleURL:url])
    {
        NSString *returnMsg = [PCCUOAuthLogin checkHandleURL:url];
        if ([returnMsg isEqualToString:@"success"]) {
            
            [[PCCUOAuthUserData alloc] checkUserData];
            
            [self openFirstView];
        }
        else if ([returnMsg rangeOfString:@"error"].location != NSNotFound)
        {
            NSString *errorMsg = [[returnMsg componentsSeparatedByString:@","] objectAtIndex:1];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"error", @"PCCUOAuth", nil)
                                                                message:errorMsg
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedStringFromTable(@"confirm", @"PCCUOAuth", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            
        }
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
