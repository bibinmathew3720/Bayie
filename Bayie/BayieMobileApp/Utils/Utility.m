//
//  Utillity.m
//  BayieMobileApp
//
//  Created by !indigo on 6/17/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "Utility.h"

@implementation Utility
+(BOOL) isValidDataObject:(id) param{
    
    if (nil == param  )
        return NO;
    if (![param isKindOfClass:[NSArray class]] ){
        return NO;
    }else{
        if  ([param isKindOfClass:[NSArray class]])
            if ([param count] < 1)
                return NO;
    }
    return YES;
}

+ (NSString *) tripJSONResidue:(NSString *) string {
	if([string isKindOfClass:[NSString class]]) {
		if([string containsString:@"[\""]) {
			string = [string stringByReplacingOccurrencesOfString:@"[\"" withString:@""];
		}
		if([string containsString:@"\"]"]) {
			string = [string stringByReplacingOccurrencesOfString:@"\"]" withString:@""];
		}
	}
	return string;
}

+(void)showLogInAlertInController:(UIViewController *)viewController{
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    NSString *messageString = @"";
    NSString *headingString = @"Bayie";
    NSString *loginString = @"";
    NSString *cancelString = @"";
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
          messageString = @"الرجاء تسجيل الدخول للوصول الى هذه الميزة";
        loginString = @"تسجيل الدخول";
        cancelString = @"إلغاء";
        
    }
    else{
       messageString = @"Please login to access this feature";
        loginString = @"Login";
        cancelString = @"Cancel";
    }
    
    UIAlertController *logInAlert = [UIAlertController alertControllerWithTitle:headingString message:messageString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:loginString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BayieShowHome object:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
    }];
    [logInAlert addAction:loginAction];
    [logInAlert addAction:cancelAction];
    [viewController presentViewController:logInAlert animated:YES completion:nil];
}

+(void)showAlertInController:(UIViewController *)viewController withMessageString:(NSString *)messageString withCompletion:(void(^)(BOOL isCompleted))completed{
    NSString *headingString = @"Bayie";
    NSString *okString = NSLocalizedString(@"OK", @"OK");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:headingString message:messageString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completed(YES);
    }];
    [alert addAction:okAction];
    [viewController presentViewController:alert animated:YES completion:nil];
}
@end
