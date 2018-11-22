//
//  LoginViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 20/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface LoginViewController : UIViewController<GIDSignInDelegate>
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic,strong) GIDGoogleUser *guser;
//@property (retain, nonatomic) IBOutlet GIDSignInButton *googleSigninbtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centreDist;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCentreDist;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(void)updateUI;

@end
