//
//  TrendingAdsListViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 04/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "TrendingAdsListViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "BayieHub.h"
#import "AdDetailedViewController.h"
#import "DataClass.h"

@interface TrendingAdsListViewController ()
{
    NSMutableArray *dataDict;
    NSDictionary *dictObject;
    NSString *base_TrendImageurl;
    NSString *default_TrendImageurl;
    MBProgressHUD *hud;

}
@end

@implementation TrendingAdsListViewController{
    BOOL showAd;
    
    NSInteger totalCount;
    NSInteger totalAdRows;
    NSInteger totalNoOfAd;
    

}

@synthesize totalTrendResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.trendingAdsTableView.tableFooterView = [UIView new];
    _trendingAdsTitle
    .text = [NSString stringWithFormat:NSLocalizedString(@"TRENDING_ADS", nil), @(1000000)];
    int trendStart = 0;
    int totalTrendResult =0;
    self.trendingAdsTableView.estimatedRowHeight = 70;
    self.trendingAdsTableView.rowHeight = UITableViewAutomaticDimension;

}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    _trendStart =0;
    [self listAds];
    [super viewWillAppear:animated];
}

- (void) gotBayieAPIData:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occured" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                           
                                           
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [hud hideAnimated:YES];
            
            return;
        }
        
        NSDictionary *responseDict = notification.object;
        NSString *errormsg = responseDict[@"error"];
        
        if ([errormsg isEqualToString:@""]) {
            
            
            NSArray *dataArray = responseDict[@"data"];
            NSString *baseURL = responseDict[@"baseUrl"];
            NSString *defaultImageURL = responseDict[@"defaultImage"];
            //
            totalTrendResult =  [[responseDict valueForKey:@"totalResult"] integerValue];

            
            if (nil != dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0 && [baseURL isKindOfClass:[NSString class]] && baseURL.length > 0 && [defaultImageURL isKindOfClass:[NSString class]] && defaultImageURL.length > 0 ) {
                
                //
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray: dataArray];
                if(dataDict == nil )
                    dataDict = [[NSMutableArray alloc] init];
                [dataDict addObjectsFromArray:tmp] ;
                
                //
                default_TrendImageurl =  defaultImageURL;
                base_TrendImageurl = baseURL;
            }
        }   else if (![errormsg isEqualToString:@""]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [hud hideAnimated:YES];
        }
        [self.trendingAdsTableView reloadData];
        [hud hideAnimated:YES];
    }
}
-(void)listAds{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    DataClass *obj=[DataClass getInstance];

    NSError *error;

    NSString *start = [NSString stringWithFormat:@"%d",_trendStart];
    if (start ==nil)
        start =@"0";
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"start":start,@"limit":@"20"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"popularAds"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //Google Ad
//        if (indexPath.row == 3 || ((indexPath.row - 3) % 6) == 0) {
//            return 50;     // setting google ad height.
//        }else{
//        return 140;
//        }
    }
    if (indexPath.row == 3 || ((indexPath.row - 3) % 6) == 0) {
        //Google Ad
        //return 50;     // setting google ad height.
    }

    return UITableViewAutomaticDimension;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(dataDict.count > 3){
        //Google Ad
        //totalAdRows =  ((dataDict.count  - 3)/6) + 1;
        totalCount = (dataDict.count + totalAdRows) ;
        return totalCount;
        
    }
    totalCount = dataDict.count;
    return totalCount;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.trendingAdsTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  static NSString *cellIdentifier = @"TrendingAdsCell";
    
  TrendingAdsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
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
        dictObject = [dataDict objectAtIndex:indexPath.row];
        //Google Ad
        
//        if( UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
//            self.bannerView = [[GADBannerView alloc]
//                               initWithAdSize:kGADAdSizeSmartBannerPortrait];
//        }else{
//            
//            self.bannerView = [[GADBannerView alloc]
//                               initWithAdSize:kGADAdSizeSmartBannerLandscape];
//        }
//        
//        
//        TrendingAdsListTableViewCell *adCell = [[TrendingAdsListTableViewCell alloc]init];
//        
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
        
        dictObject = [dataDict objectAtIndex:indexPath.row];
        
    }else if(totalCount > 3 && !showAd){
        
        dictObject = [dataDict objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
        
    }
    
    NSString *url_Img = [dictObject valueForKey:@"image_url"];
    
    NSString *url_Img_FULL;
    if(url_Img == nil || [url_Img isEqual:[NSNull null]]){
        url_Img_FULL = default_TrendImageurl;
    }else{
        url_Img_FULL = [base_TrendImageurl stringByAppendingPathComponent:url_Img];
        
    }
    
    cell.image.layer.borderWidth = 1.0;
    cell.image.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]];
    cell.descriptionLabel.text = [dictObject valueForKey:@"title"];
    cell.location.text = [dictObject valueForKey:@"location"];
    
    
    NSString *isFeatured = [dictObject valueForKey:@"is_featured"];
    if( [isFeatured  isEqual: @"Yes"]){
        [cell.isFeaturedLabel setHidden:NO];
    }else{
        [cell.isFeaturedLabel setHidden:YES];
    }
    DataClass *objc=[DataClass getInstance];
    if(!objc.isEnglish ){
        cell.isFeaturedLabel.text = @"متميز";
    }
    
    //price attribt >>>>>
    if([[dictObject valueForKey:@"price"] isEqual: @""] && [[dictObject valueForKey:@"price_type"] isEqual: @""]){
        cell.price.text = @"";

        cell.priceImage.hidden = true;
        
    }else if(![[dictObject valueForKey:@"price"] isEqual: @""]){
        
        cell.price.text = [[dictObject valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
        
        if(![[dictObject valueForKey:@"price_type"] isEqual: @""]){
            
            cell.priceImage.hidden = false;
            NSString *priceType = [dictObject valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                cell.priceImage.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                cell.priceImage.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
        
    }else if([[dictObject valueForKey:@"price"] isEqual: @""]){
        
        cell.price.text = @"";
        
        if(![[dictObject valueForKey:@"price_type"] isEqual: @""]){
            
            cell.priceImage.hidden = false;
            NSString *priceType = [dictObject valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                cell.priceImage.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                cell.priceImage.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
    }
    cell.price.textColor = [UIColor colorWithRed:0/255.0 green:178/255.0 blue:176/255.0 alpha:1];
    
    if(  totalCount == indexPath.row+1  ){
        _trendStart = indexPath.row;
        [self performSelector:@selector(checkAndLoadList:) withObject:self afterDelay:2];
        
    }

   return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AdDetailedViewController *adDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailedVC"];
    
    if(indexPath.row < 3){
    
    NSDictionary *dataObj = [dataDict objectAtIndex:indexPath.row];
    NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
    
    adDetailsViewController.adId = ad_id;
    adDetailsViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:adDetailsViewController animated:YES];
        
    }else{
        
    NSDictionary *dataObj = [dataDict objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
    NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        
    adDetailsViewController.adId = ad_id;
    adDetailsViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:adDetailsViewController animated:YES];
    }
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    
    [hud hideAnimated:YES];
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

-(void) checkAndLoadList:(id) sender{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    if(totalTrendResult > totalCount)
        [self listAds];
}

- (IBAction)searchButton:(id)sender {
    
    
}
@end
