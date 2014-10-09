//
//  PCCULoginViewController.m
//  ClassComment
//
//  Created by FrankWu on 2014/2/19.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import "PCCULoginViewController.h"
#import <SVWebViewController/SVModalWebViewController.h>

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

#define Is4InchScreen ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IOS_VERSION_7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define TopLayoutGuide (IOS_VERSION_7 ? 20.0f : 0.0f)

@interface PCCULoginViewController ()

@end

@implementation PCCULoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:UIColorFromRGB(0xDBD3CC)];
    }
    return self;
}

- (id)initWithLogoAnimate:(LogoMoveState)logoMoveState
{
    self = [self init];
    if (self) {
        // Custom initialization
        theLogoMoveState = logoMoveState;
        
        //        switch (logoMoveState) {
        //            case LogoMoveUp:
        //
        //            case LogoMoveDown:
        //
        //            case LogoMoveNone:
        //
        //        }
        
    }
    return self;
}

- (UIButton *)getLoginBtn {
    CGRect viewRect = [[UIScreen mainScreen] bounds];
    CGSize viewSize = viewRect.size;
    
    // ButtonImage
    UIImage *btnImageNormal;
    UIImage *btnImageHighlighted;
    if (Is4InchScreen) {
        btnImageNormal = [UIImage imageNamed:@"Btn-Sign-In-L-N.png"];
        btnImageHighlighted = [UIImage imageNamed:@"Btn-Sign-In-L-S.png"];
    }
    else
    {
        btnImageNormal = [UIImage imageNamed:@"Btn-Sign-In-M-N.png"];
        btnImageHighlighted = [UIImage imageNamed:@"Btn-Sign-In-M-S.png"];
    }
    
    // Button
    UIButton *theloginButton = [[UIButton alloc] initWithFrame:CGRectMake((viewSize.width-btnImageNormal.size.width/2)/2, (viewSize.height-btnImageNormal.size.height/2)*4/7-40+TopLayoutGuide, btnImageNormal.size.width/2, btnImageNormal.size.height/2)];
    [theloginButton setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [theloginButton setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [theloginButton addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [theloginButton setTitle:NSLocalizedStringFromTable(@"sign_in", @"PCCUOAuth", nil) forState:UIControlStateNormal];
    [theloginButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
    theloginButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    
    return theloginButton;
}

- (UIImageView *)getIconImageView {
    CGRect viewRect = [[UIScreen mainScreen] bounds];
    CGSize viewSize = viewRect.size;
    
    UIImageView *theIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewSize.width-120)/2, (viewSize.height-120)*4/7-100+TopLayoutGuide, 120, 120)];
    //    NSLog(@"%f, %f", (viewSize.width-120)/2, (viewSize.height-120)*4/7-80);
    
    UIImage *iconImage = [UIImage imageNamed:@"iTunesArtwork.png"];
    
    theIconImageView.layer.shadowColor = [[UIColor grayColor] CGColor];
    theIconImageView.layer.shadowOffset = CGSizeMake(1.0f, -1.0f); // [水平偏移, 垂直偏移]
    theIconImageView.layer.shadowOpacity = 1.5f; // 0.0 ~ 1.0 的值
    theIconImageView.layer.shadowRadius = 3.5f; // 陰影發散的程度
    
    // theIconImageView.layer.shouldRasterize = YES;
    // theIconImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    theIconImageView.image = iconImage;
    // optional:
    // [iconImageView sizeToFit];
    return theIconImageView;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect viewRect = [[UIScreen mainScreen] bounds];
    CGSize viewSize = viewRect.size;
    
    iconImageView = [self getIconImageView];
    [self.view addSubview:iconImageView];
    
    loginButton = [self getLoginBtn];
    loginButton.alpha = 0.0f;
    [self.view addSubview:loginButton];
    
    double delayInSeconds = 0.25;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        
        //启用动画移动
        [UIImageView beginAnimations:nil context:NULL];
        //移动时间2秒
        [UIImageView setAnimationDuration:1.3];
        //图片持续移动
        [UIImageView setAnimationBeginsFromCurrentState:YES];
        //重新定义图片的位置和尺寸,位置
        iconImageView.frame = CGRectMake((viewSize.width-110)/2, (viewSize.height-110)*4/7-160+TopLayoutGuide, 110, 110);
        //完成动画移动
        [UIImageView commitAnimations];
        
        loginButton.alpha = 0.0f;
        [UIView animateWithDuration:0.8
                              delay:0.5
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{ loginButton.alpha = 1.0; }
                         completion:nil];
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtn:(id)sender{
    //    [[PCCUOAuthLogin alloc] login];
    
    [[PCCUOAuthLogin alloc] logout];
    
    NSURL *oauthUrl = [[PCCUOAuthLogin alloc] getOauthUrl];
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ([version floatValue] >= 7.0) {
//        [[UINavigationBar appearance] setTranslucent:NO];
        [[UINavigationBar appearance] setTintColor:NULL];
        [[UINavigationBar appearance] setBarTintColor:NULL];
        
        [[UIToolbar appearance] setTintColor:NULL];
        [[UIToolbar appearance] setBackgroundColor:NULL];
    }
    else
    {   // iOS 6
        
        [[UINavigationBar appearance] setTintColor:NULL];
        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
        
        // Change the appearance of NavigationBar
        [[UINavigationBar appearance] setBackgroundImage:NULL forBarMetrics:UIBarMetricsDefault];
        
        // Change the appearance of back button
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:NULL forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        // Change the appearance of other navigation button
        [[UIBarButtonItem appearance] setBackgroundImage:NULL forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        // Change the appearance of ToolBar
        [[UIToolbar appearance] setBackgroundImage:NULL forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:oauthUrl];
//    webViewController.hideActionBarButton = YES;
    
    
    [self presentViewController:webViewController animated:YES completion:NULL];
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
}

- (void)logoMoveUp
{
    
}

- (void)logoMoveDown
{
    
}

@end
