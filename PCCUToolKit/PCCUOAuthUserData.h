//
//  PCCUOAuthUserData.h
//  ClassComment
//
//  Created by FrankWu on 2014/2/20.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCCUOAuthUserData : NSObject

//- (void)getUserData;
- (BOOL)haveUserData;
- (BOOL)checkUserData;

- (NSString *)getUserAccount;
- (NSString *)getUserDept;
- (NSString *)getUserName;

+ (NSString *)getUserAccount;
+ (NSString *)getUserDept;
+ (NSString *)getUserName;

@end

