//
//  VerifyOTPViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 08/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "VerifyOTPViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataClass.h"
#import "LoginDetailsViewController.h"
#import "BayieHub.h"

@interface VerifyOTPViewController ()
{
    NSString *token;
    NSString *password;
    MBProgressHUD *hud;
}

@end

@implementation VerifyOTPViewController

@synthesize mobileNo,lastapiCall;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialisation];
    
    
    
   // _digitArray = @[@"1", @"2", @"3",@"4",@"5",@"6"];

    
     _digitArray = [[NSMutableArray alloc] initWithCapacity:6];
    
    _digitArray = [[NSMutableArray alloc]
               initWithObjects:@"0", @"0", @"0", @"0", @"0",@"0",
               nil];
    
    NSLog(@"%@", _digitArray);
    [self handlingTextField];
    
    _blackBg.hidden = true;
    NSLog(@"%@", mobileNo);
    _mobileNoLabel.text = mobileNo;
    _otpLabel
    .text = [NSString stringWithFormat:NSLocalizedString(@"OTP_SENT_TO", nil), @(1000000)];
    _notReceiveOTP
    .text = [NSString stringWithFormat:NSLocalizedString(@"DID_NOT_RECEIVE_OTP", nil), @(1000000)];
    [_resendOTP setTitle:NSLocalizedString(@"RESEND_OTP", nil) forState:UIControlStateNormal];
    [self.confirmButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:LatoRegular size:15], NSFontAttributeName,
                                        AppCommonWhiteColor, NSForegroundColorAttributeName,
                                        nil]
                              forState:UIControlStateNormal];
     self.lastapiCall = @"Otp";
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataOtp:) name:@"BayieResponse" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

-(void)initialisation{
    if(self.otpType == OTPTypePostAd){
        self.resendOTP.userInteractionEnabled = NO;
    }
}


-(void)handlingTextField{
    
    _firstDigitTextField.delegate = self;
    _secondDigitTextField.delegate = self;
    _thirdDigitTextField.delegate = self;
    _fourthDigitTextField.delegate = self;
    _fifthDigitTextField.delegate = self;
    _sixthDigitTextField.delegate = self;
  
    
    _firstDigitTextField.tag  = 0;
    _secondDigitTextField.tag = 1;
    _thirdDigitTextField.tag  = 2;
    _fourthDigitTextField.tag = 3;
    _fifthDigitTextField.tag  = 4;
    _sixthDigitTextField.tag  = 5;

    [_firstDigitTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingChanged];
    [_secondDigitTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingChanged];
    [_thirdDigitTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingChanged];
    [_fourthDigitTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingChanged];
    [_fifthDigitTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingChanged];
    [_sixthDigitTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingChanged];
    
    
}

- (void) gotBayieAPIData:(NSNotification *) notification{
    //if at any time notfi.object is error or null hide the HUD
    if([lastapiCall isEqualToString:@"Otp"]){
        [self gotBayieAPIDataOtp:notification];
    }else if([lastapiCall isEqualToString:@"resendOtp"] ){
        [self gotBayieAPIDataResend:notification];
        }
}





/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    clearField = NO;
    if (textField == _firstDigitTextField) {
        [textField resignFirstResponder];
        [_secondDigitTextField becomeFirstResponder];
    } else if (textField == _secondDigitTextField) {
        [textField resignFirstResponder];
        [_thirdDigitTextField becomeFirstResponder];
    }else if (textField == _thirdDigitTextField) {
        [textField resignFirstResponder];
        [_fourthDigitTextField becomeFirstResponder];
    }else if (textField == _fourthDigitTextField) {
        [textField resignFirstResponder];
        [_fifthDigitTextField becomeFirstResponder];
    }else if (textField == _fifthDigitTextField) {
        [textField resignFirstResponder];
        [_sixthDigitTextField becomeFirstResponder];
    }
    return YES;
}
 */

// MARK :- API Response Handlers

- (void) gotBayieAPIDataOtp:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occurs" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                           //    [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [hud hideAnimated:YES];
            
            return;
        }
        
        NSDictionary *responseDict = notification.object;
        NSString *data = responseDict[@"data"];
        NSString *errordata = responseDict[@"error"];
        
        if ([data isEqualToString:@""]) {
            //_blackBg.hidden = false;
            [self addingAlertControllerWithMessage:[NSString stringWithFormat:@"%@",responseDict[@"error"]]];
            //_msgLabel.text = responseDict[@"error"];

            [hud hideAnimated:YES];
            
        }else if(![responseDict[@"data"] isEqualToString:@""]) {
            
            _blackBg.hidden = true;
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message:responseDict[@"data"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           if(self.otpType == OTPTypePostAd){
                                               [self dismissViewControllerAnimated:YES completion:^{
                                                   
                                               }];
                                           }
                                           else if(self.otpType == OTPTypeSocialLogin){
                                               UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
                                                       tbc.selectedIndex=0;
                                                [self presentViewController:tbc animated:YES completion:nil];
                                           }
                                           else{
                                               LoginDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginDetailsViewController"];
                                               //   controller.fromverification = TRUE;
                                               //       [self.navigationController pushViewController:controller animated:YES];
                                               [self presentViewController:controller animated:YES completion:nil];
                                           }

                                       }];
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(void)addingAlertControllerWithMessage:(NSString *)messageString{
    UIAlertController * alert =[UIAlertController
                                alertControllerWithTitle:@"Bayie" message:messageString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                  
                                   
                               }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) gotBayieAPIDataResend:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        NSDictionary *responseDict = notification.object;
        NSString *data = responseDict[@"data"];
        NSString *errordata = responseDict[@"error"];
        
        if ([data isEqualToString:@""]) {
           // _blackBg.hidden = false;
          //  _msgLabel.text = responseDict[@"error"];
            [self addingAlertControllerWithMessage:[NSString stringWithFormat:@"%@",responseDict[@"error"]]];
           
            [hud hideAnimated:YES];
            
        }else if(![responseDict[@"data"] isEqualToString:@""]) {
            
            _blackBg.hidden = true;
            
            NSString *mobileToken = responseDict[@"mobileToken"];
            NSLog(@"%@", mobileToken);
            if(mobileToken != nil){
            DataClass *mobObj = [DataClass getInstance];
            mobObj.mobleToken= mobileToken;
            }
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message:responseDict[@"data"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                  
                                           [hud hideAnimated:YES];

                                       }];
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// MARK :- TextField Delegates


