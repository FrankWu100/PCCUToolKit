//
//  PCCUYYM.h
//  ClassComment
//
//  Created by FrankWu on 2014/2/17.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCCUYYM : NSObject
{
    NSString *YYM;
}

- (id)init;
- (id)initWithYear:(NSString *)_year term:(NSString *)_term error:(NSError **)errorPtr;
- (id)initWithDate:(NSDate *)_DateTime;

+ (PCCUYYM *)Now;

- (NSString *)getYYM;
- (NSString *)getYY;
- (NSString *)getM;

@end
