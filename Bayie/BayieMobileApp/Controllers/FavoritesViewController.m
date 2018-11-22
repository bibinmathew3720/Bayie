//
//  FavoritesViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 25/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "FavoritesViewController.h"
#import "CustomFavoritesTableViewCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DataClass.h"
#import "BayieHub.h"
#import "AdDetailedViewController.h"
#import "ChatDetailViewController.h"
#import "Utility.h"

@interface FavoritesViewController ()
{
    NSDictionary *favdataDict;
    
    NSMutableArray *favdataArray;
    
    NSString *base_Imageurlfav;
    NSString *default_Imageurlfav;
    MBProgressHUD *hud;
}

@end

@implementation FavoritesViewController
{
    BOOL showAd;
    
    NSInteger totalCount;
    NSInteger totalAdRows;
    NSInteger totalNoOfAd;

}

@synthesize fromProfile,totalFavResult;

- (void)viewDidLoad {
    [super viewDidLoad];
       [self updateUI];
    int favStart = 0;
    int totalFavResult =0;
    self.favoritesTableView.estimatedRowHeight = 120;
    self.favoritesTableView.rowHeight = UITableViewAutomaticDimension;

}
-(void)viewDidAppear:(BOOL)animated{
    
    NSIndexPath *indexPath = self.favoritesTableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.favoritesTableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_favoritesTableView setContentOffset:CGPointZero animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if(fromProfile){
   self.backButton.hidden = false;
    }else{
  self.backButton.hidden = true;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    favdataArray = [[NSMutableArray alloc] init];
    totalCount = 0;
    _favStart = 0;
    [self.favoritesTableView reloadData];
    [hud hideAnimated:true];
    [self favList];
    
}

-(void)updateUI{
 
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

- (void) gotBayieAPIData:(NSNotification *) notification {
    [favdataArray removeAllObjects];
    if ([[notification name] isEqualToString:@"BayieResponse"]) {
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
        id data = responseDict[@"data"];
        
        // If not a valid data
        if(![Utility isValidDataObject:data])
        {
            [hud hideAnimated:YES];
            return;
        }
        
        NSString *errormsg = responseDict[@"error"];
        
        if (nil != errormsg && [errormsg isEqualToString:@""])
        {
            
            if(![[responseDict allKeys] containsObject:@"apiName"]){
                [hud hideAnimated:YES];
             

                return;
            }
            
            if(![responseDict[@"apiName"] isEqualToString:@"myFavouriteList" ]){
                [hud hideAnimated:YES];
                return;
            }
            
            DataClass *tknobj=[DataClass getInstance];
            tknobj.datas = responseDict[@"data"];
            tknobj.chatimg = responseDict[@"imageBaseUrl"];
         
            NSArray *dataArray = responseDict[@"data"];
            NSString *baseURL = responseDict[@"imageBaseUrl"];
            NSString *defaultImageURL = responseDict[@"defaultImage"];

            
            totalFavResult =  [[responseDict valueForKey:@"totalResult"] integerValue];
            
            if (nil != dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0 && [baseURL isKindOfClass:[NSString class]] && baseURL.length > 0 && [defaultImageURL isKindOfClass:[NSString class]] && defaultImageURL.length > 0 ) {
               NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray: dataArray];
                            if(favdataArray == nil    )
                                        favdataArray = [[NSMutableArray alloc] init];
                    [favdataArray addObjectsFromArray:tmp] ;
                default_Imageurlfav =  defaultImageURL;
                base_Imageurlfav = baseURL;
                [hud hideAnimated:true];
                [self.favoritesTableView reloadData];
            }
        }   else if (![errormsg isEqualToString:@""]){
            
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message:@"No List Found" preferredStyle:UIAlertControllerStyleAlert];
            
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
        }else {
            [hud hideAnimated:YES];
        }
        [self.favoritesTableView reloadData];
        [hud hideAnimated:YES];
    }else {
        [hud hideAnimated:YES];
    }
}

