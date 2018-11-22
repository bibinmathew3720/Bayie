//
//  SeeAllAdsViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 17/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "SeeAllAdsViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DataClass.h"
#import "BayieHub.h"
#import "AdDetailedViewController.h"
#import "ChatDetailViewController.h"
#import "Utility.h"
#import "CustomSeeAllAdsTableViewCell.h"



@interface SeeAllAdsViewController ()
{
    NSDictionary *allAdsdataDict;
    NSMutableArray *allAdsdataArray;
    NSString *base_Imageurl_allAds;
    NSString *default_Imageurl_allAds;
    MBProgressHUD *hud;
    NSString *user_ID;
}

@end

@implementation SeeAllAdsViewController{
    BOOL showAd;
    
    NSInteger totalCount;
    NSInteger totalAdRows;
    NSInteger totalNoOfAd;
    

}


@synthesize user_ID,totalseeAllAdsResult;


- (void)viewDidLoad {
    [super viewDidLoad];
}



-(void)viewWillAppear:(BOOL)animated{
    [_seeAllAdsTableView setContentOffset:CGPointZero animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    [self seeAllAdslist];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) gotBayieAPIData:(NSNotification *) notification{
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
        
        id data =responseDict[@"data"];
        
        if(![Utility isValidDataObject:data] ){
            [hud hideAnimated:YES];
            return;
            
        }
        
        NSString *errormsg = responseDict[@"error"];
        
        if ([errormsg isEqualToString:@""]) {
          //  allAdsdataArray = responseDict[@"data"];
         //            if(![[responseDict allKeys] containsObject:@"apiName"]){
//                [hud hideAnimated:YES];
//                
//                
//                return;
//            }
//            
//            if(![responseDict[@"apiName"] isEqualToString:@"myFavouriteList" ]){
//                [hud hideAnimated:YES];
//                return;
//            }
            DataClass *tknobj=[DataClass getInstance];
            tknobj.datas = responseDict[@"data"];
            tknobj.chatimg = responseDict[@"imageBaseUrl"];
            NSArray *dataArray = responseDict[@"data"];
            NSString *baseURL = responseDict[@"imageBaseUrl"];
            NSString *defaultImageURL = responseDict[@"defaultImage"];
            
            totalseeAllAdsResult =  [[responseDict valueForKey:@"totalResult"] integerValue];
            
            if (nil != dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0 && [baseURL isKindOfClass:[NSString class]] && baseURL.length > 0 && [defaultImageURL isKindOfClass:[NSString class]] && defaultImageURL.length > 0 ) {
                
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray: dataArray];
                if(allAdsdataArray == nil )
                    allAdsdataArray = [[NSMutableArray alloc] init];
                [allAdsdataArray addObjectsFromArray:tmp] ;
                default_Imageurl_allAds =  defaultImageURL;
                base_Imageurl_allAds = baseURL;
            }
            
          //  default_Imageurl_allAds = responseDict[@"defaultImage"];
           // base_Imageurl_allAds = responseDict[@"imageBaseUrl"];
            NSLog(@"%@", allAdsdataArray);
        }   else if (![errormsg isEqualToString:@""]){
            
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message:@"No List Found" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                           [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [hud hideAnimated:YES];
        }
        [self.seeAllAdsTableView reloadData];
        [hud hideAnimated:YES];
    }
}

-(void)seeAllAdslist{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    DataClass *favobj=[DataClass getInstance];
   // NSLog(@"%@", favobj.userId);
    NSLog(@"%@", user_ID);

    //   NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"listAds"];
    
    
    
    NSString *locid;
    
    if(favobj.lastKnownLocID != nil){
        locid = favobj.lastKnownLocID;
    }else{
        locid = @"";
    }
    
    NSString *start = [NSString stringWithFormat:@"%d",_seeAllAdsStart];
   // NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"start":start,@"limit":@"5",@"category":catID,@"location":locName};

    NSDictionary *parameters =  @{@"userId":user_ID,@"language" :[DataClass currentLanguageString],@"start":start,@"limit":@"20",@"location":locid};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"listAds"];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Adding Google AD
    
//    if(allAdsdataArray.count > 3){
//
//        totalAdRows =  ((allAdsdataArray.count  - 3)/6) + 1;
//        totalCount = (allAdsdataArray.count + totalAdRows) ;
//        return totalCount;
//
//    }
    totalCount = allAdsdataArray.count;
    return totalCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        return 150;
    }
    // Adding Google AD
    
//    if (indexPath.row == 3 || ((indexPath.row - 3) % 6) == 0) {
//
//        return 50;     // setting google ad height.
//    }

    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    static NSString *cellIdentifier = @"SeeAllAds";
    
    CustomSeeAllAdsTableViewCell *adCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (totalCount > 3){
        
        if (indexPath.row == 3 )
            showAd = true;
        else {
            showAd = ((indexPath.row - 3) % 6) == 0;
        }
    }else {
        showAd = false;
        
    }
    // Adding Google AD
    
