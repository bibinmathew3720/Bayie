//
//  SeachLocationViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 24/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "SeachLocationViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "BayieHub.h"
#import "DataClass.h"
#import "BrowseViewController.h"
#import "Utility.h"

@interface SeachLocationViewController ()
{
    NSArray *locationDataArray;
    NSDictionary *locationDataDict;
    NSMutableDictionary *locationSearchdataDict;
    NSArray *locationSearchdataArray;
    MBProgressHUD *hud;
    CLLocation *loc;
    NSString *lastUpdatedLoc;
}
@end

@implementation SeachLocationViewController
@synthesize lastApiCall,fromList;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataSearch:) name:@"BayieResponse" object:nil];
    
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [tap setCancelsTouchesInView:NO];

    _isSearch = false;
    self.locationTableView.tableFooterView = [UIView new];
    [self nodataLabel];
    
    _search.barTintColor =  [UIColor colorWithRed:223.0/255.0 green:231.0/255.0 blue:234.0/255.0 alpha:1];
    _search.searchBarStyle = UISearchBarStyleMinimal;
    [[UISearchBar appearance] setTintColor:[UIColor blackColor]];

    _locationTitle.text = [NSString stringWithFormat:NSLocalizedString(@"SELECT_YOUR_LOCATION", nil), @(1000000)];
    _otherCitiesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"OTHER_CITIES", nil), @(1000000)];
    
    @try {
        for (id object in [[[self.search subviews] firstObject] subviews])
        {
            if (object && [object isKindOfClass:[UITextField class]])
            {
                UITextField *textFieldObject = (UITextField *)object;
                textFieldObject.backgroundColor = [UIColor whiteColor];
                textFieldObject.borderStyle = UITextBorderStyleLine;
                textFieldObject.layer.borderColor = [UIColor whiteColor].CGColor;
                textFieldObject.layer.borderWidth = 1.0;
                textFieldObject.frame = CGRectMake(0.0f, 0.0f, 300.0f, 80.0f);
                
                break;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error while customizing UISearchBar");
    }
    [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated{
    
   // self.bgHeight.constant = 0;
    self.lastApiCall = @"location";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieDatalocation:) name:@"BayieResponse" object:nil];

    [self listLocation];
    [self updateUI];
    [super viewWillAppear:animated];

}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [self.trendingAdsTableView reloadData];
//}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    UIInterfaceOrientation ori =  [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(ori);
    
    if(isLandscape)
    {
        self.bgHeight.constant = 30;
       // self.topCentreDist.constant = -20;
    }else if(UIInterfaceOrientationIsPortrait(ori)){
       // self.centreDist.constant = 9;
        self.bgHeight.constant = 0;
        
    }
}



