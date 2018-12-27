//
//  BrowseViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 29/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#define deviceTokenKey @"deviceToken"

#import "BrowseViewController.h"
#import "AFNetworking.h"
#import "DataClass.h"
#import "MBProgressHUD.h"
#import "ListingViewController.h"
#import "AdDetailedViewController.h"
#import "BayieHub.h"
#import "SeachLocationViewController.h"
#import "UserProfile.h"
#import "Utility.h"
#import "CategoryViewController.h"


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


@interface BrowseViewController ()<UITabBarControllerDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray *catDataArray;
    NSDictionary *catDataDict;
    NSString *catName;
    NSString *catId;
    NSString *catbase_imageUrl;
    NSString *catbase_defaultimageUrl;
    MBProgressHUD *hud;
    UserProfile *myProfileload;
    
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;

//For Auction
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *locationTouchButton;
@property (weak, nonatomic) IBOutlet UILabel *locSelectionLabel;

@end

@implementation BrowseViewController

@synthesize lastCall,task ;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colHeight = -1;
    //To show status bar
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self setLocationLabels];
    NSLog(@"Selected index:%d",self.tabBarController.selectedIndex);
    [_categoryCollectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    // Adding Google AD
//    self.bannerView.adUnitID = @"ca-app-pub-3310088406325999/3684441066";
//    self.bannerView.rootViewController = self;
    
    [self.tabBarController.tabBar  setItemWidth:self.tabBarController.view.window.frame.size.width/5];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastLocText = [defaults objectForKey:@"lastLocStr"];
    DataClass *tknobj=[DataClass getInstance];
    
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    NSString *lan=@"English";
    tknobj.isEnglish = YES;
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        lan = @"Arabic";
        tknobj.isEnglish = NO;
    }
    
    if(lastLocText != nil){
        self.locSelectionLabel.text = lastLocText;
        tknobj.lastKnownLoc =lastLocText;
        tknobj.lastKnownLocID = [defaults objectForKey:@"lastLocID"];
    }
    
    [self.categoryCollectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:NULL];
    
    self.tabBarController.delegate = self;
    [self updateUI];
    [self googleLocationUpdate];
    [_categoryCollectionView.collectionViewLayout invalidateLayout];
    
    self.view.setNeedsLayout;
}

-(void)setLocationLabels{
    if (self.tabBarController.selectedIndex == 0) {
        self.headingLabel.text = NSLocalizedString(@"Ads", @"Ads");
        self.pageType = PageTypeAds;
    }
    else if (self.tabBarController.selectedIndex == 1) {
        self.headingLabel.text = NSLocalizedString(@"Auctions", @"Auctions");
        self.pageType = PageTypeAuctions;
        self.locationArrowButton.hidden = YES;
        self.locationTouchButton.hidden = YES;
        self.locSelectionLabel.hidden = YES;
    }
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if(![self isLoggedIn]){
        if(viewController == [[self.tabBarController viewControllers] objectAtIndex:3]){
            [Utility showLogInAlertInController:self];
            return NO;
        }
        else if (viewController == [[self.tabBarController viewControllers] objectAtIndex:4]){
            [Utility showLogInAlertInController:self];
            return NO;
        }
        else
            return YES;
    }
    else
        return YES;
}

-(BOOL)isLoggedIn{
    DataClass *dataCllas = [DataClass getInstance];
    if(dataCllas.userToken!=nil)
        return YES;
    else
        return NO;
}
-(void)callingRegisterDeviceTokenApi{
    DataClass *dataClass = [DataClass getInstance];
    if(dataClass.userToken!=nil){
        NSString *deviceTokenstring = [[NSUserDefaults standardUserDefaults] objectForKey:deviceTokenKey];
        if(deviceTokenstring!=nil){
            NSDictionary *parameters =  @{@"gcmRegistrationId" :deviceTokenstring,@"deviceType":@"ios"};
            NSLog(@"Auth Token:%@",dataClass.userToken);
            NSError *error;
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"updateDeviceToken"];
        }
    }
}

