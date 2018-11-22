//
//  NSString+Extension.m
//  PlatformMobile
//
//  Created by Vaisakh krishnan on 16/01/12.
//  Copyright (c) 2012 Pumex All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (BOOL)empty {
    BOOL empty = YES;
    NSString* temporaryString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (temporaryString.length>0) {
        empty = NO;
    }
    return empty;
}

- (BOOL)validEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:self];
    return isValid;
}

- (BOOL)validNameWithSpace {
    NSString *ACCEPTABLE_CHARECTERS = @" 123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    //NSLog(@" value %d",[self isEqualToString:filtered]);
    return [self isEqualToString:filtered];
}

- (BOOL)validName {
    NSString *ACCEPTABLE_CHARECTERS = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    //NSLog(@" value %d",[self isEqualToString:filtered]);
    return [self isEqualToString:filtered];
}

- (BOOL)validFacebookName {
    NSString *ACCEPTABLE_CHARECTERS = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.-_";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    //NSLog(@" value %d",[self isEqualToString:filtered]);
    return [self isEqualToString:filtered];
}

- (BOOL)validateUrl {
    NSString *ACCEPTABLE_CHARECTERS =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)validateMobile {
    NSString *ACCEPTABLE_CHARECTERS = @" 0123456789+-";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
    NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [self isEqualToString:filtered];
}

- (BOOL)ValidatePhoneWithString {
    BOOL valid = NO;
    if(![self length] == 0) {
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
        valid = [alphaNums isSupersetOfSet:inStringSet];
    }
    return valid;
}

-(int)noOfUpperCaseCharacters{
    int upperCaseCharacterCount = 0;
    NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    for (int i = 0; i < [self length]; i++)
    {
        unichar c = [self characterAtIndex:i];
        if ([upperCaseChars characterIsMember:c]) {
            upperCaseCharacterCount++;
        }
    }
    return upperCaseCharacterCount;
}

-(int)noOfLowerCaseCharacters{
    int lowerCaseCharacterCount = 0;
    NSCharacterSet *lowerCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    for (int i = 0; i < [self length]; i++)
    {
        unichar c = [self characterAtIndex:i];
        if ([lowerCaseChars characterIsMember:c]) {
            lowerCaseCharacterCount++;
        }
    }
    return lowerCaseCharacterCount;
}

-(int)noOfDigits{
    int digtsCount = 0;
    NSCharacterSet *digits = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [self length]; i++)
    {
        unichar c = [self characterAtIndex:i];
        if ([digits characterIsMember:c]) {
            digtsCount++;
        }
    }
    return digtsCount;

}

-(int)noOfSpecialCharacters{
    int specialCharactersCount = 0;
    NSCharacterSet *specialChars = [NSCharacterSet characterSetWithCharactersInString:@"@#$%&*!"];
    for (int i = 0; i < [self length]; i++)
    {
        unichar c = [self characterAtIndex:i];
        if ([specialChars characterIsMember:c]) {
            specialCharactersCount++;
        }
    }
    return specialCharactersCount;
    
}

@end
