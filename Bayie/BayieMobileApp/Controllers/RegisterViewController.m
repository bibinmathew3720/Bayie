//
//  RegisterViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 21/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#define kOFFSET_FOR_KEYBOARD 80.0

#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataClass.h"
#import "VerifyOTPViewController.h"
#import "BayieHub.h"
#import "IQKeyboardManager.h"


@interface RegisterViewController ()
{
    MBProgressHUD *hud;

}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nameTextField becomeFirstResponder];
    
    self.emailTextField.tintColor = [UIColor blackColor];
    self.passwordTextField.tintColor = [UIColor blackColor];
    self.mobileTextField.tintColor = [UIColor blackColor];
    self.nameTextField.tintColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

    
    _registrationTitle
    .text = [NSString stringWithFormat:NSLocalizedString(@"REGISTER", nil), @(1000000)];
    [_registrationButton setTitle:NSLocalizedString(@"REGISTER", nil) forState:UIControlStateNormal];
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];}



// hiding status bar

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) gotBayieAPIData:(NSNotification *) notification
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
        NSString *errormsg = responseDict[@"error"];
        
        if ([errormsg isEqualToString:@""]) {
            
            if (![_mobileTextField.text  isEqualToString: @""] && [_emailTextField.text  isEqualToString: @""] ) {
                NSString *mobileToken = responseDict[@"mobileToken"];
                NSLog(@"%@", mobileToken);
                DataClass *mobObj = [DataClass getInstance];
                mobObj.mobleToken= mobileToken;
                
                UIAlertController * alert =[UIAlertController
                                            alertControllerWithTitle:@"Bayie" message:responseDict[@"data"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okButton = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               
                                               [self performSegueWithIdentifier:@"OTPVerification" sender:self];
                                           }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            if(([_mobileTextField.text  isEqualToString: @""] &&![_emailTextField.text  isEqualToString: @""]) || (![_mobileTextField.text  isEqualToString: @""] &&![_emailTextField.text  isEqualToString: @""])){
                
                UIAlertController *emailalert = [UIAlertController
                                                 alertControllerWithTitle:@"Bayie" message:responseDict[@"data"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okBttn = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               
                                         //      [self performSegueWithIdentifier:@"OTPVerification" sender:self];
                                            //   [self.navigationController popToViewController:controller animated:YES];
                                          //     [self.navigationController popViewControllerAnimated:YES];
                                               [self dismissViewControllerAnimated:YES completion:nil];

                                               [hud hideAnimated:YES];

                                           }];
                
                [emailalert addAction:okBttn];
                [self presentViewController:emailalert animated:YES completion:nil];
            }
        }
        else if (![errormsg isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [hud hideAnimated:YES];

        }
        [hud hideAnimated:YES];

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)registerButtonClick:(id)sender {
    
    [self userRegistration];
    
}

- (IBAction)backButtonClick:(id)sender {
    
   [self dismissViewControllerAnimated:YES completion:nil];
 //   [self.navigationController popViewControllerAnimated:YES];

}

-(void)userRegistration{
    if(_nameTextField.text.length == 0){
        UIAlertController *emailalert = [UIAlertController
                                         alertControllerWithTitle:@"Bayie" message:@"Please enter name" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okBttn = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //  _emailTextField.text =@"";
                                     [self.nameTextField becomeFirstResponder];
                                     [hud hideAnimated:YES];
                                     
                                 }];
        
        [emailalert addAction:okBttn];
        [self presentViewController:emailalert animated:YES completion:nil];
        return;
    }else if(_mobileTextField.text.length == 0 && _emailTextField.text.length == 0){
        UIAlertController *emailalert = [UIAlertController
                                         alertControllerWithTitle:@"Bayie" message:@"Please enter mobile number & email" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okBttn = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //  _emailTextField.text =@"";
                                     [self.mobileTextField becomeFirstResponder];
                                     [hud hideAnimated:YES];
                                     
                                 }];
        
        [emailalert addAction:okBttn];
        [self presentViewController:emailalert animated:YES completion:nil];
        return;

    }else if(_passwordTextField.text.length == 0){
        UIAlertController *emailalert = [UIAlertController
                                         alertControllerWithTitle:@"Bayie" message:@"Please enter password" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okBttn = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //  _emailTextField.text =@"";
                                     [self.passwordTextField becomeFirstResponder];
                                     [hud hideAnimated:YES];
                                     
                                 }];
        
        [emailalert addAction:okBttn];
        [self presentViewController:emailalert animated:YES completion:nil];
        return;

        return;

    }else if(_confirmPasswordTextField.text.length == 0){
        UIAlertController *emailalert = [UIAlertController
                                         alertControllerWithTitle:@"Bayie" message:@"Please enter password" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okBttn = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //  _emailTextField.text =@"";
                                     [self.confirmPasswordTextField becomeFirstResponder];
                                     [hud hideAnimated:YES];
                                     
                                 }];
        
        [emailalert addAction:okBttn];
        [self presentViewController:emailalert animated:YES completion:nil];
        return;

        return;

    }else if(![self validateEmail:_emailTextField.text] && ((_mobileTextField.text.length == 0) || (_mobileTextField.text.length == 8) )){
        
        
        if((_mobileTextField.text.length == 8) && (_emailTextField.text.length == 0)){
            if(self.passwordTextField.text.length<8){
                NSString *alertMessageString = @"Your Password Must Contain At Least 8 Characters!";
                UIAlertController *alertCntlr = [UIAlertController
                                                 alertControllerWithTitle:@"Bayie" message:alertMessageString preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okBttn = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             //  _emailTextField.text =@"";
                                             [self.confirmPasswordTextField becomeFirstResponder];
                                             [hud hideAnimated:YES];
                                             
                                         }];
                
                [alertCntlr addAction:okBttn];
                [self presentViewController:alertCntlr animated:YES completion:nil];
                return;
            }
            if ([_passwordTextField.text  isEqualToString: _confirmPasswordTextField.text]){
                
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
                
                NSDictionary *parameters =  @{@"name":_nameTextField.text,@"mobile":_mobileTextField.text,@"email":_emailTextField.text,@"password":_passwordTextField.text,@"confirm_password":_confirmPasswordTextField.text};
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"regCustomer"];
            } else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                                message:@" Password mismatch"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [hud hideAnimated:YES];
                
            }
            
            return;
            
        }
        
        UIAlertController *emailalert = [UIAlertController
                                         alertControllerWithTitle:@"Bayie" message:@"Invalid email format" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okBttn = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                  //  _emailTextField.text =@"";
                                     [self.emailTextField becomeFirstResponder];
                                     [hud hideAnimated:YES];
                                     
                                 }];
        
        [emailalert addAction:okBttn];
        [self presentViewController:emailalert animated:YES completion:nil];
 
        return;

    }
    if((_mobileTextField.text.length > 8) ||_mobileTextField.text.length < 8 ){
        if([self validateEmail:_emailTextField.text]){
           //  [hud hideAnimated:YES];
            if(self.passwordTextField.text.length<8){
                NSString *alertMessageString = @"Your Password Must Contain At Least 8 Characters!";
                UIAlertController *alertCntlr = [UIAlertController
                                                 alertControllerWithTitle:@"Bayie" message:alertMessageString preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okBttn = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             //  _emailTextField.text =@"";
                                             [self.confirmPasswordTextField becomeFirstResponder];
                                             [hud hideAnimated:YES];
                                             
                                         }];
                
                [alertCntlr addAction:okBttn];
                [self presentViewController:alertCntlr animated:YES completion:nil];
                return;
            }
            if ([_passwordTextField.text  isEqualToString: _confirmPasswordTextField.text]){
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
                

                NSDictionary *parameters =  @{@"name":_nameTextField.text,@"mobile":_mobileTextField.text,@"email":_emailTextField.text,@"password":_passwordTextField.text,@"confirm_password":_confirmPasswordTextField.text};
                NSError *error;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                
                [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"regCustomer"];
            } else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                                message:@" Password mismatch"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [hud hideAnimated:YES];
                
            }
            
            return;
        }
        
        UIAlertController *emailalert = [UIAlertController
                                         alertControllerWithTitle:@"Bayie" message:@"Invalid mobile number" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okBttn = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                   //  _mobileTextField.text =@"";
                                     [self.mobileTextField becomeFirstResponder];
                                     [hud hideAnimated:YES];
                                     
                                 }];
        
        [emailalert addAction:okBttn];
        [self presentViewController:emailalert animated:YES completion:nil];
        
        // [hud hideAnimated:YES];
        return;
        
   }
    
    
    if ([_passwordTextField.text  isEqualToString: _confirmPasswordTextField.text]){
        NSDictionary *parameters =  @{@"name":_nameTextField.text,@"mobile":_mobileTextField.text,@"email":_emailTextField.text,@"password":_passwordTextField.text,@"confirm_password":_confirmPasswordTextField.text};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"regCustomer"];
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                        message:@"password mismatch"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [hud hideAnimated:YES];
        
    }

    
}

-(BOOL) validateEmail:(NSString*) emailString
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    if (regExMatches == 0) {
        return NO;
    }
    else
        return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"OTPVerification"]) {
        UINavigationController *nav = segue.destinationViewController;
        VerifyOTPViewController *dest = (VerifyOTPViewController *)nav.topViewController;
        dest.mobileNo =_mobileTextField.text;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];

    [hud hideAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    [hud hideAnimated:YES];
    
}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

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

@end
