//
//  ChangePasswordViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 30/03/17.
//  Copyright © 2017. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "DataClass.h"
#import "AFNetworking.h"
#import "BayieHub.h"
#import "MBProgressHUD.h"
#import "EditProfileViewController.h"
@interface ChangePasswordViewController ()
{
    MBProgressHUD *hud;
}
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oldPswdTextfield.tintColor = [UIColor blackColor];
    self.confirmPaswdTextfield.tintColor = [UIColor blackColor];
    self.passwordTextfield.tintColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)showButtonclick:(id)sender {
    if (self.oldPswdTextfield.secureTextEntry == YES) {
        [ self.oldPswdShowBtn setTitle:@"hide" forState:(UIControlStateNormal)];
        self.oldPswdTextfield.secureTextEntry = NO;
    }
    else
    {
        [ self.oldPswdShowBtn setTitle:@"show" forState:(UIControlStateNormal)];
        self.oldPswdTextfield.secureTextEntry = YES;
    }
}
- (IBAction)passwordShowBtn:(id)sender {
    if (self.passwordTextfield.secureTextEntry == YES) {
        [ self.paswdShowButton setTitle:@"hide" forState:(UIControlStateNormal)];
        self.passwordTextfield.secureTextEntry = NO;
    }
    else
    {
        [ self.paswdShowButton setTitle:@"show" forState:(UIControlStateNormal)];
        self.passwordTextfield.secureTextEntry = YES;
    }

}
- (IBAction)confirmPaswdShowBtn:(id)sender {
    if (self.confirmPaswdTextfield.secureTextEntry == YES) {
        [ self.confmPaswdShowBtn setTitle:@"hide" forState:(UIControlStateNormal)];
        self.confirmPaswdTextfield.secureTextEntry = NO;
    }
    else
    {
        [ self.confmPaswdShowBtn setTitle:@"show" forState:(UIControlStateNormal)];
        self.confirmPaswdTextfield.secureTextEntry = YES;
    }

}

- (IBAction)changePassword:(id)sender {

    DataClass *usrtk=[DataClass getInstance];
    NSLog(@"usertoken in chngepasswrd vc : %@", usrtk.userToken);
    NSDictionary *parameters =  @{@"oldPassword":_oldPswdTextfield.text,@"newPassword":_passwordTextfield.text,@"confirmPassword":_confirmPaswdTextfield.text,@"userToken":usrtk.userToken};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"changePassword"];
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
            
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message:responseDict[@"data"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                           EditProfileViewController *editPro = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
                                
                                           [self.navigationController pushViewController:editPro animated:true];
                                           NSLog(@"OK BUTTON CLICKEED");
                                           
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message:responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            }
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

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
