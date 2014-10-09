//
//  PCCUOAuthLogin.h
//  ClassComment
//
//  Created by FrankWu on 2014/2/18.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PCCULoginViewController.h"

@interface PCCUOAuthLogin : NSObject

- (void)login;
- (void)logout;

- (BOOL)haveAccessToken;
- (NSString *)getClientID;
- (NSString *)getAccessToken;
- (NSURL *)getOauthUrl;
//- (BOOL)canHandleURL:(NSURL *)url;
//- (NSString *)checkHandleURL:(NSURL *)url;

+ (NSString *)getClientID;
+ (NSString *)getAccessToken;
+ (NSURL *)getOauthUrl;
//+ (BOOL)haveAccessToken;
+ (BOOL)canHandleURL:(NSURL *)url;
+ (NSString *)checkHandleURL:(NSURL *)url;

@end