-(BOOL)hidesBottomBarWhenPushed
{
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context
{
    // You will get here when the reloadData finished
    [hud hideAnimated:YES];
    
}


- (void)dealloc
{
    [self.categoryCollectionView removeObserver:self forKeyPath:@"contentSize" context:NULL];
}


-(void)viewWillAppear:(BOOL)animated{
    [_categoryCollectionView setContentOffset:CGPointZero animated:YES];
    [self googleLocationUpdate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastLocText = [defaults objectForKey:@"lastLocStr"];
    DataClass *locOb=[DataClass getInstance];
    if(lastLocText != nil){
        NSString *firstWord = [[lastLocText componentsSeparatedByString:@","] objectAtIndex:0];
        _locSelectionLabel.text = firstWord;
        
        self.locSelectionLabel.text = firstWord;
        locOb.lastKnownLoc =lastLocText;
        locOb.lastKnownLocID = [defaults objectForKey:@"lastLocID"];
        
    }
    else{
        _locSelectionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LOCATION_SELECTION", nil), @(1000000)];
    }
    self.bannerViewHeightConstraint.constant = 0;
    
    
    [self updateUI];
    locOb.filterLoc = @"";
    
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieData:) name:@"BayieResponse" object:nil];
    
    //    _testbool = false;
    [self.categoryCollectionView reloadData];
    [super viewWillAppear:animated];
    self.lastCall = @"catList";
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieData:) name:@"BayieResponse" object:nil];
    [self catList];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.categoryCollectionView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.categoryCollectionView reloadData];
}
-(void) showError:(NSString *) msg{
    
    NSString *ms = msg;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                    message: msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    if(hud != nil )
        [hud hideAnimated:YES];
}
// Update location to last known location

-(void)googleLocationUpdate{
    DataClass *locOb=[DataClass getInstance];
    locOb.filterLoc = @"";
    
    if(locOb.lastKnownLoc != nil && (locOb.lastKnownLocID != nil)){
       NSString *firstWord = [[locOb.lastKnownLoc componentsSeparatedByString:@","] objectAtIndex:0];
        _locSelectionLabel.text = firstWord;
    }else{
        _locSelectionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LOCATION_SELECTION", nil), @(1000000)];
    }
    
}


// Updating UI

-(void)updateUI{
    
   
  
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:177/255.0 blue:176/255.0 alpha:1]];
    
    UITabBarController *tabBarController = self.tabBarController;
    tabBarController.tabBar.alpha = 3.0;
    
    UITabBarItem *postAdTab = [tabBarController.tabBar.items objectAtIndex:2];
    
    [postAdTab setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Lato-Regular" size:10.0f], NSFontAttributeName,  [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
        postAdTab.image = [[UIImage imageNamed:@"camera-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        postAdTab.selectedImage = [[UIImage imageNamed:@"camera-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

-(void)locationUpdate{
    NSError *error;
    DataClass *locOb=[DataClass getInstance];
    
    if(locOb.latitude != nil && locOb.longitude !=nil){
        
        NSDictionary *parameters = @{@"latitude": locOb.latitude, @"longitude": locOb.longitude,@"language" : [DataClass currentLanguageString]};
    
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
        [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"locationList"];
        
    }else{
        
        _locSelectionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LOCATION_SELECTION", nil), @(1000000)];
        [hud hideAnimated:YES];
        return;
    }
}


// Listing category api call

-(void)catList{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSError *error;
    

    NSString *lan;
    
    NSString *lang = [self getLangJSON];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:lang options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"category"];
}

-(NSString *) getLangJSON{
    
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    NSString *lan=@"English";
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]])
        lan = @"Arabic";
    
    
    NSString *parameters = @{@"language" :lan};
    return parameters;
}



