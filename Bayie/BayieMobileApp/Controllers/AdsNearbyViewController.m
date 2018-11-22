//
//  AdsNearbyViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 05/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "AdsNearbyViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "BayieHub.h"
#import "AdDetailedViewController.h"
#import "DataClass.h"
@interface AdsNearbyViewController ()
{
    NSMutableArray *dataArray;
    NSDictionary *dataDictionary;
    NSString *imgUrl;
    NSString *defaultImgUrl;
    MBProgressHUD *hud;
}
@end

@implementation AdsNearbyViewController{
    BOOL showAd;
    
    NSInteger totalCount;
    NSInteger totalAdRows;
    NSInteger totalNoOfAd;
    
}

@synthesize totalNearResult;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adsNearbyTableView.tableFooterView = [UIView new];
    self.adsNearbyTableView.estimatedRowHeight = 70;
    self.adsNearbyTableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    
    dataArray = [[NSMutableArray alloc] init];
    _nearStart =0;
    [super viewWillAppear:animated];
    [self nearbyAdsList];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) gotBayieAPIData:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"BayieResponse"]){
        NSDictionary *responseDict = notification.object;
        NSString *errormsg = @"";
        if([responseDict isKindOfClass:[NSError class]]){
            NSError *error = (NSError *)responseDict;
            if(error.code==400)
                errormsg = @"Unable to connect server. Please check network connection.";
            else
                errormsg = @"Unable to connect server.";
        }
        
        if ([errormsg isEqualToString:@""]) {
            
            NSArray *dataArrayN = responseDict[@"data"];
            NSString *baseURL = responseDict[@"baseUrl"];
            NSString *defaultImageURL = responseDict[@"defaultImage"];
            //
            totalNearResult =  [[responseDict valueForKey:@"totalResult"] integerValue];
            
            if (nil != dataArrayN && [dataArrayN isKindOfClass:[NSArray class]] && dataArrayN.count > 0 && [baseURL isKindOfClass:[NSString class]] && baseURL.length > 0 && [defaultImageURL isKindOfClass:[NSString class]] && defaultImageURL.length > 0 ) {
                
                //
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray: dataArrayN];
                if(dataArray == nil )
                dataArray = [[NSMutableArray alloc] init];
                [dataArray addObjectsFromArray:tmp] ;
                
                //
                defaultImgUrl =  defaultImageURL;
                imgUrl = baseURL;
                 [self.adsNearbyTableView reloadData];
            }
        }   else if (![errormsg isEqualToString:@""]){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: errormsg
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [hud hideAnimated:YES];
        }
        [self.adsNearbyTableView reloadData];
        [hud hideAnimated:YES];
    }
}

-(void)nearbyAdsList{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSError *error;
   // NSString *jsonString = @"{\"location\":\"Al Buraimi, Oman\"}";
    
    
    NSString *nearloc;
    DataClass *obj=[DataClass getInstance];
    if(obj.lastKnownLoc != nil){
        nearloc = obj.lastKnownLoc;
    }else{
        nearloc = @"";
    }
    NSString *start = [NSString stringWithFormat:@"%d",_nearStart];

   // NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"start":start,@"limit":@"5"};
    
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"location":nearloc,@"start":start,@"limit":@"20"};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"nearByAds"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  //Google Ad
    
//    if(dataArray.count > 3){
//
//        totalAdRows =  ((dataArray.count  - 3)/6) + 1;
//        totalCount = (dataArray.count + totalAdRows) ;
//        return totalCount;
//
//    }
    totalCount = dataArray.count;
    return totalCount;
    
  //  return dataArray.count;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.adsNearbyTableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Google Ad
//    if (indexPath.row == 3 || ((indexPath.row - 3) % 6) == 0) {
//        
//        return 50;     // setting google ad height.
//    }

    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"NearbyAdsCell";
    
    AdsNearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
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
        dataDictionary = [dataArray objectAtIndex:indexPath.row];
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
//        AdsNearbyTableViewCell *adCell = [[AdsNearbyTableViewCell alloc]init];
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
        
        dataDictionary = [dataArray objectAtIndex:indexPath.row];
        
    }else if(totalCount > 3 && !showAd){
        
        dataDictionary = [dataArray objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
        
    }
    
    NSString *url_Img = [dataDictionary valueForKey:@"image_url"];
    NSString *url_Img_FULL;

    if (url_Img == nil || [url_Img isEqual:[NSNull null]]||url_Img.length==0) {
        url_Img_FULL = defaultImgUrl;
    }else {
        url_Img_FULL = [imgUrl stringByAppendingPathComponent:url_Img];
    }
    
    cell.adImg.layer.borderWidth = 1.0;
    cell.adImg.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
    [cell.adImg sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]];
    cell.adTitle.text = [dataDictionary valueForKey:@"title"];
    
    NSString *isFeatured = [dataDictionary valueForKey:@"is_featured"];
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
    if([[dataDictionary valueForKey:@"price"] isEqual: @""] && [[dataDictionary valueForKey:@"price_type"] isEqual: @""]){
        cell.price.text = @"";

        cell.priceImage.hidden = true;
        
    }else if(![[dataDictionary valueForKey:@"price"] isEqual: @""]){
        
        cell.price.text = [[dataDictionary valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
        
        if(![[dataDictionary valueForKey:@"price_type"] isEqual: @""]){
            
            cell.priceImage.hidden = false;
            NSString *priceType = [dataDictionary valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                cell.priceImage.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                cell.priceImage.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
        
    }else if([[dataDictionary valueForKey:@"price"] isEqual: @""]){
        
        cell.price.text = @"";
        
        if(![[dataDictionary valueForKey:@"price_type"] isEqual: @""]){
            
            cell.priceImage.hidden = false;
            NSString *priceType = [dataDictionary valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                cell.priceImage.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                cell.priceImage.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
    }
    cell.price.textColor = [UIColor colorWithRed:0/255.0 green:178/255.0 blue:176/255.0 alpha:1];
    cell.location.text = [dataDictionary valueForKey:@"location"];
    
    
    if(  totalCount == indexPath.row+1  ){
        _nearStart = indexPath.row;
        [self performSelector:@selector(NearcheckAndLoadList:) withObject:self afterDelay:2];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AdDetailedViewController *adDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailedVC"];
    
    if(indexPath.row < 3){

    NSDictionary *dataDic = [dataArray objectAtIndex:indexPath.row];
    NSString *ad_id  = @"";
    if([dataDic valueForKey:@"adId"])
        ad_id= [dataDic valueForKey:@"adId"];
    if([dataDic valueForKey:@"ad_Id"])
        ad_id = ad_id= [dataDic valueForKey:@"ad_Id"];
    adDetailsViewController.adId = ad_id;
    adDetailsViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:adDetailsViewController animated:YES];
    }else{
        
   NSDictionary *dataDic = [dataArray objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
   NSString *ad_id = [dataDic valueForKey:@"adId"];
        
   adDetailsViewController.adId = ad_id;
   adDetailsViewController.hidesBottomBarWhenPushed = true;
   [self.navigationController pushViewController:adDetailsViewController animated:YES];
    }
    
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
    
    [hud hideAnimated:YES];
}

- (IBAction)searchButton:(id)sender {
}

-(void) NearcheckAndLoadList:(id) sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    if(totalNearResult > totalCount)
        [self nearbyAdsList];
}

@end
