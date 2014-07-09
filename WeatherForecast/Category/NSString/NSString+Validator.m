//
//  NSString+Validator.m
//  PocketGuard
//
//  Created by Петровский Максим on 21.05.14.
//  Copyright (c) 2014 realme. All rights reserved.
//

#import "NSString+Validator.h"

#define kMinimumPasswordLength 6

@implementation NSString (Validator)

- (BOOL)validEmail
{
    if([self length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:self
                                                     options:0 range:NSMakeRange(0, [self length])];
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)validPassword
{
    return ([self length]>=kMinimumPasswordLength);
}

@end
