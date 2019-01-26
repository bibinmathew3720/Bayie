//
//  LoginDetailsViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 21/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "LoginDetailsViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "BrowseViewController.h"
#import "BayieHub.h"
#import "UserProfile.h"

@interface LoginDetailsViewController ()
{
    MBProgressHUD *hud;
    CLLocation *loc;
    UserProfile *myProfile;
}
@end


@implementation LoginDetailsViewController


- (void)viewDidLoad {
    DataClass *obb = [DataClass getInstance];
    //  obb.isEnglish= mobileToken;
    
    
    [self.emailTextField becomeFirstResponder];
    self.emailTextField.tintColor = [UIColor blackColor];
    self.passwordTextField.tintColor = [UIColor blackColor];
    // check for arabic language selection.
    if(obb.isEnglish == NO){
          if([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
              [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
          }
    }else {
        if([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
            [[UIView appearance]  setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
   
    
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataLogin:) name:@"BayieResponse" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // for location
    
    [self googleLocationSelection];
    [super viewDidLoad];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.emailTextField.text = nil;
    self.passwordTextField.text = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataLogin:) name:@"BayieResponse" object:nil];
    NSLog(@"From registration");
}
- (void) gotBayieAPIDataLogin:(NSNotification *) notification{
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
        
        if (![errormsg isEqualToString:@""]) {
            
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message:responseDict[@"error"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                  //         [[NSNotificationCenter defaultCenter]  removeObserver:self];
                                        [hud hideAnimated:YES];
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            NSString *usertoken = responseDict[@"userToken"];
  
            // FOR NOW FIX -only temp
            NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
            if(usertoken != nil){
            [pref setObject:usertoken forKey:@"userToken"];
            //[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]
            [pref synchronize];
                
                NSLog(@"In login %@", usertoken);
                DataClass *obj=[DataClass getInstance];
                obj.userToken= usertoken;
                
                [self performSegueWithIdentifier:@"Login" sender:self];
            }
//            
//            NSLog(@"In login %@", usertoken);
//            DataClass *obj=[DataClass getInstance];
//            obj.userToken= usertoken;
//            
//            [self performSegueWithIdentifier:@"Login" sender:self];
//
            /* test
            UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
            tbc.selectedIndex=0;
         
            [self.navigationController pushViewController:tbc animated:YES];
*/
         //   UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
        //[self presentViewController:tbc animated:YES completion:nil];
            
            [hud hideAnimated:YES];

        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
- (IBAction)loginButtonClick:(id)sender {
    
    
    if(_emailTextField.text.length == 0){
        UIAlertController *emailalert = [UIAlertController
                                         alertControllerWithTitle:@"Bayie" message:@"Please enter email or mobile number" preferredStyle:UIAlertControllerStyleAlert];
        
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
    
    if(_passwordTextField.text.length == 0){
        UIAlertController *emailalert = [UIAlertController
                                         alertControllerWithTitle:@"Bayie" message:@"Please enter Password" preferredStyle:UIAlertControllerStyleAlert];
        
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
    }
    
    if(([self validateEmail:_emailTextField.text] || (_emailTextField.text.length == 8)) && _emailTextField.text.length != 0 && _passwordTextField.text.length != 0){
        
        /*
        
        UIAlertController *emailalert = [UIAlertController
                                         alertControllerWithTitle:@"Bayie" message:@"Invalid input" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okBttn = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     _emailTextField.text =@"";
                                     [self.emailTextField becomeFirstResponder];
                                     [hud hideAnimated:YES];
                                     
                                 }];
        
        [emailalert addAction:okBttn];
        [self presentViewController:emailalert animated:YES completion:nil];
        
        return;
        

    }else{
    */
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    
  //   if(! ([_emailTextField.text  isEqual: @""] || [_passwordTextField.text  isEqual: @""])) {
    NSString *UUID = [[NSUUID UUID] UUIDString];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(UUID != nil){
        [defaults setObject:UUID forKey:@"uuid"];
        [defaults synchronize];

    }
    
    NSString *uuid = [defaults objectForKey:@"uuid"];
    NSLog(@"user in prooo%@", uuid);
    
   NSDictionary *parameters =  @{@"username":_emailTextField.text,@"password":_passwordTextField.text,@"deviceId":uuid};
  //  NSDictionary *parameters =  @{@"username":@"23568974",@"password":@"12345678",@"deviceId":UUID};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
       [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"userLogin"];

    }else{
        
        UIAlertController *emailalert = [UIAlertController
                                         alertControllerWithTitle:@"Bayie" message:@"Invalid email or password" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okBttn = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     _emailTextField.text =@"";
                                     [self.emailTextField becomeFirstResponder];
                                     [hud hideAnimated:YES];
                                     
                                 }];
        
        [emailalert addAction:okBttn];
        [self presentViewController:emailalert animated:YES completion:nil];
        
        return;
        

        
        
    }
}

-(void)getProfileDataFromServer{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    DataClass *obj=[DataClass getInstance];
    
    NSDictionary *parameters =  @{@"userToken":obj.userToken};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"profileData"];
}

- (void) gotBayieAPIDataProfileLoad:(NSNotification *) notification{
    
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
        NSLog(@"%@", responseDict);
        NSString *errormsg = responseDict[@"error"];
        
        if ([errormsg isEqualToString:@""]) {
            myProfile = [[UserProfile alloc] initWithDictionary:responseDict[@"data"]];
            DataClass *dataObj1=[DataClass getInstance];
            dataObj1.userId = myProfile.idField;
            dataObj1.userName = myProfile.name;
            dataObj1.userEmail = myProfile.emailId;
            dataObj1.userMobile = myProfile.phoneNumber;
            if (myProfile.profileImage){
                
            }else{
                if([responseDict[@"profileDefualtImg"] isKindOfClass:[NSString class]]){
                    myProfile.profileImage = [responseDict objectForKey:@"profileDefualtImg"];
                }
            }
            [hud hideAnimated:YES];
            
        }   else if (![errormsg isEqualToString:@""]){
            
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: errormsg preferredStyle:UIAlertControllerStyleAlert];
            
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
        }
        [hud hideAnimated:YES];
    }
}

- (IBAction)backButtonClick:(id)sender {
    
   [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)skipLoginButtonAction:(UIButton *)sender {
     [self performSegueWithIdentifier:@"Login" sender:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    [hud hideAnimated:YES];
    NSLog(@"DISAPPEAR");
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter]  removeObserver:self];

    NSLog(@"DISAPPEAR in will");

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"DISAPPEAR dalloc");

}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
 // [aTextField resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Login"]) {
        
        
        
        [hud hideAnimated:YES];
        
        UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
        tbc.selectedIndex=0;
        
        [self.navigationController pushViewController:tbc animated:YES];
        

        /*
        BrowseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowseViewController"];
        [self.navigationController pushViewController:controller animated:YES];
         */
        
        /*
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tbc = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
        tbc.selectedIndex=0;
        [self.navigationController pushViewController:tbc animated:YES];
        
        
        */
    }
}

