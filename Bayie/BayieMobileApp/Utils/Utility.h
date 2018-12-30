//
//  Utillity.h
//  BayieMobileApp
//
//  Created by !indigo on 6/17/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *BayieShowHome = @"com.bayie.showHome";
@interface Utility : NSObject


+(BOOL) isValidDataObject:(id )param;
+ (NSString *) tripJSONResidue:(NSString *) string;
+(void)showLogInAlertInController:(UIViewController *)viewController;
+(void)showAlertInController:(UIViewController *)viewController withMessageString:(NSString *)messageString withCompletion:(void(^)(BOOL isCompleted))completed;
@end
