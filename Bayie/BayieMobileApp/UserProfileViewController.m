//
//  UserProfileViewController.m
//  BayieMobileApp
//
//  Created by Ajeesh T S on 28/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//
#import "Utility.h"
#import "UserProfileViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "DataClass.h"
#import "UserProfile.h"
#import "UserProfileTableViewCell.h"
#import "PostAdvertisementViewController.h"
#import <DKImagePickerController/DKImagePickerController-Swift.h>
#import "MyChatsViewController.h"
#import "AdDetailedViewController.h"
#import "SavedSearchViewController.h"
#import "MyAdsViewController.h"
#import "EditProfileViewController.h"
#import "FavoritesViewController.h"
#import "MyAdsViewController.h"
#import "LoginViewController.h"
#import "AboutUsViewController.h"
#import "BayieHub.h"
#import "FeedbackAndSupportViewController.h"
#import "AppDelegate.h"

#import "BidHistoryVC.h"
#import "WinHistoryVC.h"


@interface UserProfileViewController (){

    UserProfile *myProfile;
    MBProgressHUD *hud;

}
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	if ([self.profileTableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.profileTableView setSeparatorInset:UIEdgeInsetsZero];
	}

     self.tabBarController.delegate = self;
//    self.tabBarController.delegate = self;
    self.profileTableView.tableFooterView = [UIView new];
    [self configureView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataProfileLoad:) name:@"BayieResponse" object:nil];

    [self.navigationController.navigationBar setHidden:true];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.01 green:0.69 blue:0.69 alpha:1]];
//    [self.navigationController.navigationBar setTranslucent:NO];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor  =  [UIColor colorWithRed:0 green:0.69 blue:0.69 alpha:1];
	self.view.backgroundColor = statusBarView.backgroundColor ;
    [self.view addSubview:statusBarView];
    [self getProfileDataFromServer];
}



- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (tabBarController.selectedIndex == 2){
        //        [self showImagePicker];
    }
    return YES;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Force your tableview margins (this may be a bad idea)
//    if ([self.profileTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.profileTableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//
//    if ([self.profileTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.profileTableView setLayoutMargins:UIEdgeInsetsZero];
//    }
}


#pragma mark - TableView Delegate and Datasource


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
	
    // Prevent the cell from inheriting the Table View's margin settings
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
	
    // Explictly set your cell's layout margins
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
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

         
         [self.profileTableView reloadData];
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

-(void)showImagePicker{
    DKImagePickerController *pickerController = [DKImagePickerController new];
    pickerController.assetType = DKImagePickerControllerAssetTypeAllAssets;
    pickerController.showsCancelButton = YES;
    pickerController.showsEmptyAlbums = YES;
    pickerController.allowMultipleTypes = YES;
//    if (self.assets.count > 0){
//        pickerController.defaultSelectedAssets = self.assets;
//    }else{
        pickerController.defaultSelectedAssets = @[];
//    }
    pickerController.maxSelectableCount = 4;
    pickerController.sourceType = DKImagePickerControllerSourceTypeBoth;
    //  pickerController.assetGroupTypes    // unavailable
    //  pickerController.defaultAssetGroup  // unavailable
    
    [pickerController setDidSelectAssets:^(NSArray * __nonnull assetsDetails) {
        NSLog(@"didSelectAssets");
        if (assetsDetails){
            if (assetsDetails.count > 0){
                //                self.addImageButton.hidden = true;
//                self.assets = assetsDetails;
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AdCategory" bundle:[NSBundle mainBundle]];
                PostAdvertisementViewController *postAdViewController = [storyboard instantiateViewControllerWithIdentifier:@"PostAddVC"];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postAdViewController];
                postAdViewController.assets = assetsDetails;
                [self presentViewController:nav animated:true completion:nil];
            }else{
               
            }
        }
    }];
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)configureView{
    
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                          [UIColor colorWithRed:0.01 green:0.69 blue:0.69 alpha:1], NSForegroundColorAttributeName,
//                                                           shadow, NSShadowAttributeName,
//                                                           [UIFont systemFontOfSize:16.0], NSFontAttributeName, nil]];
    
//    UIApplication *app = [UIApplication sharedApplication];
//    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
//    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
//    statusBarView.backgroundColor  =  [UIColor colorWithRed:0 green:0.69 blue:0.69 alpha:1];
//    [self.view addSubview:statusBarView];
//    [self navigationCustomization];
//    self.navigationController.tintc
}