-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(clearField)
    {
        textField.text =@"";
        clearField = NO;
    }
    
//    if(textField == self.sixthDigitTextField){
//        [_digitArray insertObject:_sixthDigitTextField.text atIndex:5];
//    }
    NSInteger maxLength = 1;
    NSUInteger length = [textField.text length] + [string length] - range.length;
    
    return !(length > maxLength);
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    clearField = NO;
    if(textField == self.firstDigitTextField) {
        
        [_digitArray replaceObjectAtIndex:_firstDigitTextField.tag withObject:_firstDigitTextField.text];

       // [_digitArray insertObject:_firstDigitTextField.text atIndex:_firstDigitTextField.tag];
        _firstDigitTextField.text = @"*";
        
    }else if(textField == self.secondDigitTextField){
        
         [_digitArray replaceObjectAtIndex:_secondDigitTextField.tag withObject:_secondDigitTextField.text];
    
        _secondDigitTextField.text = @"*";
    }else if(textField == self.thirdDigitTextField){
        
         [_digitArray replaceObjectAtIndex:_thirdDigitTextField.tag withObject:_thirdDigitTextField.text];
        
    
        _thirdDigitTextField.text = @"*";
        
    }else if(textField == self.fourthDigitTextField){
        
         [_digitArray replaceObjectAtIndex:_fourthDigitTextField.tag withObject:_fourthDigitTextField.text];
        
  
        _fourthDigitTextField.text = @"*";
        
    }else if(textField == self.fifthDigitTextField){
        
         [_digitArray replaceObjectAtIndex:_fifthDigitTextField.tag withObject:_fifthDigitTextField.text];
        
 
        _fifthDigitTextField.text = @"*";
        
    }else if(textField == self.sixthDigitTextField){
         [_digitArray replaceObjectAtIndex:_sixthDigitTextField.tag withObject:_sixthDigitTextField.text];
        
    
        _sixthDigitTextField.text = @"*";
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    clearField = YES;
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    
    [hud hideAnimated:YES];
}


-(void) viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        // Navigation button was pressed. Do some stuff
        [self.navigationController popViewControllerAnimated:NO];
    }
    [super viewWillDisappear:animated];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}


// MARK :- Button actions


- (IBAction)confimButton:(id)sender {
    if(self.otpType == OTPTypePostAd){
        [self callingPostAdOTPSendingApi];
    }
    else{
        self.lastapiCall = @"Otp";

        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];

        DataClass *objt=[DataClass getInstance];
        NSLog(@"%@", objt.mobleToken);

        NSLog(@"%@", _digitArray);
        token = [NSString stringWithFormat:@"%@%@%@%@%@%@",_digitArray[_firstDigitTextField.tag],_digitArray[_secondDigitTextField.tag],_digitArray[_thirdDigitTextField.tag],_digitArray[_fourthDigitTextField.tag],_digitArray[_fifthDigitTextField.tag],_digitArray[_sixthDigitTextField.tag]];

        NSLog(@"%@", token);

        NSDictionary *parameters =  @{@"mobileToken":objt.mobleToken,@"otp":token};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"verifyOtp"];
    }
}

-(void)callingPostAdOTPSendingApi{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    DataClass *objt=[DataClass getInstance];
    NSLog(@"%@", objt.mobleToken);
    
    NSLog(@"%@", _digitArray);
    token = [NSString stringWithFormat:@"%@%@%@%@%@%@",_digitArray[_firstDigitTextField.tag],_digitArray[_secondDigitTextField.tag],_digitArray[_thirdDigitTextField.tag],_digitArray[_fourthDigitTextField.tag],_digitArray[_fifthDigitTextField.tag],_digitArray[_sixthDigitTextField.tag]];
    NSDictionary *parameters =  @{@"adToken":self.adToken,@"otp":token,@"language" :[DataClass currentLanguageString]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"otpVerification"];
}


- (IBAction)resendOTP:(id)sender {
     self.lastapiCall = @"resendOtp";
    
    _firstDigitTextField.text = @"";
    _secondDigitTextField.text = @"";
    _thirdDigitTextField.text = @"";
    _fourthDigitTextField.text = @"";
    _fifthDigitTextField.text = @"";
    _sixthDigitTextField.text = @"";

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    DataClass *objt=[DataClass getInstance];
    NSLog(@"%@", objt.mobleToken);
    
     NSDictionary *parameters =  @{@"mobileToken":objt.mobleToken,@"language" :[DataClass currentLanguageString]};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"resendOtp"];
    
}

- (IBAction)backButton:(id)sender {
    
    //[self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
@end
