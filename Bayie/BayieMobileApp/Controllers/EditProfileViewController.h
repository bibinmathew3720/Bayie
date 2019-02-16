//
//  EditProfileViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 20/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownPicker.h"

@interface EditProfileViewController : UIViewController<UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *editProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *imgButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *appLangLabel;
@property (weak, nonatomic) IBOutlet UILabel *changePasswordLabel;
@property (assign, nonatomic) BOOL *langChanged;


@property (weak, nonatomic)   NSString *lastapiCallPro;

@property (weak, nonatomic) IBOutlet UITextField *languageTextField;


@property (strong, nonatomic) DownPicker *downPicker;
@property (nonatomic, assign) BOOL isFromSocialLogin;

@end