- (void) gotBayieData:(NSNotification *) notification{
    
    id ob = notification.object ;
    
    
    if([ob isKindOfClass:[NSError class]]){
        [self showError:@"Unable to complete request"];
        return;
    }
    
    if([lastCall isEqualToString:@"catList"]){
        [self gotBayieAPIDataCategory:notification];
        
        DataClass *locOb=[DataClass getInstance];
        
        if(locOb.lastKnownLoc == nil){
            lastCall = @"locationList";
            [self locationUpdate];
        }else{
            lastCall = @"ProfileData";
            [self profileDataLoad];
            //  _locSelectionLabel.text = locOb.lastKnownLoc;
        }
        
    }else if([lastCall isEqualToString:@"locationList"] ){
        
        [self gotBayieAPIDataLocation:notification];
        lastCall = @"ProfileData";
        [self profileDataLoad];
    }else if([lastCall isEqualToString:@"ProfileData"] ){
        [self gotBayieAPIDataProfile:notification];
        lastCall = @"deviceToken";
        [self callingRegisterDeviceTokenApi];
        
        //  DataClass *locOb=[DataClass getInstance];
        
        //        if(locOb.lastKnownLoc == nil){
        //            lastCall = @"locationList";
        //            [self locationUpdate];
        //        }else{
        //
        //          //  _locSelectionLabel.text = locOb.lastKnownLoc;
        //        }
    }
    else if([lastCall isEqualToString:@"deviceToken"] ){
        NSLog(@"Not Object:%@",ob);
    }
    /*else if([lastCall isEqualToString:@"locationList"] ){
     [self gotBayieAPIDataLocation:notification];
     }*/
}

- (void) gotBayieAPIDataLocation:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occurs loading location" preferredStyle:UIAlertControllerStyleAlert];
            
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
            NSArray *locArray;
            
            if(![responseDict[@"selected"]  isEqual: @"NULL"]){
            locArray = responseDict[@"selected"];
                
            }
          //  if (!locArray || !locArray.count){
            if ([locArray count] == 0){
         _locSelectionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LOCATION_SELECTION", nil), @(1000000)];
            }else{
                
                 NSString *firstWord = [[[locArray valueForKey:@"location"] componentsSeparatedByString:@","] objectAtIndex:0];
                
                _locSelectionLabel.text = firstWord;
                DataClass *locOb=[DataClass getInstance];
                
                locOb.lastKnownLoc = [locArray valueForKey:@"location"];
                locOb.lastKnownLocID = [locArray valueForKey:@"id"];
          
            }
            
            
        }   else if (![errormsg isEqualToString:@""]){
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [hud hideAnimated:YES];
            return;
        }else {
            if(![[responseDict allKeys] containsObject:@"apiName"]){
                [hud hideAnimated:YES];
                
                
                return;
            }
            
            if(![responseDict[@"apiName"] isEqualToString:@"locationList" ]){
                [hud hideAnimated:YES];
                return;
            }
        }
       
    }
}

-(void)profileDataLoad{
    DataClass *tknobj=[DataClass getInstance];
    // NSDictionary *parameters =  @{@"userToken":tknobj.userToken};
    
    NSDictionary *parameters;
    if(tknobj.userToken!=nil)
        parameters=  @{@"userToken":tknobj.userToken};
    NSError *error;
    if(parameters!=nil){
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"profileData"];
    }
}

- (void) gotBayieAPIDataProfile:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occurs loading categories" preferredStyle:UIAlertControllerStyleAlert];
            
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
        myProfileload = [[UserProfile alloc] initWithDictionary:responseDict[@"data"]];
        if (myProfileload.idField){
            DataClass *tknobj=[DataClass getInstance];
            tknobj.userId= myProfileload.idField;
            tknobj.userName = myProfileload.name;
            tknobj.userEmail = myProfileload.emailId;
            tknobj.userMobile = myProfileload.phoneNumber;
        }
    }
}

- (void) gotBayieAPIDataCategory:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occurs loading categories" preferredStyle:UIAlertControllerStyleAlert];
            
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
        catDataArray = [[NSArray alloc] init];
        if ([errormsg isEqualToString:@""]) {
            catDataArray = responseDict[@"data"];
            catbase_imageUrl = responseDict[@"baseUrl"];
            catbase_defaultimageUrl = responseDict[@"mob_defaultImage"];
        }   else if (![errormsg isEqualToString:@""]){
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [hud hideAnimated:YES];
            return;
        }else {
            if(![[responseDict allKeys] containsObject:@"apiName"]){
                [hud hideAnimated:YES];
                
                
                return;
            }
            
            if(![responseDict[@"apiName"] isEqualToString:@"category" ]){
                [hud hideAnimated:YES];
                return;
            }
        }
        
        [self.categoryCollectionView reloadData];
        [hud hideAnimated:YES];
    }
}

