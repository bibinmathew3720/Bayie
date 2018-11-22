//
//  searchListViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 19/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "searchListViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DataClass.h"
#import "BayieHub.h"
# import "CustomSearchListTableViewCell.h"
#import "AdDetailedViewController.h"
#import "FilterVC.h"
#import "SortViewController.h"

@interface searchListViewController ()
{
    NSMutableArray *searchArrayList;
    NSDictionary *searchDic;
  //  NSArray *saveSearchDataArray;
 //   NSDictionary *saveSearchDataDict;
    //NSString *searchImg_Url;
    NSString *default_searchImg_Url;
  //  NSString *default_Img_Url;
    NSString *base_Img_Url;
    MBProgressHUD *hud;
    
}
@end

@implementation searchListViewController{
    BOOL showAd;
    
    NSInteger totalCount;
    NSInteger totalAdRows;
    NSInteger totalNoOfAd;

}

@synthesize categoryID,keyword,totalsearchListResult;


- (void)viewDidLoad {
    
    int searchListStart = 0;
    int totalsearchListResult =0;

    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    searchArrayList = [[NSMutableArray alloc] init];
    
    if(categoryID != nil && keyword != nil)
    {
        [self listSearchresult];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPISearchList:) name:@"BayieResponse" object:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)listSearchresult{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSError *error;
    DataClass *obj=[DataClass getInstance];

    NSString *locid;
    
    if(obj.lastKnownLocID != nil){
        locid = obj.lastKnownLocID;
    }else{
        locid = @"";
    }

    
    NSString *start = [NSString stringWithFormat:@"%d",_searchListStart];
    
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"start":start,@"limit":@"20",@"keyword":keyword,@"category":categoryID,@"location":locid};
    
   // NSDictionary *parameters =  @{@"keyword":keyword,@"location":@"1",@"category":categoryID};
    
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
   NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"listAds"];
   
}


- (void) gotBayieAPISearchList:(NSNotification *) notification{
    
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
            NSString *listImgURL = responseDict[@"imageBaseUrl"];
            NSString *defaultAdsListImgUrl = responseDict[@"defaultImage"];
            
            totalsearchListResult =  [[responseDict valueForKey:@"totalResult"] integerValue];
            
            if (nil != dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0 && [listImgURL isKindOfClass:[NSString class]] && listImgURL.length > 0 && [defaultAdsListImgUrl isKindOfClass:[NSString class]] && defaultAdsListImgUrl.length > 0)
            {
              // searchArrayList = dataArray;
                
                
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray: dataArray];
                if(searchArrayList == nil )
                    searchArrayList = [[NSMutableArray alloc] init];
                [searchArrayList addObjectsFromArray:tmp] ;
                base_Img_Url = listImgURL;
                default_searchImg_Url = defaultAdsListImgUrl;
                
            }
            
            NSLog(@"%@", searchArrayList);
            [self.searchResult reloadData];
            [hud hideAnimated:YES];
            
            
            
        }   else if (![errormsg isEqualToString:@""]){
            
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message:@"No List Found" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                           //  [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }];
            [alert addAction:okButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            [hud hideAnimated:YES];
        }
 //       [self.listingTableView reloadData];
        [hud hideAnimated:YES];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 //Google Ad
    
//    if(searchArrayList.count > 3){
//
//        totalAdRows =  ((searchArrayList.count  - 3)/6) + 1;
//        totalCount = (searchArrayList.count + totalAdRows) ;
//        return totalCount;
//    }
    totalCount = searchArrayList.count;
    return totalCount;
    // return searchArrayList.count;
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
    
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        
        AdDetailedViewController *adDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailedVC"];
    
    if(indexPath.row < 3){

        NSDictionary *dataObj = [searchArrayList objectAtIndex:indexPath.row];
        NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        
        adDetailsViewController.adId = ad_id;
        adDetailsViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:adDetailsViewController animated:YES];
    }else{
        NSDictionary *dataObj = [searchArrayList objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
        NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        
        adDetailsViewController.adId = ad_id;
        adDetailsViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:adDetailsViewController animated:YES];
 
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *Cellidentifier = @"SearchResult";
    
    CustomSearchListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier];

    
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
        
