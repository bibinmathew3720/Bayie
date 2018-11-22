//
//  AlertHandler.m
//  CLToolKit
//
//  Created by VK Krish on 4/22/15.
//  Copyright (c) 2015 CL. All rights reserved.
//

#import "CLAlertHandler.h"

@implementation CLAlertHandler

+ (CLAlertHandler *)standardHandler {
    static CLAlertHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - UIAlertzview Controller

- (void)showAlert:(NSString *)alertMessage title:(NSString *)title inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( BOOL isSuccess ))buttonAction {
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:title
                               message:alertMessage
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:ALERTOKTITLE style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   buttonAction(YES);
                                                   
                                               }];
    [alert addAction:ok];
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithButtons:(NSString *)alertMessage title:(NSString *)title withSuccessButton:(NSString *) successButtonTitle withCancelButton:(NSString *) cancelButtonTitle inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( BOOL isSuccess ))buttonAction{
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:title
                               message:alertMessage
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:successButtonTitle style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   buttonAction(YES);
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       buttonAction(NO);
                                                       
                                                   }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithThreeButtons:(NSString *)alertMessage title:(NSString *)title withFirstButton:(NSString *) firstButtonTitle withSecondButton:(NSString *) secondButtonTitle withThirdButton:(NSString *) thirdButtonTitle inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( NSString* successTitle ))buttonAction {
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:title
                               message:alertMessage
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:firstButtonTitle style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   buttonAction(firstButtonTitle);
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:secondButtonTitle style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       buttonAction(secondButtonTitle);
                                                   }];
    
    UIAlertAction* third = [UIAlertAction actionWithTitle:thirdButtonTitle style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action){
                                                      buttonAction(thirdButtonTitle);
                                                  }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [alert addAction:third];
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithMoreButtons:(NSString *)alertMessage title:(NSString *)title withArrayOfButtonsTitles:(NSArray *)buttonTitles inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( NSString * selectedTitle ))buttonAction {
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:title
                               message:alertMessage
                               preferredStyle:UIAlertControllerStyleAlert];
    for (NSString * title in buttonTitles) {
        UIAlertAction* ok = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       buttonAction(title);
                                                   }];
        [alert addAction:ok];
    }
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
