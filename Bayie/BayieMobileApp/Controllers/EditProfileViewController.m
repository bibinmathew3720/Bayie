//
//  EditProfileViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 20/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataClass.h"
#import "VerifyOTPViewController.h"
#import "BayieHub.h"
#import "UserProfile.h"
#import "ChangePasswordViewController.h"

@interface EditProfileViewController ()
{
    NSDictionary *updateProfiledataDict;
    NSArray *updateProfileddataArray;
    MBProgressHUD *hud;
    NSArray *loadProfileData;
    NSString *profileLoad_imageUrl;
    NSString *profileLoad_defaultimageUrl;
    NSString *selectedLan;

    UserProfile *myProfileload;
  //  DownPicker *dp;

}
@end

@implementation EditProfileViewController

@synthesize lastapiCallPro;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emailTextField.tintColor = [UIColor blackColor];
    self.nameTextField.tintColor = [UIColor blackColor];
    self.locationTextField.tintColor = [UIColor blackColor];
    self.phoneTextField.tintColor = [UIColor blackColor];
    
    self.langChanged = NO;
    self.editProfileImage.layer.cornerRadius = self.editProfileImage.frame.size.height/2;
    self.editProfileImage.clipsToBounds = YES;
    self.editProfileImage.layer.borderWidth = 0;
    
    self.imgButton.layer.cornerRadius = self.imgButton.frame.size.height/2;
    self.imgButton.clipsToBounds = YES;
    self.imgButton.layer.borderWidth = 0;
    
    _languageTextField.placeholder = [DataClass currentLanguageString];
    self.lastapiCallPro = @"loadPro";

   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPI:) name:@"BayieResponse" object:nil];
    
    NSMutableArray* lanArray = [[NSMutableArray alloc] init];
    
    [lanArray addObject:@"English"];
    [lanArray addObject:@"Arabic"];
    
    self.downPicker = [[DownPicker alloc] initWithTextField:self.languageTextField withData:lanArray];
    
    [self.downPicker addTarget:self
                            action:@selector(lan_Selected:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.downPicker setArrowImage:[UIImage imageNamed:@"cart-black"]];
    [self.downPicker showArrowImage:true];
    [self.downPicker setPlaceholder:[DataClass currentLanguageString]];
    [self loadProfile];
}

-(void)lan_Selected:(id)dp {
   selectedLan = [self.downPicker text];
    NSLog(@"%@selected languageeee  ", selectedLan);
    if(![selectedLan isEqualToString:@"English"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie" message:@"Do you want to change the language to Arabic ?" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alert.tag = 100;

        [alert setDelegate:self];
        [alert show];

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie" message:@"Do you want to change the language to English ?" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alert.tag = 100;

        [alert setDelegate:self];
        [alert show];
        
    }
  
}
//-(void)viewDidAppear:(BOOL)animated{
//    NSMutableArray* bandArray = [[NSMutableArray alloc] init];
//    
//    // add some sample data
//    [bandArray addObject:@"English"];
//    [bandArray addObject:@"Arabic"];
//    
//    // bind yourTextField to DownPicker
//    self.downPicker = [[DownPicker alloc] initWithTextField:self.languageTextField withData:bandArray];
//}
-(void)loadProfile{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];

    DataClass *tknobj=[DataClass getInstance];
    NSLog(@"%@", tknobj.userToken);
   // NSDictionary *parameters =  @{@"userToken":tknobj.userToken};
    NSDictionary *parameters =  @{@"userToken":tknobj.userToken};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"profileData"];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) gotBayieAPI:(NSNotification *) notification{
    //if at any time notfi.object is error or null hide the HUD
    if([lastapiCallPro isEqualToString:@"loadPro"]){
        [self gotBayieAPIDataLoadProfile:notification];
    }else if([lastapiCallPro isEqualToString:@"updateProfile"] ){
        [self gotBayieAPIDataUpdateProfile:notification];
    }else if([lastapiCallPro isEqualToString:@"changeImg"] ){
        [self gotBayieAPIDataUpdateImage:notification];
    }
}


- (IBAction)updateProfileButton:(id)sender {
    
    self.lastapiCallPro = @"updateProfile";

    [self profileUpdate];
}