- (void) gotBayieAPIDataTrending:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occurs when loading trending ads" preferredStyle:UIAlertControllerStyleAlert];
            
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
        }   else if (![errormsg isEqualToString:@""]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [hud hideAnimated:YES];
            return;
        }else {
            if(![[responseDict allKeys] containsObject:@"apiName"]){
                [hud hideAnimated:YES];
                return;
            }
            if(![responseDict[@"apiName"] isEqualToString:@"popularAds" ]){
                [hud hideAnimated:YES];
                return;
            }
        }
        [hud hideAnimated:YES];
    }
}

- (void) gotBayieAPIDataNearby:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occurs when near by ads" preferredStyle:UIAlertControllerStyleAlert];
            
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
           
            
        }   else if (![errormsg isEqualToString:@""]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
          
            [hud hideAnimated:YES];
           
        }else {
            if(![[responseDict allKeys] containsObject:@"apiName"]){
                [hud hideAnimated:YES];
                return;
            }
            if(![responseDict[@"apiName"] isEqualToString:@"nearByAds" ]){
                [hud hideAnimated:YES];
                return;
            }
        }
        [hud hideAnimated:YES];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.categoryCollectionView) {
            return catDataArray.count;
    }
    else
        return 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    long row = [indexPath row];
    if (collectionView == self.categoryCollectionView) {
        
        catDataDict = [catDataArray objectAtIndex:indexPath.row];
        static NSString *catCellidentifier = @"CatCell";
        CustomCategoryCollectionViewCell *catCell = [collectionView
                                                     dequeueReusableCellWithReuseIdentifier:catCellidentifier
                                                     forIndexPath:indexPath];
        catCell.layer.borderWidth=1.0f;
        //border color
        catCell.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
        
        // Clean cell for re-use
        catCell.categoryName.text = @"";
        catCell.categoryImage.image = [[UIImage alloc] init];
        
        NSString *url_Img = [catDataDict valueForKey:@"mobile_icon"];
        NSString *url_Img_FULL;
        
        if (url_Img == (id)[NSNull null]) {
            url_Img_FULL = catbase_defaultimageUrl;
        } else {
            url_Img_FULL = [catbase_imageUrl stringByAppendingPathComponent:url_Img];
        }
        catCell.categoryName.text = @"";
        catCell.categoryImage.image = nil;
        
        catCell.categoryName.text = [catDataDict valueForKey:@"category_name"];
        [catCell.categoryImage sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]];
        return catCell;
        
    }
    return nil;
}


//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    if (collectionView == self.categoryCollectionView) {
//    return 2.0;
//    }else{
//        return 1.0;
//    }
//}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (collectionView == self.categoryCollectionView) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            return UIEdgeInsetsMake(0, 0,0, 0);
        }
        
        return UIEdgeInsetsMake(0, 0,0, 0); // top, left, bottom, right
    }
    else{
        return UIEdgeInsetsMake(0,0,0,0);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.categoryCollectionView) {
        float horizontalGap = 8.0;
        if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation] )){
            _categoryCellHeight = 250 ;
            CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - horizontalGap*7)/6;
            CGSize cellSize = CGSizeMake(cellWidth,cellWidth);
            return cellSize;
            //return CGSizeMake(([UIScreen mainScreen].bounds.size.width- 26 - horizontalGap*6)/6, (_categoryCellHeight - 15)/3);
            
        }
        _categoryCellHeight = 398;
