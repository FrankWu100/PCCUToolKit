//
//  PCCULoginViewController.h
//  ClassComment
//
//  Created by FrankWu on 2014/2/19.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCCUOAuthLogin.h"

typedef NS_ENUM(NSUInteger, LogoMoveState) {
    LogoMoveUp,
    LogoMoveDown,
    LogoMoveNone
};

@interface PCCULoginViewController : UIViewController {
    LogoMoveState theLogoMoveState;
    UIImageView *iconImageView;
    UIButton *loginButton;
}

@end