-(void)favList{
    [favdataArray removeAllObjects];
    
    DataClass *favobj=[DataClass getInstance];
    
    NSString *start = [NSString stringWithFormat:@"%d",_favStart];
    
    NSString *locid;
    
    if(favobj.lastKnownLocID != nil){
        locid = favobj.lastKnownLocID;
    }else{
        locid = @"";
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSDictionary *parameters =  @{@"userToken":favobj.userToken,@"language" :[DataClass currentLanguageString],@"start":start,@"limit":@"20",@"location":locid};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"myFavouriteList"];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(favdataArray.count > 3){
        //Google Ad
        //totalAdRows =  ((favdataArray.count  - 3)/6) + 1;
        totalCount = (favdataArray.count + totalAdRows) ;
        return totalCount;
        
    }
    totalCount = favdataArray.count;
    return totalCount;
    
   // return favdataArray.count;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [hud hideAnimated:true];
    [self.favoritesTableView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Favorites";
    
    CustomFavoritesTableViewCell *favCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    favCell.favImage.layer.borderWidth = 1.0;
    favCell.favImage.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
    
    if (totalCount > 3){
        
        if (indexPath.row == 3 )
            showAd = true;
        else {
            showAd = ((indexPath.row - 3) % 6) == 0;
        }
    }else {
        showAd = false;
        
    }

    if (showAd  && (totalCount > 3 || indexPath.row == 3 )) {
        favdataDict = [favdataArray objectAtIndex:indexPath.row];
        //Google Ad
//        if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
//            self.bannerView = [[GADBannerView alloc]
//                               initWithAdSize:kGADAdSizeSmartBannerLandscape];
//        }else{
//            
//            self.bannerView = [[GADBannerView alloc]
//                               initWithAdSize:kGADAdSizeSmartBannerPortrait];
//        }
//        
//        CustomFavoritesTableViewCell *adCell = [[CustomFavoritesTableViewCell alloc]init];
//        adCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        [adCell.contentView addSubview:_bannerView];
//        
//        self.bannerView.adUnitID = @"ca-app-pub-3310088406325999/3684441066";
//        self.bannerView.rootViewController = self;
//        [self.bannerView loadRequest:[GADRequest request]];
//        
//        totalNoOfAd = totalNoOfAd + 1;
//        return adCell;
        
    }else if(indexPath.row < 3 && !showAd){
        
        favdataDict = [favdataArray objectAtIndex:indexPath.row];
        
    }else if(totalCount > 3 && !showAd){
        
        int pos =(int)indexPath.row - [self calculateDED:(int)indexPath.row];
        int c = totalCount;
        if(pos >= totalCount )
            return favCell;
        
        else{
             favdataDict = [favdataArray objectAtIndex:pos];
        }
    }
    
   // favCell.favChat.tag = indexPath.row;
    NSString *url_Img = [favdataDict valueForKey:@"image_url"];
    NSString *url_Img_FULL;
    if (url_Img == (id)[NSNull null]){
        url_Img_FULL = default_Imageurlfav;
    } else {
        url_Img_FULL = [base_Imageurlfav stringByAppendingPathComponent:url_Img];
    }
    [favCell.favImage sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]];
 
    NSString *dateStr = [favdataDict valueForKey:@"createdDate"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:@"MMMM YYYY"];
    NSString* newDateFormat = [dateFormat stringFromDate:date];
    dateFormat.doesRelativeDateFormatting = YES;
    
    favCell.favTitle.text = [favdataDict valueForKey:@"title"];
    
    NSString *loc = [favdataDict valueForKey:@"location"];
    
    NSString *firstWord = [[loc componentsSeparatedByString:@","] objectAtIndex:0];

    favCell.favLocation.text = firstWord;
    
 //   favCell.favLocation.text = [favdataDict valueForKey:@"location"];
    
    NSString *isFeatured = [favdataDict valueForKey:@"is_featured"];
    if( [isFeatured  isEqual: @"Yes"]){
        [favCell.featuredLabel setHidden:NO];
    }else{
        [favCell.featuredLabel setHidden:YES];
    }
    DataClass *objc=[DataClass getInstance];
    if(!objc.isEnglish ){
        favCell.featuredLabel.text = @"متميز";
    }
    

    
    /*/
    if(![[favdataDict valueForKey:@"price"] isEqual: @""]){

    favCell.favPrice.text = [[favdataDict valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
    }else{
        favCell.favPrice.text = @"";
    }
    */
    //price attribt >>>>>
    if([[favdataDict valueForKey:@"price"] isEqual: @""] && [[favdataDict valueForKey:@"price_type"] isEqual: @""]){
        
        favCell.priceImage.hidden = true;
        
    }else if(![[favdataDict valueForKey:@"price"] isEqual: @""]){
        
        favCell.favPrice.text = [[favdataDict valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
        
        if(![[favdataDict valueForKey:@"price_type"] isEqual: @""]){
            
            favCell.priceImage.hidden = false;
            NSString *priceType = [favdataDict valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                favCell.priceImage.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                favCell.priceImage.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
        
    }else if([[favdataDict valueForKey:@"price"] isEqual: @""]){
        
        favCell.favPrice.text = @"";
        
        if(![[favdataDict valueForKey:@"price_type"] isEqual: @""]){
            
            favCell.priceImage.hidden = false;
            NSString *priceType = [favdataDict valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                favCell.priceImage.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                favCell.priceImage.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
    }
    
    // >>>> price atrbt
    
    favCell.favPrice.textColor = [UIColor colorWithRed:0/255.0 green:178/255.0 blue:176/255.0 alpha:1];
    favCell.dateLabel.text = [@", " stringByAppendingString:(newDateFormat != nil) ? newDateFormat : @""];
    
    if(  totalCount == indexPath.row+1  ){
        _favStart =  indexPath.row +1 - [self calculateDED:indexPath.row] ;
        [self performSelector:@selector(checkAndLoadList:) withObject:self afterDelay:2];
        
    }

    
    return favCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AdDetailedViewController *adDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailedVC"];
    
    if(indexPath.row < 3){
        
        
        NSDictionary *dataObj = [favdataArray objectAtIndex:indexPath.row];
        NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        
        adDetailsViewController.adId = ad_id;
        adDetailsViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:adDetailsViewController animated:YES];
        
    }else{
        int ded =(int) [self calculateDED:(int)indexPath.row];
        NSDictionary *dataObj = [favdataArray objectAtIndex:indexPath.row - ded];
        NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        
        adDetailsViewController.adId = ad_id;
        adDetailsViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:adDetailsViewController animated:YES];
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        return 150;
    }
    //Google Ad
//    if (indexPath.row == 3 || ((indexPath.row - 3) % 6) == 0) {
//        
//        return 50;     // setting google ad height.
//    }
    return UITableViewAutomaticDimension;
}

#pragma mark -

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

-(void) checkAndLoadList:(id) sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    if(totalFavResult > totalCount)
    [self favList];
}

-(int)calculateDED:(int)row{
    //Google Ad
    
//    if(row<3)
//        return 0;
//    else if (row == 3)
//        return 1;
//    else if(row >3)
//        return 1 + ((row - 3)/6);
//    else
//        return  0;
    
    return 0;
    
}


- (IBAction)backButton:(id)sender {
    if ([[self.navigationController viewControllers] count] > 1 ){
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([[self.tabBarController.navigationController viewControllers] count] > 3 ){
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }else {
        [self.tabBarController setSelectedIndex:0];
    }
    
}


@end