//        self.bannerView = [[GADBannerView alloc]
//                           initWithAdSize:kGADAdSizeBanner];
//        CustomSearchListTableViewCell *adCell = [[CustomSearchListTableViewCell alloc]init];
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
        
        searchDic = [searchArrayList objectAtIndex:indexPath.row];
        
    }else if(indexPath.row < 3 && !showAd){
            searchDic = [searchArrayList objectAtIndex:indexPath.row];
        
    }else if(totalCount > 3 && !showAd){
        
        searchDic = [searchArrayList objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
    }
    else{
         searchDic = [searchArrayList objectAtIndex:indexPath.row];
    }
       // searchDic = [searchArrayList objectAtIndex:indexPath.row];
        
        NSString *url_savesearchImg = [searchDic valueForKey:@"image_url"];
        NSString *url_savesearchImg_FULL;
        
        if (url_savesearchImg ==(id)[NSNull null]) {
            url_savesearchImg_FULL = default_searchImg_Url;
        } else {
            url_savesearchImg_FULL = [base_Img_Url stringByAppendingPathComponent:url_savesearchImg];
        }
        NSLog(@"Show url_Img_FULL: %@",url_savesearchImg_FULL);
        
        NSString *dateStr = [searchDic valueForKey:@"createdDate"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        [dateFormat setDateFormat:@"MMMM YYYY"];
        NSString* newDateFormat = [dateFormat stringFromDate:date];
        dateFormat.doesRelativeDateFormatting = YES;
        
        listCell.title.text = [searchDic valueForKey:@"title"];
    
    NSString *loc = [searchDic valueForKey:@"location"];
    
    NSString *firstWord = [[loc componentsSeparatedByString:@","] objectAtIndex:0];
    
    listCell.location.text = firstWord;
    
      //  listCell.location.text = [searchDic valueForKey:@"location"];
    
    NSString *isFeatured = [searchDic valueForKey:@"is_featured"];
    if( [isFeatured  isEqual: @"Yes"]){
        [listCell.isFeatured setHidden:NO];
    }else{
        [listCell.isFeatured setHidden:YES];
    }
    
    DataClass *objc=[DataClass getInstance];
    if(!objc.isEnglish ){
        listCell.isFeatured.text = @"متميز";
    }
    
    //price attribt >>>>>
    if([[searchDic valueForKey:@"price"] isEqual: @""] && [[searchDic valueForKey:@"price_type"] isEqual: @""]){
        listCell.price.text = @"";

        listCell.priceImg.hidden = true;
        
    }else if(![[searchDic valueForKey:@"price"] isEqual: @""]){
        
        listCell.price.text = [[searchDic valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
        
        if(![[searchDic valueForKey:@"price_type"] isEqual: @""]){
            
            listCell.priceImg.hidden = false;
            NSString *priceType = [searchDic valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                listCell.priceImg.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                listCell.priceImg.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
        
    }else if([[searchDic valueForKey:@"price"] isEqual: @""]){
        
        listCell.price.text = @"";
        
        if(![[searchDic valueForKey:@"price_type"] isEqual: @""]){
            
            listCell.priceImg.hidden = false;
            NSString *priceType = [searchDic valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                listCell.priceImg.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                listCell.priceImg.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
    }
    // >>>> price atrbt
    
    /*
    if(![[searchDic valueForKey:@"price"] isEqual: @""]){
       listCell.price.text = [[searchDic valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];;
    }else{
        listCell.price.text = @"";
    }
    */
        listCell.image.layer.borderWidth = 1.0;
        listCell.image.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
        
        [listCell.image sd_setImageWithURL:[NSURL URLWithString:url_savesearchImg_FULL]];
    
        listCell.date.text = [@"," stringByAppendingString:newDateFormat];
    
    if(  totalCount == indexPath.row+1  ){
        _searchListStart = indexPath.row;
        [self performSelector:@selector(checkAndLoadList:) withObject:self afterDelay:2];
        
    }
    
    return listCell;

    
    
    
        return listCell;
}

-(void) checkAndLoadList:(id) sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPISearchList:) name:@"BayieResponse" object:nil];
    if(totalsearchListResult > totalCount)
        [self listSearchresult];
}

-(IBAction)gotoFilterView:(id)sender{
    FilterVC *filterVC = [[FilterVC alloc] initWithNibName:@"FilterVC" bundle:nil];
    [self.navigationController pushViewController:filterVC animated:YES];
}
-(IBAction)gotoSorView:(id)sender{
    SortViewController *sortVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SortViewController"];
    
    [self.navigationController pushViewController:sortVC animated:YES];
}
-(int)calculateDED:(int)row{
    //Google Ad
    
 //   NSLog(@"row **%d ",row);
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


- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}


@end