- (void) gotBayieDatalocation:(NSNotification *) notification{
    id ob = notification.object ;
    
    if([ob isKindOfClass:[NSError class]]){
        [self showError:@"Unable to complete request"];
        return;
    }
    if([notification.object isKindOfClass:[NSError class]]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                        message: @"Sorry unable to complete request "
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [hud hideAnimated:YES];
        
    }
    NSDictionary *responseDict = notification.object;
    
    id data =responseDict[@"data"];
    
 /*   if(![Utility isValidDataObject:data] ){
    [hud hideAnimated:YES];
        return;
        
  
    }*/
    
    self.locationTableView.delegate = self;
    //if at any time notfi.object is error or null hide the HUD
    if([lastApiCall isEqualToString:@"location"]){
        [self gotBayieAPIDataSearch:notification];
    }else if([lastApiCall isEqualToString:@"locationResult"] ){
        [self gotBayieAPIDataSearchResultList:notification];
    }else if([lastApiCall isEqualToString:@"googleLoc"] ){
        [self gotBayieAPIDataGoogleLoc:notification];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //   NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}

-(void)updateUI{
    
    DataClass *locOb=[DataClass getInstance];
    NSLog(@"%@",locOb.lastKnownLoc);
    
    
    if(locOb.lastKnownLoc != nil){
        _locationLabel.text  = locOb.lastKnownLoc;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:locOb.lastKnownLoc forKey:@"lastLocStr"];
        
        [defaults synchronize];
        
    }else{
        _locationLabel.text  = [NSString stringWithFormat:NSLocalizedString(@"LOCATION_SELECTION", nil), @(1000000)];
    }
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0/255.0 green:177/255.0 blue:176/255.0 alpha:1]];
    
    UITabBarController *tabBarController = self.tabBarController;

    tabBarController.tabBar.alpha = 3.0;
    
    UITabBarItem *postAdTab = [tabBarController.tabBar.items objectAtIndex:2];
    
    [postAdTab setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Lato-Regular" size:10.0f], NSFontAttributeName,  [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    postAdTab.image = [[UIImage imageNamed:@"camera-active"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    postAdTab.selectedImage = [[UIImage imageNamed:@"camera-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) gotBayieAPIDataGoogleLoc:(NSNotification *) notification{
    
    id ob = notification.object ;
    
    if([ob isKindOfClass:[NSError class]]){
        [self showError:@"Unable to complete request"];
        return;
    }
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        
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
        NSLog(@"%@ loc array null", responseDict);
        NSString *errormsg = responseDict[@"error"];
        
        NSLog(@"%@", responseDict);
        
        if ([errormsg isEqualToString:@""]) {
            // catDataArray = responseDict[@"selected"];
            //  NSLog(@"%@", catDataArray);
            
            NSArray *locArray = responseDict[@"selected"];
            if (!locArray || !locArray.count){
                _locationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LOCATION_SELECTION", nil), @(1000000)];;
                
                
                NSLog(@"loc array null");
                
            }else{
                
                _locationLabel.text = [locArray valueForKey:@"location"];
                DataClass *locOb=[DataClass getInstance];
                
                locOb.lastKnownLoc = [locArray valueForKey:@"location"];
                locOb.lastKnownLocID = [locArray valueForKey:@"id"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:locOb.lastKnownLoc forKey:@"lastLocStr"];
                [defaults setObject: locOb.lastKnownLocID forKey:@"lastLocID"];
                
                [defaults synchronize];

                NSLog(@"%@",locOb.lastKnownLoc);
                
                if(fromList){
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }else{

                [self.tabBarController setSelectedIndex:0];
               
                }
                [hud hideAnimated:YES];

                
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
        [hud hideAnimated:YES];

    }
}


- (void) gotBayieAPIDataSearch:(NSNotification *) notification{
    id ob = notification.object ;
    
    if([ob isKindOfClass:[NSError class]]){
        [self showError:@"Unable to complete request"];
        return;
    }
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        
       
        
       
        NSDictionary *responseDict = notification.object;
        
        
        
        
        NSLog(@"%@", responseDict);
        NSString *errormsg = responseDict[@"error"];
        
        if ([errormsg isEqualToString:@""]) {
            NSArray *dataArray = responseDict[@"data"];
            if (nil != dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0) {
                locationDataArray = dataArray;
            }
            [hud hideAnimated:YES];
        } else if (![errormsg isEqualToString:@""]){
            
            [self showError:[responseDict valueForKey:@"error"]];
       
        [hud hideAnimated:YES];
        }
        [self.locationTableView reloadData];
        [hud hideAnimated:YES];
        
    }
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


- (void) gotBayieAPIDataSearchResultList:(NSNotification *) notification{
    
    id ob = notification.object ;
    
    
    if([ob isKindOfClass:[NSError class]]){
        [self showError:@"Unable to complete request"];
        return;
    }

    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSLog (@"Successfully received the test notification!");
        NSDictionary *responseDict = notification.object;
        NSLog(@"%@", responseDict);
        NSString *errormsg = responseDict[@"error"];
        
        if ([errormsg isEqualToString:@""]) {
            locationSearchdataArray = responseDict[@"data"];
            fromLabel.text = @"";
            NSLog(@"%@", locationSearchdataArray);
            [hud hideAnimated:YES];

        } else if (![errormsg isEqualToString:@""]){
            locationSearchdataArray = @[];
            //   [self nodataLabel];
            fromLabel.text =@"No Result";
            
      
            [hud hideAnimated:YES];
        }
        [self.locationTableView reloadData];
        [hud hideAnimated:YES];
        
    }
}

