//
//  PCCUYYM.m
//  ClassComment
//
//  Created by FrankWu on 2014/2/17.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import "PCCUYYM.h"

@implementation PCCUYYM

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    
    }
    return self;
}

- (id)initWithYear:(NSString *)_year term:(NSString *)_term error:(NSError **)errorPtr
{
    self = [super init];
    if (self) {
        // Custom initialization
        if (_year.length >= 2 && _year.length <= 3) {
            if (_year.length == 2) {
                _year = [NSString stringWithFormat:@"%03d", [_year integerValue]];
            }
            
            if (_term.length == 1) {
                YYM = [NSString stringWithFormat:@"%@%@", _year, _term];
            }
            else
            {
                *errorPtr = [[NSError alloc]initWithDomain:@"TermLengthError"
                                                      code:0
                                                  userInfo:[NSDictionary dictionaryWithObjectsAndKeys: @"term's length must be 1 digit.", @"message", nil]];
                NSLog(@"term's length must be 1 digit.");
            }
        }
        else
        {
            *errorPtr = [[NSError alloc]initWithDomain:@"YearLengthError"
                                                  code:0
                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys: @"year's length must be 2~3 digits.", @"message", nil]];
            NSLog(@"year's length must be 2~3 digits.");
        }
        
    }
    return self;
}

- (id)initWithDate:(NSDate *)_DateTime
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setYYM:_DateTime];
    }
    return self;
}

+ (PCCUYYM *)Now
{
    return [[self alloc] initWithDate:[NSDate date]];
}

- (void)setYYM:(NSDate *)_DateTime
{
    NSDate *dateTime = _DateTime;
    
    NSDateFormatter *formatter_yyyy = [[NSDateFormatter alloc] init];
    [formatter_yyyy setDateFormat:@"yyyy"];
    
    NSDateFormatter *formatter_mm = [[NSDateFormatter alloc] init];
    [formatter_mm setDateFormat:@"MM"];
    
    NSString *yyyyStr = [NSString stringWithString:[formatter_yyyy stringFromDate:dateTime]];
    NSString *mmStr = [NSString stringWithString:[formatter_mm stringFromDate:dateTime]];
//    NSLog(@"STR - YY: %@ M: %@", yyyyStr, mmStr);
    
    int yyyyNum = [yyyyStr intValue];
    int mmNum = [mmStr intValue];
//    NSLog(@"INT - YY: %d M: %d", yyyyNum, mmNum);
    
    if (mmNum < 2) {
        // 上學期
//        NSLog(@"PCCU- YY: %03d  M: %d", yyyyNum - 1911 - 1, 1);
        YYM = [NSString stringWithFormat:@"%03d%d", yyyyNum - 1911 - 1, 1];
    }
    else if (mmNum >= 2 && mmNum < 8) {
        // 下學期
//        NSLog(@"PCCU- YY: %03d  M: %d", yyyyNum - 1911 - 1, 2);
        YYM = [NSString stringWithFormat:@"%03d%d", yyyyNum - 1911 - 1, 2];
    }
    else if (mmNum >= 8) {
        // 上學期
//        NSLog(@"PCCU- YY: %03d  M: %d", yyyyNum - 1911, 1);
        YYM = [NSString stringWithFormat:@"%03d%d", yyyyNum - 1911, 1];
    }
}

- (NSString *)getYYM
{
    if ([YYM length] == 0) {
        [self setYYM:[NSDate date]];
    }
    return YYM;
}

- (NSString *)getYY
{
    return [[self getYYM] substringWithRange:NSMakeRange(0, 3)];
}

- (NSString *)getM
{
    return [[self getYYM] substringWithRange:NSMakeRange(3, 1)];
}

@end