//        CGSize cellSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width- 26 - horizontalGap*3)/3, (_categoryCellHeight - 17)/5);
        CGFloat cellWidth = ([UIScreen mainScreen].bounds.size.width - horizontalGap*4)/3;
        CGSize cellSize = CGSizeMake(cellWidth,cellWidth);
        return cellSize;
    }
    else{
       return CGSizeMake(0,0);
    }
    
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if (collectionView == self.categoryCollectionView) {
        NSDictionary *dataDic = [catDataArray objectAtIndex:indexPath.row];
        catName = [dataDic valueForKey:@"category_name"];
        catId = [dataDic valueForKey:@"id"];
        DataClass *obj=[DataClass getInstance];
        obj.categoryTitle = [dataDic valueForKey:@"category_name"];
        obj.categoryId = [dataDic valueForKey:@"id"];
        obj.category =  [dataDic valueForKey:@"id"];
        obj.attributeDict = nil;
        [self getCategoriesWithCompletionBlocke:^(BOOL status, id response) {
            NSPredicate *subCatPredicate = [NSPredicate predicateWithFormat:@"SELF.id == %@", catId];
            NSArray *catArray = response;
            NSArray *subCategoryDataArray = [[[catArray filteredArrayUsingPredicate:subCatPredicate] firstObject]valueForKey:@"sub_category"];
            [self showCategoryUIWithData:subCategoryDataArray withStatus:3];
        }];
        
       
        //[self performSegueWithIdentifier:@"Subcategory" sender:self];
    }
}

- (void)getCategoriesWithCompletionBlocke:(void(^)(BOOL status,id response))categoryCompletion {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    DataClass *obj=[DataClass getInstance];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"https://bayie.digiora.com/api/apiAds.php?action=getAllCategories" parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    [req setValue:obj.userToken forHTTPHeaderField:@"Usertoken"];
    
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"platform":@"mobile"};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                if (![responseDict[@"error"] isEqualToString:@""]) {
                }else if([responseDict[@"error"] isEqualToString:@""]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       // self.categoryArray = [responseObject valueForKey:@"data"];
                        categoryCompletion(YES,[responseObject valueForKey:@"data"]);
                        
                    });
                }
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            categoryCompletion(NO,nil);
            if (error.code == NSURLErrorTimedOut) {
                //             //time out error here
                NSLog(@"Trigger TIME OUT");
            }
//            [[CLAlertHandler standardHandler] showAlert:@"An error occured. Please try again later" title:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] inContoller:self WithCompletionBlock:^(BOOL isSuccess) {
//                
//            }];
        }
    }]resume];
}

- (void)showCategoryUIWithData:(id)data withStatus:(int) statusValue {
    CategoryViewController * categoryController = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil];
    categoryController.baseUrl = [data valueForKey:@"baseUrl"];
    categoryController.dataArray = data;
    categoryController.pageType = self.pageType;
    switch (statusValue) {
        case 0:
            
            break;
        case 1:
            categoryController.isSubCategory = YES;
            break;
        case 2:
            categoryController.isLocation = YES;
            break;
        case 3:
            categoryController.isFromBrowseCategory = YES;
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:categoryController animated:YES];
//    UINavigationController *catNavControler = [[UINavigationController alloc] initWithRootViewController:categoryController];
//    [self presentViewController:catNavControler animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Subcategory"]) {
        DataClass *objc=[DataClass getInstance];
        ListingViewController *destlist = (ListingViewController *)segue.destinationViewController;
        destlist.catID = catId;
        destlist.catTitle = catName;
        objc.isFromSort = false;
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

- (void)Finish:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"FinishDownload_data1"]) {
    }
    else {
    }
}

#pragma mark - Button Actions

- (IBAction)locationButton:(id)sender {
//    SeachLocationViewController *controller = (SeachLocationViewController *)[[self.tabBarController viewControllers]  objectAtIndex:1];
//    [self.tabBarController setSelectedIndex:1];
}

- (IBAction)locateTempButtonAction:(id)sender {
//    SeachLocationViewController *controller = (SeachLocationViewController *)[[self.tabBarController viewControllers]  objectAtIndex:1];
//    [self.tabBarController setSelectedIndex:1];
    
    SeachLocationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SeachLocationViewController"];
    controller.fromList = true;
    [self.navigationController pushViewController:controller animated:YES];
}
@end