-(void)navigationCustomization{
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                            imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self
                                                                    action:@selector(backBtnClicked)];
    self.navigationItem.leftBarButtonItem = myBackButton;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( myProfile ){
        DataClass *dataClass = [DataClass getInstance];
        if(dataClass.userToken==nil)
            return 0;
        else
            return 11;
    }else {
        return 0;
    }
    
}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 274;
    }
    else if (indexPath.row == 10) {
        return 103;
    }
    else {
        return 51;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    if (indexPath.row == 0){
                UserProfileTableViewCell *profileCell = [self.profileTableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
        if (myProfile.profileImage){
            [profileCell.profileImageView sd_setImageWithURL:[NSURL URLWithString:myProfile.profileImage]];
        }
        [profileCell.calBtn setEnabled:myProfile.mobile_verified];
        [profileCell.mailBtn setEnabled:myProfile.email_verified];
        [profileCell.fbBtn setEnabled:myProfile.facebook_verified];
        [profileCell.googleBtn setEnabled:myProfile.google_verified];
//				profileCell.separatorInset =   UIEdgeInsetsMake(0.f, self.view.frame.size.width, 0.f, 0.f);

        if (myProfile.name){
            profileCell.nameLbl.text = myProfile.name;
        }

        cell = profileCell;
    }else{
        UITableViewCell *listCell = [self.profileTableView dequeueReusableCellWithIdentifier:@"ProfileListCell"];
        switch (indexPath.row) {
            case 1:
                listCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MY_ADS", nil), @(1000000)];
                break;
            case 2:
                listCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MY_PROFILE", nil), @(1000000)];
                break;
            case 3:
                listCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MY_FAVORITES", nil), @(1000000)];
                break;
            case 4:
                listCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MY_CHATS", nil), @(1000000)];

                break;
            case 5:
                listCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"MY_SAVED_SEARCHES", nil), @(1000000)];
                break;
            case 6:
                listCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"BidHistory", @"Bid History"), @(1000000)];
                break;
            case 7:
                listCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"WinHistory", @"Win History"), @(1000000)];
                break;
            case 8:
                listCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"FEEDBACK_AND_SUPPORT", nil), @(1000000)];

                break;
            case 9:
                listCell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ABOUT", nil), @(1000000)];
                break;
            case 10:
                listCell = [self.profileTableView dequeueReusableCellWithIdentifier:@"LogoutCell"];
                break;
                
            default:
                break;
        }
        cell = listCell;
    }

    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        id cont;
        if(self.navigationController != nil)
            cont = self.navigationController;
        else
            cont = self.tabBarController.navigationController;
        if (indexPath.row == 1){
            //  MyAdsViewController *myads = [[UIStoryboard storyboardWithName:self.storyboard bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MyAdsViewController"];
            MyAdsViewController *myads =  [self.storyboard instantiateViewControllerWithIdentifier:@"MyAdsViewController"];
            //   myads.hidesBottomBarWhenPushed = true;
            //        [self.navigationController.navigationBar setHidden:false];
            [self.navigationController pushViewController:myads animated:true];
            //   [self.storyboard instantiateViewControllerWithIdentifier:@"BrowseViewController"];
        }
        
        if (indexPath.row == 2){
            //  EditProfileViewController *editPro = [[UIStoryboard storyboardWithName:self.storyboard bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
            EditProfileViewController *editPro = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
            //   editPro.hidesBottomBarWhenPushed = true;
            //  [self.navigationController.navigationBar setHidden:false];
            [self.navigationController pushViewController:editPro animated:true];
        }
        if (indexPath.row == 3){
            FavoritesViewController *fav = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
            fav.fromProfile = true;
            //  fav.hidesBottomBarWhenPushed = true;
            //      [self.navigationController.navigationBar setHidden:false];
            [self.navigationController pushViewController:fav animated:true];
        }
        if (indexPath.row == 4){
            MyChatsViewController *myChats = [[UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"chats"];
            //        myChats.hidesBottomBarWhenPushed = true;
            //[self.navigationController.navigationBar setHidden:true];
            [self.navigationController pushViewController:myChats animated:true];
        }if (indexPath.row == 5){
            SavedSearchViewController *savdSearch = [self.storyboard instantiateViewControllerWithIdentifier:@"SavedSearchViewController"];
            //   savdSearch.hidesBottomBarWhenPushed = true;
            //    [self.navigationController.navigationBar setHidden:false];
            [self.navigationController pushViewController:savdSearch animated:true];
        }if (indexPath.row == 6){ //Bid History
            BidHistoryVC *bidHistoryVC = [[BidHistoryVC alloc] initWithNibName:@"BidHistoryVC" bundle:nil];
            UINavigationController *bidHistoryNavVC = [[UINavigationController alloc] initWithRootViewController:bidHistoryVC];
            [self presentViewController:bidHistoryNavVC animated:true completion:nil];
        }
        if (indexPath.row == 7){ //Win History
            WinHistoryVC *winHistoryVC = [[WinHistoryVC alloc] initWithNibName:@"WinHistoryVC" bundle:nil];
            UINavigationController *winHistoryNavVC = [[UINavigationController alloc] initWithRootViewController:winHistoryVC];
            [self presentViewController:winHistoryNavVC animated:true completion:nil];
        }
       if (indexPath.row == 8){
            FeedbackAndSupportViewController *feedBack = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackAndSupportViewController"];
            [self.navigationController pushViewController:feedBack animated:true];
            
        }if (indexPath.row == 9){
            AboutUsViewController *abt = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
            abt.webViewType = WebViewTypeAboutUs;
            [self.navigationController pushViewController:abt animated:true];
            
        }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
/*
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
        req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
                    
                    if (![responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                        
                        
                    }else if([responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                        
                        myProfile = [[UserProfile alloc] initWithDictionary:responseDict[@"data"]];
                        DataClass *dataObj1=[DataClass getInstance];
                        dataObj1.userId = myProfile.idField;

                        [self.profileTableView reloadData];
                    }
                }
            } else {
                
                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
//                                                                message:error
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
            }
            [hud hideAnimated:YES];
        }]resume];
    */
}

