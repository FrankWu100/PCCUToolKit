//
//  FWJSONPrint.m
//  ClassComment
//
//  Created by FrankWu on 2014/2/11.
//  Copyright (c) 2014年 FrankWu. All rights reserved.
//

#import "FWJSONPrint.h"

@implementation FWJSONPrint

- (NSString *)describeDictionary:(id)data
{
    NSString *str = [[NSString alloc] init];
	//NSParameterAssert([data isKindOfClass: [NSArray class]] || [data isKindOfClass: [NSDictionary class]] || [data isKindOfClass: [NSString class]]);
    if ([data isKindOfClass: [NSArray class]])
    {
        if ([[data allObjects] count] == 0)
            str = [str stringByAppendingString:@"[]"];
        else{
            str = [str stringByAppendingString:@"["];
            for(NSDictionary* dict in [data allObjects])
            {
                str = [str stringByAppendingString:@"\n\t"];
                
                NSString *tmp = [self addLevel:[self describeDictionary:dict]];
                
                str = [str stringByAppendingFormat:@"%@,", tmp];
            }
            str = [str substringToIndex:[str length]-1];
            str = [str stringByAppendingString:@"\n]"];
        }
    }
    else if ([data isKindOfClass: [NSDictionary class]])
    {
        str = [str stringByAppendingString:@"{"];
        NSArray *keys;
        NSInteger i, count;
        id key, value;
        
        keys = [data allKeys];
        count = [keys count];
        for (i = 0; i < count; i++)
        {
            str = [str stringByAppendingString:@"\n\t"];
            key = [keys objectAtIndex: i];
            value = [data objectForKey: key];
            
            NSString *tmp = [self addLevel:[self describeDictionary:value]];
            
            str = [str stringByAppendingFormat:@"\"%@\" : %@,", key, tmp];
        }
        str = [str substringToIndex:[str length]-1];
        str = [str stringByAppendingString:@"\n}"];
    }
    else if ([data isKindOfClass: [NSString class]])
    {
        str = [str stringByAppendingFormat:@"\"%@\"", data];
    }
    else if ([data isKindOfClass: [NSNumber class]])
    {
        if ([NSStringFromClass([data class]) isEqualToString:@"__NSCFBoolean"]) {
            str = [str stringByAppendingFormat:[data boolValue] ? @"true" : @"false"];
        }
        else
            str = [str stringByAppendingFormat:@"%@", data];
    }
    else if (data == NULL)
    {
        str = [str stringByAppendingString:@"null"];
    }
    NSLog(@"%@", str);
    return str;
}

- (NSString *)addLevel:(NSString *)str
{
    if ([str rangeOfString:@"\n"].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"];
        str = [[NSString alloc] initWithFormat:@"%@", str];
    }
    return str;
}

@end
