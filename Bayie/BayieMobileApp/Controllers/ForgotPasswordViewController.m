//
//  ForgotPasswordViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 02/05/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "LoginDetailsViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)recoverButton:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"USER_MANAGEMENT_URL", nil)] stringByAppendingString:@"forgetPassword"];
    NSDictionary *parameters =  @{@"username":self.emailTextfield.text};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error.code == NSURLErrorTimedOut) {
            //time out error here
            NSLog(@"Trigger TIME OUT");
        }
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                
                if ([responseDict[@"data"] isEqualToString:@""]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                                    message:responseDict[@"error"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }else if(![responseDict[@"data"] isEqualToString:@""]) {

                UIAlertController * alert =[UIAlertController
                                                alertControllerWithTitle:@"Bayie" message:responseDict[@"data"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* okButton = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {

                                                   [self dismissViewControllerAnimated:YES completion:nil];

                                               }];
                    [alert addAction:okButton];
                    [self presentViewController:alert animated:YES completion:nil];

                }
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message:error
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        [hud hideAnimated:YES];
    }]resume];
  }

- (IBAction)backButton:(id)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backToLoginButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
