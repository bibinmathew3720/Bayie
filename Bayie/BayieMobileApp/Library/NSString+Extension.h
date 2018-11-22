//
//  NSString+Extension.h
//  PlatformMobile
//
//  Created by Vaisakh krishnan on 16/01/12.
//  Copyright (c) 2012 Pumex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (BOOL)empty;
- (BOOL)validEmail;
- (BOOL)validName;
- (BOOL)validNameWithSpace;
- (BOOL)validFacebookName;
- (BOOL)validateUrl;
- (BOOL)validateMobile;
- (BOOL)ValidatePhoneWithString;
- (int) noOfUpperCaseCharacters;
- (int) noOfLowerCaseCharacters;
- (int) noOfDigits;
- (int) noOfSpecialCharacters;

@end