// IBActions

-(IBAction) logout:(id)sender{
    DataClass *dataObj=[DataClass getInstance];
    dataObj.userId = nil;
    dataObj.userToken = nil;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   NSArray *arr  = [self.tabBarController.navigationController viewControllers];
    if (arr == nil){
        arr = [self.navigationController viewControllers];
    }

    //[self.tabBarController.navigationController viewControllers];
   // [self.navigationController viewControllers];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"userToken"];
//    [defaults removeObjectForKey:@"AppleLanguages"];

    [defaults synchronize];
    
    for(int i =0; i< [arr count]; i++){
        id cont = [arr objectAtIndex:i];

        if([cont isKindOfClass:[LoginViewController class]] ){
           [defaults setObject:@"logout" forKey:@"logout"];// marker indicating logout - dunno -just guessing that might be need
            [defaults synchronize];
            NSString *test = [defaults objectForKey:@"userToken"];
            NSLog(@"user in prooo%@", test);
        
            //    LoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];

            //    [self.navigationController pushViewController:controller animated:YES];

         //   [self.tabBarController.navigationController popToViewController:cont animated:NO];
            
//            [self.navigationController popToViewController:cont animated:NO];
            
            
            
        }else{
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            [appDelegate performSelector:@selector(setLaunchScreen)];
        }
        [appDelegate performSelector:@selector(setLaunchScreen)];
        [self.navigationController popToRootViewControllerAnimated:true];
    }
    
/*
    LanguageSelectorViewController *lanviewController = [[LanguageSelectorViewController alloc] initWithNibName:[DataClass loadXIBBasedOnDevice:@"LanguageSelector"] bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lanviewController];
    lanviewController.navigationController.navigationBarHidden=YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = navController;
    
*/
  //  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lanviewController];
  //  lanviewController.navigationController.navigationBarHidden=YES;
/*

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainEn" bundle:[NSBundle mainBundle]];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    loginViewController.navigationController.navigationBarHidden=YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = navController;
     
   */

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
