//
//  PCCUDefaultStyle.m
//  ClassComment
//
//  Created by FrankWu on 2014/2/22.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import "PCCUDefaultStyle.h"

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@implementation PCCUDefaultStyle

+ (UINavigationController *)theNavigationController
{
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    
    //0xE2AE2B
    //0xFFB200
    //0xFFA500

    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ([version floatValue] >= 7.0) {
        [navigationController.navigationBar setTranslucent:NO];
        [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//        [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(236/255.0) green:(184/255.0) blue:(53/255.0) alpha:1.0]];
//        [navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xE2AE2B)];
        [navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xFFA500)];
        
        
//        [[UIToolbar appearance] setTranslucent:NO];
        [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
        [[UIToolbar appearance] setBackgroundColor:UIColorFromRGB(0xFFA500)];
    }
    else
    {   // iOS 6
//        [navigationController.navigationBar setTintColor:[UIColor colorWithRed:(236/255.0) green:(184/255.0) blue:(53/255.0) alpha:1.0]];
//        [navigationController.navigationBar setTintColor:UIColorFromRGB(0xE2AE2B)];
        [navigationController.navigationBar setTintColor:UIColorFromRGB(0xFFA500)];
        
//        [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//        [navigationController.navigationBar setBackgroundColor:UIColorFromRGB(0xE2AE2B)];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        
        // Change the appearance of NavigationBar
        UIImage *navBarBackgroundImage = [UIImage imageNamed:@"nav-bar-bg-new"];
        [[UINavigationBar appearance] setBackgroundImage:navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
        
        // Change the appearance of back button
        UIImage *backButtonImage = [[UIImage imageNamed:@"nav-item-btn-back-new"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        // Change the appearance of other navigation button
        UIImage *barButtonImage = [[UIImage imageNamed:@"nav-item-btn-normal-new"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
        [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        // Change the appearance of ToolBar
        UIImage *toolBarBackgroundImage = [UIImage imageNamed:@"tool-bar-bg"];
        [[UIToolbar appearance] setBackgroundImage:toolBarBackgroundImage forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    return navigationController;
}

@end
