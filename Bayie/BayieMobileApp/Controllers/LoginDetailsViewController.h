//
//  LoginDetailsViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 21/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataClass.h"
#import <CoreLocation/CoreLocation.h>

@interface LoginDetailsViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,retain) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//@property(nonatomic, readonly, retain) NSUUID *identifierForVendor;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIButton *forgetPassword;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

//@property (weak, nonatomic) IBOutlet UILabel *successMsg;
//@property (strong, nonatomic) NSString *successMsgOtp;
//@property (assign) BOOL *fromverification;

@end
