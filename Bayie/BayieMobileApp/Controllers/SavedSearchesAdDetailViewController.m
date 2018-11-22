//
//  SavedSearchesAdDetailViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 23/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "SavedSearchesAdDetailViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DataClass.h"
#import "BayieHub.h"
#import "CustomSavedSearchesAdTableViewCell.h"
#import "AdDetailedViewController.h"

@interface SavedSearchesAdDetailViewController ()
{
    NSDictionary *savdataDict;
    NSMutableArray *savdataArray;
    
    NSString *base_Imageurlsav;
    NSString *default_Imageurlsav;
    MBProgressHUD *hud;
}
@end

@implementation SavedSearchesAdDetailViewController{
    BOOL showAd;
    
    NSInteger totalCount;
    NSInteger totalAdRows;
    NSInteger totalNoOfAd;
}


@synthesize savid,lastApi,totalsavedAdDetailResult;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.savedSearchAdDetail.estimatedRowHeight = 130;
    self.savedSearchAdDetail.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.lastApi = @"save";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataListNoti:) name:@"BayieResponse" object:nil];
    [self savList];
    [super viewWillAppear:animated];
}

- (void) gotBayieAPIDataListNoti:(NSNotification *) notification{
    //if at any time notfi.object is error or null hide the HUD
    if([lastApi isEqualToString:@"save"]){
        [self gotBayieAPIDatasav:notification];
    }else if([lastApi isEqualToString:@"delete"] ){
        //      [self gotBayieAPIDelete:notification];
    }
}




-(void)savList{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    DataClass *favobj=[DataClass getInstance];
    NSLog(@"%@", favobj.userToken);
    //   NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"listAds"];
    
    
    NSString *locid;
    
    if(favobj.lastKnownLocID != nil){
        locid = favobj.lastKnownLocID;
    }else{
        locid = @"";
    }

    NSString *start = [NSString stringWithFormat:@"%d",_savedAdDetailStart];
    
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"start":start,@"limit":@"20",@"search_id":savid,@"location":locid};

    
  //  NSDictionary *parameters =  @{@"search_id":savid};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"listAds"];
    
}

