//
//  RegisterViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 21/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

//@property (nonatomic, retain) NSString *strtest;

-(void)userRegistration;

@property (weak, nonatomic) IBOutlet UILabel *registrationTitle;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;

@end
