//
//  LoginViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 20/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "LoginViewController.h"

#import "BayieHub.h"
#import "DataClass.h"
#import "MBProgressHUD.h"
#import "BrowseViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "EditProfileViewController.h"

@interface LoginViewController ()
{
    MBProgressHUD *hud;

}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    DataClass *obb = [DataClass getInstance];
  //  obb.isEnglish= mobileToken;
    
    [self checkLogout];
    [self checkAndXfer];

    if(obb.isEnglish == NO){
        if([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
            [self.view setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
    }else {
        if([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
            [self.view setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
    }
    
    
    [super viewDidLoad];
    [self updateUI];
    [GIDSignIn sharedInstance].delegate = self;
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    signin.shouldFetchBasicProfile = true;
    signin.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    UIInterfaceOrientation ori =  [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(ori);
    
    if(isLandscape)
    {
        self.centreDist.constant = 9;
        self.topCentreDist.constant = 0;
        /*
        self.centreDist.constant = -40;
        self.topCentreDist.constant = -20;
         */
    }else if(UIInterfaceOrientationIsPortrait(ori)){
        /*
        self.centreDist.constant = 9;
        self.topCentreDist.constant = 0;
        */
        self.centreDist.constant = -80;
        self.topCentreDist.constant = -20;

    }
}
-(void) gotGoogleSingup:(NSNotification *) notif{
    
    if([notif.object isKindOfClass:[NSError class]]){
        // ALERT
        return;
    }
    
    DataClass *obj=[DataClass getInstance];
    obj.userToken=  [notif.object valueForKey:@"userToken"];
    
    NSLog(@"no  error signed in successfully");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:obj.userToken forKey:@"userToken"];
    [defaults synchronize];
    DataClass *userObj = [DataClass getInstance];
    userObj.userToken= obj.userToken;
    [self loadEditProfilePage];
//    self.hidesBottomBarWhenPushed  = NO;
//    UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
//    [self.navigationController pushViewController:tbc animated:YES];
}

-(void)loadEditProfilePage{
    EditProfileViewController *editPro = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    editPro.isFromSocialLogin = YES;
    //   editPro.hidesBottomBarWhenPushed = true;
    //  [self.navigationController.navigationBar setHidden:false];
    [self.navigationController pushViewController:editPro animated:true];
}

- (void) gotBayieAPIDatafb:(NSNotification *) notification{
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
                NSString *userToken = responseDict[@"userToken"];
                NSLog(@"%@ in loginvc fb login ", userToken);
                DataClass *userObj = [DataClass getInstance];
                userObj.userToken= userToken;
                UIAlertController * alert =[UIAlertController
                                            alertControllerWithTitle:@"Bayie" message:responseDict[@"data"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* okButton = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               [hud hideAnimated:YES];
                                                [self loadEditProfilePage];
//                                               UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
//                                               tbc.selectedIndex=0;
//
//                                               [self.navigationController pushViewController:tbc animated:YES];
                                               
                                           }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
            [hud hideAnimated:YES];

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

-(UIStoryboard *) getStroyBoard{
    UIStoryboard *storyboard;
    // assume english
    
     NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        NSString  *path = [[NSBundle mainBundle] pathForResource:@"ar" ofType:@"lproj"];
        if([DataClass isiPad]){
            storyboard = [UIStoryboard storyboardWithName:@"MainAriPad" bundle:[NSBundle mainBundle]];
            return storyboard;
        }else{
            
            storyboard = [UIStoryboard storyboardWithName:@"MainAr" bundle:[NSBundle mainBundle]];
            return storyboard;
            
        }
        
    }else{
    //if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"en"]])
        NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];

    if([DataClass isiPad]){
        storyboard = [UIStoryboard storyboardWithName:@"MainEniPad" bundle:[NSBundle mainBundle]];
        return storyboard;
    }else{
        
        storyboard = [UIStoryboard storyboardWithName:@"MainEn" bundle:[NSBundle mainBundle]];
        return storyboard;
        
    }
    }
}

-(void) checkAndXfer{
    NSString *userToken;
    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    
    userToken = [pref objectForKey:@"userToken"];
    
    if(userToken !=nil){
        DataClass *dataObj=[DataClass getInstance];
        dataObj.userToken =userToken;
        UIStoryboard *storyboard = [self getStroyBoard];
        UITabBarController *tbc = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
        tbc.selectedIndex=0;
        [self.navigationController pushViewController:tbc animated:YES];
         // presentViewController:tbc animated:YES completion:nil];
    }
    
}
-(void) checkLogout{
    NSString *logo;
    NSUserDefaults * pref = [NSUserDefaults standardUserDefaults];
    
    logo = [pref objectForKey:@"logout"];
    if(logo !=nil ){
        [pref removeObjectForKey:@"logout"];
        [pref synchronize];
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}


-(void)updateUI{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-choose-Screen-bg"]];
    
    [_googleButton.layer setBorderWidth:0.3];
    [_googleButton.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [_googleButton setTintColor:[UIColor whiteColor]];
    _titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"BUY_AND_SELL_ANYTHING_AT_YOUR_CONVENIENCE", nil), @(1000000)];
      [_googleButton setTitle:NSLocalizedString(@"CONNECT_WITH_GOOGLE", nil) forState:UIControlStateNormal];
      [_loginButton setTitle:NSLocalizedString(@"LOGIN", nil) forState:UIControlStateNormal];
      [_facebookButton setTitle:NSLocalizedString(@"CONNECT_WITH_FACEBOOK", nil) forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)loginWithFB:(id)sender {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:@"id,email,first_name,last_name,name,picture{url}" forKey:@"fields"];

    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            if ([result.grantedPermissions containsObject:@"email"]) {
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if ([result objectForKey:@"email"]) {
                             NSLog(@"Email : %@",[result objectForKey:@"email"]);
                             NSLog(@"Name : %@",[result objectForKey:@"name"]);
                             NSLog(@"Uid : %@",[result objectForKey:@"id"]);
                             NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                        //     NSURL *url = [[NSURL alloc] initWithURL: imageStringOfLoginUser];
                             
                             NSURL *url = [NSURL URLWithString:imageStringOfLoginUser];
                             NSLog(@"URL : %@",url);
                          hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                          hud.mode = MBProgressHUDModeIndeterminate;
                          hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
                             NSString *UUID = [[NSUUID UUID] UUIDString];
                             
                             NSDictionary *parameters =  @{@"name":[result objectForKey:@"first_name"],@"email":[result objectForKey:@"email"],@"uid":[result objectForKey:@"id"],@"provider":@"facebook",@"imageUrl":imageStringOfLoginUser,@"deviceId":UUID};
                             NSError *error;
                             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
                             NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                              [[NSNotificationCenter defaultCenter]  removeObserver:self];
                              [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDatafb:) name:@"BayieResponse" object:nil];
                             [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"socialLogin"];

                               }
                         if (!error) {
                             NSLog(@"fetched user:%@", result);
                            }
                     }];
                }
            }
        }
    }];
    

}
- (IBAction)loginWithGoogle:(id)sender {
    
    [GIDSignIn sharedInstance].clientID =@"525723061050-sp9u794l9p9p5sc5987qghte48cfj44d.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate=self;
    
    
    [GIDSignIn sharedInstance].uiDelegate=self;
    [[GIDSignIn sharedInstance] signIn];

}
- (IBAction)skipButtonAction:(UIButton *)sender {
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    _guser = user;
    //user signed in
    //get user data in "user" (GIDGoogleUser object)
    
    if (error == nil) {
    //    GIDAuthentication *authentication = user.authentication;
        
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        NSString *givenName = user.profile.givenName;
        NSString *familyName = user.profile.familyName;
        NSString *email = user.profile.email;
        NSURL *userImage=[[NSURL alloc] init];
        if(user.profile.hasImage)
            userImage = [user.profile imageURLWithDimension:100 ];
        
        NSLog(@"%@UID is", userId);
        NSLog(@"%@name is", fullName);
        NSLog(@"%@emailll is", email);
        [[NSNotificationCenter defaultCenter]  removeObserver:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotGoogleSingup:) name:@"BayieResponse" object:nil];
       
        
        NSString *UUID = [[NSUUID UUID] UUIDString];
        
        NSDictionary *parameters =  @{@"name":fullName,@"email":email,@"uid":userId,@"provider":@"google",@"imageUrl":[userImage absoluteString],@"deviceId":UUID};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"socialLogin"];
        
        NSLog(@"token for gooogleeeeeeeee");

        NSLog(@"%@", user.authentication.idToken);
        DataClass *obj=[DataClass getInstance];
        obj.userToken=  user.authentication.idToken;
         NSLog(@"no  error signed in successfully");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:user.authentication.idToken forKey:@"Token"];
        [defaults synchronize];
        self.hidesBottomBarWhenPushed  = NO;
        
        UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
        tbc.selectedIndex=0;

      //  UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
//        tbc.selectedIndex=0;
//        [self presentViewController:tbc animated:YES completion:nil];
        } else {
            NSLog(@"%@", error);
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

@end