- (void) gotBayieAPIDatasav:(NSNotification *) notification{
    
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
            NSArray *dataArray = responseDict[@"data"];
            NSString *baseURL = responseDict[@"imageBaseUrl"];
            NSString *defaultImageURL = responseDict[@"defaultImage"];
            
            totalsavedAdDetailResult =  [[responseDict valueForKey:@"totalResult"] integerValue];
            
            
            if (nil != dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0 && [baseURL isKindOfClass:[NSString class]] && baseURL.length > 0 && [defaultImageURL isKindOfClass:[NSString class]] && defaultImageURL.length > 0 ) {
               // savdataArray = dataArray;
                
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray: dataArray];
                if(savdataArray == nil )
                    savdataArray = [[NSMutableArray alloc] init];
                [savdataArray addObjectsFromArray:tmp] ;
                
                default_Imageurlsav =  defaultImageURL;
                base_Imageurlsav = baseURL;
            }
            
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
        [self.savedSearchAdDetail reloadData];
        [hud hideAnimated:YES];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(savdataArray.count > 3){
        //Google Ad
        //totalAdRows =  ((savdataArray.count  - 3)/6) + 1;
        totalCount = (savdataArray.count + totalAdRows) ;
        return totalCount;
        
    }
    totalCount = savdataArray.count;
    return totalCount;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.savedSearchAdDetail reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"SavedSearch";
    
    CustomSavedSearchesAdTableViewCell *savcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
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
//        CustomSavedSearchesAdTableViewCell *adCell = [[CustomSavedSearchesAdTableViewCell alloc]init];
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
        
        savdataDict = [savdataArray objectAtIndex:indexPath.row];
        
    }else if(totalCount > 3 && !showAd){
        
        savdataDict = [savdataArray objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
        
    }
    
    
    //  savdataDict = [savdataArray objectAtIndex:indexPath.row];
    
    NSString *url_Img = [savdataDict valueForKey:@"image_url"];
    NSString *url_Img_FULL;
    if(url_Img == (id)[NSNull null]){
        url_Img_FULL = default_Imageurlsav;
    }else {
        url_Img_FULL = [base_Imageurlsav stringByAppendingPathComponent:url_Img];
    }
    
    
    savcell.image.layer.borderWidth = 1.0;
    savcell.image.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
    
    NSString *dateStr = [savdataDict valueForKey:@"createdDate"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:@"MMMM YYYY"];
    NSString* newDateFormat = [dateFormat stringFromDate:date];
    dateFormat.doesRelativeDateFormatting = YES;
    
    [savcell.image sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]];
    savcell.titleLabel.text = [savdataDict valueForKey:@"title"];
    
    NSString *loc = [savdataDict valueForKey:@"location"];
    
    NSString *firstWord = [[loc componentsSeparatedByString:@","] objectAtIndex:0];

    savcell.loclabel.text = firstWord;
    NSString *isFeatured = [savdataDict valueForKey:@"is_featured"];
    if( [isFeatured  isEqual: @"Yes"]){
        [savcell.featuredLabel setHidden:NO];
    }else{
        [savcell.featuredLabel setHidden:YES];
    }
    
    //price attribt >>>>>
    if([[savdataDict valueForKey:@"price"] isEqual: @""] && [[savdataDict valueForKey:@"price_type"] isEqual: @""]){
        
        savcell.priceImage.hidden = true;
        
    }else if(![[savdataDict valueForKey:@"price"] isEqual: @""]){
        
        savcell.datelabel.text = [[savdataDict valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
        
        if(![[savdataDict valueForKey:@"price_type"] isEqual: @""]){
            
            savcell.priceImage.hidden = false;
            NSString *priceType = [savdataDict valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                savcell.priceImage.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                savcell.priceImage.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
        
    }else if([[savdataDict valueForKey:@"price"] isEqual: @""]){
        
        savcell.datelabel.text = @"";
        
        if(![[savdataDict valueForKey:@"price_type"] isEqual: @""]){
            
            savcell.priceImage.hidden = false;
            NSString *priceType = [savdataDict valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                savcell.priceImage.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                savcell.priceImage.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
    }
    
    // >>>> price atrbt
    
    /*
    if(![[savdataDict valueForKey:@"price"] isEqual: @""]){
   savcell.datelabel.text = [[savdataDict valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
    }else{
        savcell.datelabel.text = @"";
    }
    
    */
    
    savcell.dateLabl.text = [@"," stringByAppendingString:newDateFormat];
    
    if(  totalCount == indexPath.row+1  ){
        _savedAdDetailStart = indexPath.row;
        [self performSelector:@selector(checkAndLoadList:) withObject:self afterDelay:2];
        
    }
    

    return savcell;
}

-(void) checkAndLoadList:(id) sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataListNoti:) name:@"BayieResponse" object:nil];
    if(totalsavedAdDetailResult > totalCount)
        [self savList];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AdDetailedViewController *adDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailedVC"];
    UINavigationController * navigationController = [[UINavigationController alloc]initWithRootViewController:adDetailsViewController];
    if(indexPath.row<3){
        
        NSDictionary *dataObj = [savdataArray objectAtIndex:indexPath.row];
        NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        
        adDetailsViewController.adId = ad_id;
        adDetailsViewController.hidesBottomBarWhenPushed = true;
        //[self.navigationController pushViewController:adDetailsViewController animated:YES];
    }else{
        NSDictionary *dataObj = [savdataArray objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
        
        NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        adDetailsViewController.adId = ad_id;
        adDetailsViewController.hidesBottomBarWhenPushed = true;
       // [self.navigationController pushViewController:adDetailsViewController animated:YES];
    }
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(int)calculateDED:(int)row{
    
    NSLog(@"row **%d ",row);
    if(row<3)
        return 0;
    else if (row == 3)
        return 1;
    else if(row >3)
        return 1 + ((row - 3)/6);
    else
        return  0;
    
}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
