//
//  VerifyOTPViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 08/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
  OTPTypePostAd,
  OTPTypeMobile
} OTPType;

@interface VerifyOTPViewController : UIViewController<UITextFieldDelegate>
{
    NSString *mobileNo;
    BOOL clearField;
}
@property (strong, nonatomic) NSString *mobileNo;
@property (weak, nonatomic) IBOutlet UILabel *mobileNoLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *otpLabel;

@property (weak, nonatomic) IBOutlet UIButton *resendOTP;
@property (weak, nonatomic) IBOutlet UILabel *notReceiveOTP;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIView *blackBg;

@property (weak, nonatomic) IBOutlet UITextField *firstDigitTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondDigitTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdDigitTextField;
@property (weak, nonatomic) IBOutlet UITextField *fourthDigitTextField;
@property (weak, nonatomic) IBOutlet UITextField *fifthDigitTextField;
@property (weak, nonatomic) IBOutlet UITextField *sixthDigitTextField;
@property (nonatomic, strong) NSMutableArray *digitArray;

@property (weak, nonatomic)   NSString *lastapiCall;
@property (nonatomic, assign) OTPType otpType;
@property (nonatomic, strong) NSString *adToken;

@end