-(void)listLocation{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSError *error;
 // NSString *jsonString = @"{\"language\":\"English\"}";

    NSString *parameters = @{@"language" : [DataClass currentLanguageString]};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"locationList"];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_search.text.length > 2){
        return locationSearchdataArray.count;
    }else{
        return locationDataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Location";
    
    UITableViewCell *locationcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (_search.text.length > 2){
        //        if ([locationSearchdataDict count] == 0){
        //            [self nodataLabel];
        //        }
        fromLabel.text =@"";
        locationSearchdataDict = [locationSearchdataArray objectAtIndex:indexPath.row];
        locationcell.textLabel.text = [locationSearchdataDict valueForKey:@"location"];
        return locationcell;
        
    }else {
        locationDataDict = [locationDataArray objectAtIndex:indexPath.row];
        
        locationcell.textLabel.text = [locationDataDict valueForKey:@"location"];
        
        return locationcell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   NSDictionary *dataDic = [locationDataArray objectAtIndex:indexPath.row];
   NSString *loc_name = [dataDic valueForKey:@"location"];
    NSString *loc_id = [dataDic valueForKey:@"id"];

  _locationLabel.text = loc_name;

     DataClass *locObj = [DataClass getInstance];
    locObj.lastKnownLoc= loc_name;
    locObj.lastKnownLocID= loc_id;

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:locObj.lastKnownLoc forKey:@"lastLocStr"];
    [defaults setObject: locObj.lastKnownLocID forKey:@"lastLocID"];
    [defaults synchronize];
    
    if(fromList){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
   // UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    //tbc.selectedIndex=0;
    [self.tabBarController setSelectedIndex:0];
    
    
    //[self.navigationController pushViewController:tbc animated:YES];
    /*
    BrowseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowseViewController"];
    [self.navigationController pushViewController:controller animated:YES];
     */
   // [self.navigationController popViewControllerAnimated:YES];

 //   _locationUpdtedIndication.hidden = false;

    lastUpdatedLoc = loc_name;
}
- (IBAction)backButton:(id)sender {
    if(fromList){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.tabBarController setSelectedIndex:0];
    }
}


- (void)filterContentForSearchText:(NSString*)str {
    //this will force display of results when there is no text in search bar
    if([str length] == 0){
        fromLabel.text =@"";
        self.lastApiCall = @"location";
        [self listLocation];
        //  [self.locationTableView reloadData];
        
    }
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if ([text length] > 2){
        
        self.lastApiCall = @"locationResult";
        [hud hideAnimated:YES];

        [self searchResultList : text ];
    }
    if ([text  isEqual: @""]) {
        fromLabel.text =@"";
        self.lastApiCall = @"location";
        [hud hideAnimated:YES];

       [self listLocation];
        //   [self.locationTableView reloadData];
    }
    
}
-(void)nodataLabel{
    //  UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height/3, self.locationTableView.bounds.size.width, self.locationTableView.bounds.size.height)];
    fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    fromLabel.textColor = [UIColor lightGrayColor];
    fromLabel.textAlignment = NSTextAlignmentCenter;
    _locationTableView.backgroundView = fromLabel;
    
    //  fromLabel.backgroundColor = [UIColor clearColor];
    // [fromLabel setFont:[UIFont fontWithName:latto size:30.0f]];
    // [self.view addSubview:fromLabel];
    //    [self.locationTableView setHidden:YES];
}