-(void)profileUpdate{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];

    NSString *lan;
    if([selectedLan isEqualToString:@"English"]){
        lan = @"1";
    }else{
        lan = @"2";
    }
    DataClass *tknobj=[DataClass getInstance];
    NSLog(@"%@", tknobj.userToken);
    NSDictionary *parameters =  @{@"userToken":tknobj.userToken,@"name":_nameTextField.text,@"mobile":_phoneTextField.text,@"email":_emailTextField.text,@"location":_locationTextField.text,@"language":lan};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"profileUpdate"];
   
}
- (void) gotBayieAPIDataLoadProfile:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        
        NSDictionary *responseDict = notification.object;
        NSString *errormsg = responseDict[@"error"];
     //   NSString *data = responseDict[@"data"];
        if ( [errormsg isEqualToString:@""])               {
           
            myProfileload = [[UserProfile alloc] initWithDictionary:responseDict[@"data"]];

            if (myProfileload.profileImage){
                [self.editProfileImage sd_setImageWithURL:[NSURL URLWithString:myProfileload.profileImage]];
            }else{
                if([responseDict[@"profileDefualtImg"] isKindOfClass:[NSString class]]){
                    
                    
                    [self.editProfileImage sd_setImageWithURL:[NSURL URLWithString:[responseDict objectForKey:@"profileDefualtImg"]]];
                    
                    
                 //   myProfileload.profileImage = [responseDict objectForKey:@"profileDefualtImg"];
                }
            }
            
//            if (myProfileload.profileImage){
//                [self.editProfileImage sd_setImageWithURL:[NSURL URLWithString:myProfileload.profileImage]];
//            }
            if (myProfileload.name){
                self.nameTextField.text = myProfileload.name;
            }
            if (myProfileload.location){
                self.locationTextField.text = myProfileload.location;
            }
            if (myProfileload.emailId){
                self.emailTextField.text = myProfileload.emailId;
            }
            if (myProfileload.phoneNumber){
                self.phoneTextField.text = myProfileload.phoneNumber;
            }
//            if (myProfileload.language){
//                if([myProfileload.language isEqualToString:@"0"]){
//                    self.languageTextField.text = @"English";
//                    selectedLan = @"English";
//                }else{
//                         self.languageTextField.text = @"Arabic";
//                         selectedLan = @"Arabic";
//                    }
//            }
            [hud hideAnimated:YES];
      
                       }else if (![errormsg isEqualToString:@""]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message:errormsg
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        [hud hideAnimated:YES];
    }
}
- (void) gotBayieAPIDataUpdateProfile:(NSNotification *) notification
{ [hud hideAnimated:YES];
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
        NSString *data = responseDict[@"data"];
        
        if ( [errormsg isEqualToString:@""])               {
            
            if (![_phoneTextField.text  isEqualToString: @""]){
                //&& [_emailTextField.text  isEqualToString: @""] ) {
                NSString *mobileToken = responseDict[@"mobileToken"];
                NSLog(@"%@", mobileToken);
                
                if(![mobileToken  isEqual: @""]){
                
                DataClass *mobObj = [DataClass getInstance];
                mobObj.mobleToken= mobileToken;
                
                UIAlertController * alert =[UIAlertController
                                            alertControllerWithTitle:@"Bayie" message:responseDict[@"data"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okButton = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               
                                               [self performSegueWithIdentifier:@"VerificationFromUpdateProfile" sender:self];
                                           }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
                }else{
                    if(_langChanged == YES){
                    UIAlertController * alert =[UIAlertController
                                                alertControllerWithTitle:@"Bayie" message:@"To change language please relaunch the app" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* okButton = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                  [self cleanLoc]; 
                                                   exit(0);
                                               }];
                    [alert addAction:okButton];
                    [self presentViewController:alert animated:YES completion:nil];
                    }
                }
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                                message:data
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }else if (![errormsg isEqualToString:@""]){
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: errormsg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           if( !([errormsg rangeOfString: @"Mobile Number already exist"].location == NSNotFound  )   ){
//                                               subcatArrayList = [[NSMutableArray alloc] init];
                                               //    [self.navigationController popViewControllerAnimated:YES];
                                               NSLog(@"To change the language please re launch the app");
                                               exit(0);
                                           }
                                           
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
    
}
- (void) gotBayieAPIDataUpdateImage:(NSNotification *) notification
{ [hud hideAnimated:YES];
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
                                           [self cleanLoc];
                                           //    [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [hud hideAnimated:YES];
            
            return;
        }
        
        NSDictionary *responseDict = notification.object;
        NSString *errormsg = responseDict[@"error"];
            NSString *data = responseDict[@"data"];
        
                if ( [errormsg isEqualToString:@""]){
                    
                        UIAlertController * alert =[UIAlertController
                                                    alertControllerWithTitle:@"Bayie" message:responseDict[@"data"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* okButton = [UIAlertAction
                                                   actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                                                   {
                                                      [self cleanLoc]; 
                                                     
                                                   }];
                    
                        [alert addAction:okButton];
                        [self presentViewController:alert animated:YES completion:nil];
                    [hud hideAnimated:YES];

                  
                        
                }else if (![errormsg isEqualToString:@""]){
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                                    message:errormsg
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [hud hideAnimated:YES];

                }
        [hud hideAnimated:YES];

            }
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"VerificationFromUpdateProfile"]) {
        UINavigationController *nav = segue.destinationViewController;
        VerifyOTPViewController *dest = (VerifyOTPViewController *)nav.topViewController;
        dest.mobileNo = _phoneTextField.text;
    }
     if ([segue.identifier isEqualToString:@"ChangePassword"]) {
   //      ChangePasswordViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
         
         UINavigationController *nav = segue.destinationViewController;
         ChangePasswordViewController *dest = (ChangePasswordViewController *)nav.topViewController;
         [self.navigationController pushViewController:dest animated:YES];
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


- (IBAction)changeImageButton:(id)sender {
  
    self.lastapiCallPro = @"changeImg";

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
/*
   
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSData *pngData = UIImagePNGRepresentation(_editProfileImage.image);

//    DataClass *tknobj=[DataClass getInstance];
//    NSLog(@"%@", tknobj.userToken);
    NSDictionary *parameters =  @{@"file":pngData,@"filename":@"abc.jpeg"};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
  //  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonData :@"changeProfileImage"];
    */
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
//  NSURL *path = [editingInfo valueForKey:UIImagePickerControllerReferenceURL];
  //  NSLog(@"image pathhh  %@", path);
    _editProfileImage.image=image;
    [self saveImage:image];
}

- (void)saveImage: (UIImage*)image
{
    [[NSNotificationCenter defaultCenter ] removeObserver:self] ;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPI:) name:@"BayieResponse" object:nil];
    if (image != nil)
    {
         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
        NSData *imageData = UIImageJPEGRepresentation(image,1.0);
        [imageData writeToFile:savedImagePath atomically:NO];
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
        NSData *pngData = UIImagePNGRepresentation(_editProfileImage.image);
        //savedImage.png
        //    DataClass *tknobj=[DataClass getInstance];
        //    NSLog(@"%@", tknobj.userToken);
      //  NSDictionary *parameters =  @{@"file":pngData,@"filename":@"abc.jpeg"};
    //    NSError *error;
     //   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        //  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[BayieHub sharedInstance] PostrequestcallServiceWith:nil :@"changeProfileImage"];
        
    }
}


