//
//  ChangePasswordViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 30/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *oldPswdShowBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldPswdTextfield;
@property (weak, nonatomic) IBOutlet UIButton *paswdShowButton;
@property (weak, nonatomic) IBOutlet UITextField *confirmPaswdTextfield;
@property (weak, nonatomic) IBOutlet UIButton *confmPaswdShowBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