-(void)searchResultList : (NSString*) text{
    NSLog(@"%@", text);
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSDictionary *parameters =  @{@"language":@"English",@"location":text};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"locationAutoFill"];
    
}

- (IBAction)locationChangeBtn:(id)sender {
    
    [self googleLocationSelection];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    
    [hud hideAnimated:YES];
}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    [hud hideAnimated:YES];

}

- (void) googleLocationSelection{
    
    self.lastApiCall = @"googleLoc";

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];

    CLLocationCoordinate2D coordinate = [self getLocation];
    if(coordinate.latitude  == 999 || coordinate.latitude ==0){
        [hud hideAnimated:YES];
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location not enabled"
                                           message:@"To enable, please go to Settings and turn on Location Service on your device and for this app."
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];

        return;
    }
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    NSLog(@"*dLatitude : %@", latitude);
    NSLog(@"*dLongitude : %@",longitude);
    
    if(latitude != nil && longitude !=nil){
        NSError *error;
        NSString *parameters = @{@"latitude": latitude, @"longitude": longitude,@"language" : [DataClass currentLanguageString]};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"locationList"];
    }else{
        _locationLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LOCATION_SELECTION", nil), @(1000000)];
        return;
    }

    
   /*/////////////////
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
                      // NSLog(@"placemark %@",placemark.region);
                      NSLog(@"placemark %@",placemark.locality); // Extract the city name
                      //   NSLog(@"location %@",placemark.location);
                      NSLog(@"I am currently at %@",locatedAt);
                       // _locationLabel.text = placemark.locality;

                      lastUpdatedLoc = locatedAt;
                    
                      if(locatedAt != nil){
                       //   DataClass *locObj = [DataClass getInstance];
                        //  locObj.lastKnownLoc= locatedAt;

                       ///   _locationLabel.text  = locatedAt;
                    
                          [self.tabBarController setSelectedIndex:0];

                       //   BrowseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowseViewController"];
                      //    [self.navigationController pushViewController:controller animated:YES];
                          
                       //   [self.navigationController popViewControllerAnimated:YES];
                          [hud hideAnimated:YES];

                      }else{
                          _locationLabel.text  = [NSString stringWithFormat:NSLocalizedString(@"LOCATION_SELECTION", nil), @(1000000)];
                          [hud hideAnimated:YES];

                      }

                  }
                  else {
                      NSLog(@"Could not locate");
                  }
              }
     ];
    */
    [hud hideAnimated:YES];

}
-(CLLocationCoordinate2D) getLocation{
    
    _locationManager=[[CLLocationManager alloc] init];
    CLLocationCoordinate2D coordinate ;
    coordinate.latitude  =999;
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    UIAlertView    *alert;
     if ([CLLocationManager locationServicesEnabled]){
         if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
             alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                message:@"To enable, please go to Settings and turn on Location Service for this app."
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
             [alert show];
         }
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //     [locationManagerApp requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //   [_locationManager startUpdatingLocation];
    CLLocation *location1 = [_locationManager location];
    coordinate = [location1 coordinate];
    
    NSLog(@"Latitude  = %f", coordinate.latitude);
    NSLog(@"Longitude = %f", coordinate.longitude);
     }else{
         alert = [[UIAlertView alloc] initWithTitle:@"Location not enabled"
                                                            message:@"To re-enable, please go to Settings and turn on Location Service."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
         [alert show];
         
     }
    
    return coordinate;
}

//- (IBAction)locationUpdated:(id)sender {
//    
//    DataClass *locObj = [DataClass getInstance];
//    locObj.lastKnownLoc= lastUpdatedLoc;
//    
//    if(locObj.lastKnownLoc != nil){
//        _locationLabel.text  = locObj.lastKnownLoc;
//    }else{
//        _locationLabel.text  = [NSString stringWithFormat:NSLocalizedString(@"LOCATION_SELECTION", nil), @(1000000)];
//    }
//     [self.navigationController popViewControllerAnimated:YES];
//
//}

@end