//Selecting the image uploading way.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            break;
        case 1:
            [self choosePhotoFromExistingImages];
        default:
            break;
    }
}

// Load camera image
- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

// Choosing image from photo library
-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (IBAction)backButton:(id)sender {
    
      [self.navigationController popViewControllerAnimated:YES];
   // [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)changePassword:(id)sender {
    
    [self performSegueWithIdentifier:@"ChangePassword" sender:self];

}
-(void) cleanLoc{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"lastLocStr"];
    
    [defaults removeObjectForKey:@"lastLocID"];
    [defaults synchronize];

}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100) {

    if ([selectedLan  isEqual: @"Arabic"])
    {
    if (buttonIndex == 0){
        NSLog(@"arabic");
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.lastapiCallPro = @"updateProfile";
        self.langChanged = YES;
        [self profileUpdate];
        
        
        
        // have to call profile update api here.
      //  exit(0);
    }else {
        NSLog(@"english,dnn wnt to chnge"); // no btn
              [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // have to call profile update api here.
      //  exit(0);

    }
    }else if([selectedLan  isEqual: @"English"]){
        
        if (buttonIndex == 0){
            NSLog(@"english");
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // have to call profile update api here.
            self.lastapiCallPro = @"updateProfile";
            self.langChanged = YES;
            [self profileUpdate];

         //   exit(0);
        }else {
            NSLog(@"arabic, dnn wnt to change"); // no btn
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil] forKey:@"AppleLanguages"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // have to call profile update api here.
            //  exit(0);
            
        }

        
    }
}
    
    
    
}

@end
