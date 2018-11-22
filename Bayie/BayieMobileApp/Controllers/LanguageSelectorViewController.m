//
//  LanguageSelectorViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 22/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "LanguageSelectorViewController.h"
#import "DataClass.h"
#import "LoginViewController.h"


@interface LanguageSelectorViewController ()

@end

@implementation LanguageSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // UIView *rootView = [[[NSBundle mainBundle] loadNibNamed:@"Login" owner:self options:nil] objectAtIndex:0];
  //  [self.view addSubview:rootView];

    [[_arabicButton layer] setBorderWidth:1.0f];
    [[_arabicButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[_englishButton layer] setBorderWidth:1.0f];
    [[_englishButton layer] setBorderColor:[UIColor whiteColor].CGColor];
 //  _englishButton.titleLabel.text = @"rfref";
    [_englishButton setTitle:NSLocalizedString(@"ENGLISH", nil) forState:UIControlStateNormal];
     [_arabicButton setTitle:NSLocalizedString(@"ARABIC", nil) forState:UIControlStateNormal];
    _bottomLabel
    .text = [NSString stringWithFormat:NSLocalizedString(@"YOU_CAN_UPDATE_LANUAGE_PREFERENCE", nil), @(1000000)];
   _profileLabel.text = [NSString stringWithFormat:NSLocalizedString(@"PROFILE_APP_LANGUAGE", nil), @(1000000)];
}

// Hiding task bar
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) checkAndXfer{

    DataClass *obj = [DataClass getInstance];
    NSString *userToken;
    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    
    userToken = [pref objectForKey:@"userToken"];
    
    if(userToken !=nil && obj.userToken != nil){
        if ([[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"en"].location == NSNotFound){
              [self arabicBtn:self];
        }else{
        // for now until Arabic gets done.
        [self englishBtn:self];
        }
    }
    
}

- (IBAction)englishBtn:(id)sender{
    
    DataClass *obj=[DataClass getInstance];
    obj.isEnglish= YES;
    
    NSLog(@"English button clicked");
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *path;
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    //When we check with iPhone,iPad device it shows "en-US".So we need to change it to "en"
    strSelectedLanguage = [strSelectedLanguage stringByReplacingOccurrencesOfString:@"en-US" withString:@"en"];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"en"]]){
              path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
    if([DataClass isiPad]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainEniPad" bundle:[NSBundle mainBundle]];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }else{
      
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainEn" bundle:[NSBundle mainBundle]];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}


- (IBAction)arabicBtn:(id)sender {
    
    DataClass *obj=[DataClass getInstance];
    obj.isEnglish= NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie" message:@"Do you want to change the language to arabic then relauch the app?" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    
    [alert setDelegate:self];
    [alert show];
    
 //[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil] forKey:@"AppleLanguages"];
// [[NSUserDefaults standardUserDefaults] synchronize];
[self checkAndXfer];
    
    
    NSString *path;
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
 
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
    }

    NSLog(@"Arabic button clicked");
    if([DataClass isiPad]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAriPad" bundle:[NSBundle mainBundle]];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainAr" bundle:[NSBundle mainBundle]];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0){
        NSLog(@"arabic");
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil] forKey:@"AppleLanguages"];
      [[NSUserDefaults standardUserDefaults] synchronize];

        exit(0);
    }else {
        NSLog(@"english"); // no btn
        
        [self englishBtn:self];

    }
}
@end
