
//
//  AlertHandler.h
//  CLToolKit
//
//  Created by VK Krish on 4/22/15.
//  Copyright (c) 2015 CL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

static NSString * ALERTOKTITLE =@"Ok";

@interface CLAlertHandler : NSObject

+ (CLAlertHandler *)standardHandler;

/**
 *  Show Alert with default Ok Button.
 *
 *  @param alertMessage Alert Message
 *               title : Alert title.
 *           controller: Alert Displaying controller
 *         buttonAction:Completion handler returns user selected action
 */

- (void)showAlert:(NSString *)alertMessage title:(NSString *)title inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( BOOL isSuccess ))buttonAction;

/**
 *  Show Alert with success and cancel buttons with appropriate title from UI.
 *
 *  @param alertMessage Alert Message
 *               title : Alert title.
 *  successButtonTitle : Success Button title.
 *   cancelButtonTitle : Cancel button title.
 *           controller: Alert Displaying controller
 *         buttonAction:Completion handler returns user selected action
 */


- (void)showAlertWithButtons:(NSString *)alertMessage title:(NSString *)title withSuccessButton:(NSString *) successButtonTitle withCancelButton:(NSString *) cancelButtonTitle inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( BOOL isSuccess ))buttonAction;

/**
 *  Show Alert with 3 buttons with appropriate title from UI.
 *
 *  @param alertMessage Alert Message
 *               title : Alert title.
 *    firstButtonTitle : First Button title.
 *   secondButtonTitle : Second button title.
 *   thirdButtonTitle  : Third button title.
 *           controller: Alert Displaying controller
 *         buttonAction:Completion handler returns user selected action
 *    buttonAction     :Completion handler returns user selected action along with button titles
 */

- (void)showAlertWithThreeButtons:(NSString *)alertMessage title:(NSString *)title withFirstButton:(NSString *) firstButtonTitle withSecondButton:(NSString *) secondButtonTitle withThirdButton:(NSString *) thirdButtonTitle inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)(  NSString* successTitle ))buttonAction;


/**
 *  Show Alert with number of buttons whose  title is passed from UI.
 *
 *  @param alertMessage Alert Message
 *               title : Alert title.
 *       buttonTitles  : Button titles array.
 *         buttonAction:Completion handler returns user selected action along with button titles
 */

- (void)showAlertWithMoreButtons:(NSString *)alertMessage title:(NSString *)title withArrayOfButtonsTitles:(NSArray *)buttonTitles inContoller:(UIViewController *) controller WithCompletionBlock:(void (^)( NSString * selectedTitle ))buttonAction;

@end