- (void) googleLocationSelection{
    
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    NSLog(@"*dLatitude : %@", latitude);
    NSLog(@"*dLongitude : %@",longitude);
    
    
    DataClass *locObj = [DataClass getInstance];
    
    locObj.latitude = latitude;
    locObj.longitude = longitude;
    
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude]; //insert your coordinates
    
    
    [ceo reverseGeocodeLocation:loc
              completionHandler:^(NSArray *placemarks, NSError *error) {
                  CLPlacemark *placemark = [placemarks objectAtIndex:0];
                  if (placemark) {
                      NSLog(@"placemark %@",placemark);
                      //String to hold address
                      NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                      NSLog(@"addressDictionary %@", placemark.addressDictionary);
                      NSLog(@"placemark %@",placemark.region);
                      NSLog(@"placemark %@",placemark.locality); // Extract the city name
                        NSLog(@"location %@",placemark.location);
                      NSLog(@"I am currently at %@",locatedAt);
                    //  _locationLabel.text = placemark.locality;
                      
                    //  DataClass *locObj = [DataClass getInstance];
                    //  locObj.lastKnownLoc= placemark.locality;
                  }
                  else {
                      NSLog(@"Could not locate");
                  }
              }
     ];

}
-(CLLocationCoordinate2D) getLocation{
    
    _locationManager=[[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //     [locationManagerApp requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //   [_locationManager startUpdatingLocation];
    CLLocation *location1 = [_locationManager location];
    CLLocationCoordinate2D coordinate = [location1 coordinate];
    
    NSLog(@"Latitude  = %f", coordinate.latitude);
    NSLog(@"Longitude = %f", coordinate.longitude);
    
    return coordinate;
}

@end