//    if (showAd  && (totalCount > 3 || indexPath.row == 3 )) {
//
//        self.bannerView = [[GADBannerView alloc]
//                           initWithAdSize:kGADAdSizeBanner];
//        CustomSeeAllAdsTableViewCell *adCellG = [[CustomSeeAllAdsTableViewCell alloc]init];
//        adCellG.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        [adCellG.contentView addSubview:_bannerView];
//
//        self.bannerView.adUnitID = @"ca-app-pub-3310088406325999/3684441066";
//        self.bannerView.rootViewController = self;
//        [self.bannerView loadRequest:[GADRequest request]];
//
//        totalNoOfAd = totalNoOfAd + 1;
//        return adCellG;
//
//    }else
    
    if(indexPath.row < 3 && !showAd){
        
        allAdsdataDict = [allAdsdataArray objectAtIndex:indexPath.row];
        
    }else if(totalCount > 3 && !showAd){
        allAdsdataDict = [allAdsdataArray objectAtIndex:indexPath.row];
//        allAdsdataDict = [allAdsdataArray objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
        
    }
    else{
       allAdsdataDict = [allAdsdataArray objectAtIndex:indexPath.row];
    }
    
   // adCell.chatBtn.tag = indexPath.row;
    NSString *url_Img = [allAdsdataDict valueForKey:@"image_url"];
    NSString *url_Img_FULL;
    if (url_Img == (id)[NSNull null]){
        url_Img_FULL = default_Imageurl_allAds;
    } else {
        url_Img_FULL = [base_Imageurl_allAds stringByAppendingPathComponent:url_Img];
    }
    adCell.image.layer.borderWidth = 1.0;
    adCell.image.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
    [adCell.image sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]];
    
    NSString *dateStr = [allAdsdataDict valueForKey:@"createdDate"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:@"MMMM YYYY"];
    NSString* newDateFormat = [dateFormat stringFromDate:date];
    dateFormat.doesRelativeDateFormatting = YES;
    
    
    adCell.title.text = [allAdsdataDict valueForKey:@"title"];
    
    NSString *loc = [allAdsdataDict valueForKey:@"location"];
    NSString *firstWord = [[loc componentsSeparatedByString:@","] objectAtIndex:0];
    
    adCell.location.text = firstWord;
    //adCell.location.text = [allAdsdataDict valueForKey:@"location"];
    
    NSString *isFeatured = [allAdsdataDict valueForKey:@"is_featured"];
    if( [isFeatured  isEqual: @"Yes"]){
        [adCell.featuredLabel setHidden:NO];
    }else{
        [adCell.featuredLabel setHidden:YES];
    }
    
    DataClass *objc=[DataClass getInstance];
    if(!objc.isEnglish ){
        adCell.featuredLabel.text = @"متميز";
    }

    //price attribt >>>>>
    if([[allAdsdataDict valueForKey:@"price"] isEqual: @""] && [[allAdsdataDict valueForKey:@"price_type"] isEqual: @""]){
        
        adCell.priceImage.hidden = true;
        adCell.price.text = @"";

        
    }else if(![[allAdsdataDict valueForKey:@"price"] isEqual: @""]){
        
        adCell.price.text = [[allAdsdataDict valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
        
        if(![[allAdsdataDict valueForKey:@"price_type"] isEqual: @""]){
            
            adCell.priceImage.hidden = false;
            NSString *priceType = [allAdsdataDict valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                adCell.priceImage.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                adCell.priceImage.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
        
    }else if([[allAdsdataDict valueForKey:@"price"] isEqual: @""]){
        
        adCell.price.text = @"";
        
        if(![[allAdsdataDict valueForKey:@"price_type"] isEqual: @""]){
            
            adCell.priceImage.hidden = false;
            NSString *priceType = [allAdsdataDict valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                adCell.priceImage.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                adCell.priceImage.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
    }
    

    
    /*
    if(![[allAdsdataDict valueForKey:@"price"] isEqual: @""]){
    adCell.price.text = [[allAdsdataDict valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
    }else{
    adCell.price.text = @"";
    }
    */
    adCell.price.textColor = [UIColor colorWithRed:0/255.0 green:178/255.0 blue:176/255.0 alpha:1];
    adCell.date.text = [@", " stringByAppendingString:(newDateFormat != nil) ? newDateFormat : @""];
    
    
    if(  totalCount == indexPath.row+1  ){
        _seeAllAdsStart = indexPath.row;
        [self performSelector:@selector(checkAndLoadList:) withObject:self afterDelay:2];
        
    }
    

    return adCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AdDetailedViewController *adDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailedVC"];
    
    if(indexPath.row < 3){

    NSDictionary *dataObj = [allAdsdataArray objectAtIndex:indexPath.row];
    NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
    
    adDetailsViewController.adId = ad_id;
    adDetailsViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:adDetailsViewController animated:YES];
    }else{
    NSDictionary *dataObj = [allAdsdataArray objectAtIndex:indexPath.row- [self calculateDED:indexPath.row]];
    NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        
    adDetailsViewController.adId = ad_id;
    adDetailsViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:adDetailsViewController animated:YES];
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

-(void) checkAndLoadList:(id) sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    if(totalseeAllAdsResult > totalCount)
        [self seeAllAdslist];
}


-(int)calculateDED:(int)row{
    // Adding Google AD
    NSLog(@"row **%d ",row);
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
    }else if ([[self.tabBarController.navigationController viewControllers] count] > 1 ){
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    } else
        [self.tabBarController setSelectedIndex:0];
    //id x =
    // id nc = [self.navigationController viewControllers];
    
    //id tc = [self.tabBarController.navigationController viewControllers];
    // NSLog(@"Log",tc);
    //[self.tabBarController unwindForSegue:<#(nonnull UIStoryboardSegue *)#> towardsViewController:<#(nonnull UIViewController *)#>
    //.navigationController popViewControllerAnimated:YES];
    
    //[self.navigationController popViewControllerAnimated:YES];
    // [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
