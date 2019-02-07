//
//  ListingViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 10/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#define CellInterItemSpacing 5
#define CatogoryCellReuseIdentifier @"listingCell"

#import "FilterVC.h"
#import "AuctionDetailVC.h"
#import "ListingViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "DataClass.h"
#import "SortViewController.h"
#import "BayieHub.h"
#import "SeachLocationViewController.h"
#import "AdDetailedViewController.h"

#import "AuctionListingCVC.h"
#import "ListingCollectionCell.h"

//NSString *adsListImg_Url = @"http://www.productiondemos.com/bayie";

@interface ListingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SortViewControllerDelegate,FilterVCDelegate,AuctionDetailVCDelegate>
{
    NSMutableArray *subcatArrayList;
    NSDictionary *subcatDic;
    
    NSMutableArray *saveSearchDataArray;
    NSDictionary *saveSearchDataDict;
    
    NSString *adsListImg_Url;
    NSString *default_adsListImg_Url;
    NSString *default_Img_Url;
    NSString *base_Img_Url;
    MBProgressHUD *hud;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *listingCollectionView;

@property (nonatomic, strong) NSMutableArray *saveSearchimagesMutArray;
@property (nonatomic, strong) NSMutableArray *dataDictimagesMutArray;
@property (nonatomic, assign) BOOL isApiCalling;
@end

@implementation ListingViewController
{
    BOOL fromSort;
    BOOL showAd;
    NSInteger totalAdRows;
    NSInteger totalNoOfAd;
    NSInteger totalCount;
    
    NSInteger totalCountsort;
    NSInteger totalAdRowssort;
    NSInteger totalNoOfAdsort;
    
}
@synthesize lastApiCall;

@synthesize catID,catTitle,totalSubCatResult,totalSortResult,lastLoc;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialisation];
    [self updateLocation];
    DataClass *obj=[DataClass getInstance];
    if(obj.lastKnownLocID != nil){
        lastLoc = obj.lastKnownLocID;
    }else{
        lastLoc = @"";
    }
    [self apiInitialisation];
    
    /*
     if (obj.isFromSort){
     //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataSort:) name:@"BayieResponse" object:nil];
     self.lastApiCall = @"Sort";
     fromSort = obj.isFromSort;
     NSLog(@"frommmmm sortttt %@", obj.sortType);
     DataClass *objc=[DataClass getInstance];
     NSLog(@"%@", objc.categoryTitle);
     NSString *uppercase =  [obj.categoryTitle uppercaseString];
     _categoryTitle.text =uppercase;
     [self ListSaveSearch];
     [self.listingTableView reloadData];
     
     }else{
     //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataList:) name:@"BayieResponse" object:nil];
     fromSort = false;
     NSLog(@"notttttt fromm sorttttttt%@", catTitle);
     NSLog(@"notttttt fromm sorttttttt%@", catID);
     self.categoryTitle.text = [catTitle uppercaseString];
     DataClass *catobj = [DataClass getInstance];
     NSString *uppercase = [catTitle uppercaseString];
     catobj.categoryTitle= uppercase;
     catobj.categoryId = catID;
     
     [self subCatList];
     
     }
     */
    
    self.listingTableView.tableFooterView = [UIView new];
    if (self.pageType == PageTypeAuctions){
        [self registeringAuctionListCVC];
    }
}

-(void)registeringAuctionListCVC{
    [self.listingCollectionView registerNib:[UINib nibWithNibName:@"AuctionListingCVC" bundle:nil] forCellWithReuseIdentifier:@"auctionListingCVC"];
}

-(void)apiInitialisation{
    DataClass *obj=[DataClass getInstance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIDataList:) name:@"BayieResponse" object:nil];
    [self updateLocation];
    self.categoryTitle.text = [obj.categoryTitle uppercaseString];
    [self callingApis];
}

-(void)initialisation{
    self.saveSearchimagesMutArray = [[NSMutableArray alloc] init];
    self.dataDictimagesMutArray = [[NSMutableArray alloc] init];
    if (self.pageType == PageTypeAuctions){
        self.location.hidden = YES;
        self.locationButton.hidden = YES;
        self.downArrowIcon.hidden = YES;
        self.downArrowButton.hidden = YES;
        self.searchButton.hidden = YES;
        self.sortFilterHeiCnstraint.constant = 0.0;
        self.sortButton.hidden = YES;
        self.filterButton.hidden = YES;
        self.middleBorderView.hidden = YES;
        //self.categoryTopConstraint.constant = 0;
    }
}

-(void)updateLocation{
    DataClass *locOb=[DataClass getInstance];
    NSString *firstWord = [[locOb.lastKnownLoc componentsSeparatedByString:@","] objectAtIndex:0];
    if(locOb.lastKnownLoc != nil){
        _location.text = firstWord;
    }else{
        _location.text = [NSString stringWithFormat:NSLocalizedString(@"LOCATION_SELECTION", nil), @(1000000)];
    }
    
}

- (void) gotBayieAPIDataListNotification:(NSNotification *) notification{
    //if at any time notfi.object is error or null hide the HUD
    self.isApiCalling = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UITabBarController *tabBarController = self.tabBarController;
    tabBarController.tabBar.hidden = false;
}

-(BOOL)hidesBottomBarWhenPushed
{
    return NO;
}

- (void) gotBayieAPIDataList:(NSNotification *) notification{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.isApiCalling = NO;
    if ([[notification name] isEqualToString:@"BayieResponse"]){
         [self.listingTableView reloadData];
        [self.listingCollectionView reloadData];
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
           // [self.listingTableView reloadData];
            return;
        }
        
        NSDictionary *responseDict = notification.object;
        NSString *errormsg = responseDict[@"error"];
        
        if ([errormsg isEqualToString:@""]) {
            self.noRecordsLabel.hidden = YES;
            NSArray *dataArray = responseDict[@"data"];
            NSString *baseURL = responseDict[@"imageBaseUrl"];
            NSString *defaultImageURL = responseDict[@"defaultImage"];
            //
            totalSubCatResult =  [[responseDict valueForKey:@"totalResult"] integerValue];
            //
            if (nil != dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0 && [baseURL isKindOfClass:[NSString class]] && baseURL.length > 0 && [defaultImageURL isKindOfClass:[NSString class]] && defaultImageURL.length > 0 ) {
             
                //
                NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray: dataArray];
                if(subcatArrayList == nil )
                     subcatArrayList = [[NSMutableArray alloc] init];
                [subcatArrayList addObjectsFromArray:tmp] ;
                
                //
                default_Img_Url =  defaultImageURL;
                base_Img_Url = baseURL;
                [self.listingTableView reloadData];
                [self.listingCollectionView reloadData];
            }
            
        }   else if (![errormsg isEqualToString:@""]){
            if([errormsg isEqualToString:@"Location not mentioned"]){
                NSLog(@"Location not mentioned case ");
            }
            else{
                UIAlertController * alert =[UIAlertController
                                            alertControllerWithTitle:@"Bayie" message: errormsg preferredStyle:UIAlertControllerStyleAlert];
                self.noRecordsLabel.hidden = NO;
                self.noRecordsLabel.text = errormsg;
                UIAlertAction* okButton = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               if( !([errormsg rangeOfString: @"No Records Found"].location == NSNotFound  )   ){
                                                   subcatArrayList = [[NSMutableArray alloc] init];
                                                   [self.listingTableView reloadData];
                                                   [self.listingCollectionView reloadData];
                                               }
                                               
                                           }];
                [alert addAction:okButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            [hud hideAnimated:YES];
        }
        [hud hideAnimated:YES];
    }
}


-(void)subCatList{
    if(!self.isApiCalling){
         self.isApiCalling = YES;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
        //  NSString *URLString = [[NSString stringWithFormat:NSLocalizedString(@"ADS_MANAGEMENT_URL", nil)] stringByAppendingString:@"listAds"];
        NSError *error;
        // NSDictionary *parameters =  @{@"language":@"English",@"start":@"0",@"limit":@"20",@"location":@"1",@"category":catID};
        
        
        DataClass *obj=[DataClass getInstance];
        
        NSString *locName;
        
        if(obj.lastKnownLocID != nil){
            locName = obj.lastKnownLocID;
        }else{
            locName = @"";
        }
        
        
        //
        NSString *start = [NSString stringWithFormat:@"%d",_subCatStart];
        if(start ==0 ){
            NSMutableArray *tmp = [[NSMutableArray alloc] init];
            subcatArrayList = [[NSMutableArray alloc] init];
        }
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
       // @"sort":obj.sortType
        
//        if(obj.attributeDict!=nil){
//            parameters =  @{@"language":[DataClass currentLanguageString],@"start":start,@"limit":@"20",@"category":obj.categoryId,@"location":locName,@"attributes":obj.attributeDict};
//        }
//        else{
//            parameters =  @{@"language":[DataClass currentLanguageString],@"start":start,@"limit":@"20",@"category":obj.categoryId,@"location":locName};
//        }
        [parameters setValue:[DataClass currentLanguageString] forKey:@"language"];
        [parameters setValue:start forKey:@"start"];
        [parameters setValue:@"20" forKey:@"limit"];
        [parameters setValue:obj.categoryId forKey:@"category"];
        [parameters setValue:locName forKey:@"location"];
        if(obj.attributeDict!=nil){
            [parameters setValue:obj.attributeDict forKey:@"attributes"];
        }
        if (obj.sortType.length>0 && obj.sortType != nil){
            [parameters setValue:obj.sortType forKey:@"sort"];
        }
        NSLog(@"Parameters:%@",parameters);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"listAds"];
    }
}

//Auction List

-(void)callingAuctionListApi{
    if(!self.isApiCalling){
        self.isApiCalling = YES;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
        NSError *error;
        DataClass *obj=[DataClass getInstance];
        NSString *start = [NSString stringWithFormat:@"%d",_subCatStart];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:[DataClass currentLanguageString] forKey:@"language"];
        [parameters setValue:start forKey:@"start"];
        [parameters setValue:@"20" forKey:@"limit"];
        [parameters setValue:obj.categoryId forKey:@"category"];
        if(obj.attributeDict!=nil){
            [parameters setValue:obj.attributeDict forKey:@"attributes"];
        }
        if (obj.sortType.length>0 && obj.sortType != nil){
            [parameters setValue:obj.sortType forKey:@"sort"];
        }
        NSLog(@"Parameters:%@",parameters);
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"listAuctions"];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(subcatArrayList.count > 3){
        //Google Ad
        //totalAdRows =  ((subcatArrayList.count  - 3)/6) + 1;
        totalCount = (subcatArrayList.count+totalAdRows) ;
        return totalCount;
        
    }
    totalCount = subcatArrayList.count;
    return totalCount;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AdDetailedViewController *adDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailedVC"];
    
    // listing data
    if(indexPath.row < 3){
        
        //  AdDetailedViewController *adDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailedVC"];
        NSDictionary *dataObj = [subcatArrayList objectAtIndex:indexPath.row];
        NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        
        adDetailsViewController.adId = ad_id;
        adDetailsViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:adDetailsViewController animated:YES];
    }else{
        //   AdDetailedViewController *adDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailedVC"];
        NSDictionary *dataObj = [subcatArrayList objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
        NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        
        adDetailsViewController.adId = ad_id;
        adDetailsViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:adDetailsViewController animated:YES];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //Google Ad
//        if (indexPath.row == 3 || ((indexPath.row - 3) % 6) == 0) {
//            return 50;     // setting google ad height.
//        }else{
            return 140;
//        }
    }
    //Google Ad
//    if (indexPath.row == 3 || ((indexPath.row - 3) % 6) == 0) {
//        
//        return 50;     // setting google ad height.
//    }
    return 130;
}

#pragma mark - Collection View Datasources

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return subcatArrayList.count;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    subcatDic = [subcatArrayList objectAtIndex:indexPath.row ];
    NSString *url_Img = [subcatDic valueForKey:@"image_url"];
    NSString *urlImg_FULL;
    if (url_Img ==(id)[NSNull null]) {
        urlImg_FULL = default_Img_Url;
    }else{
        urlImg_FULL =[base_Img_Url stringByAppendingPathComponent:url_Img];
    }
    NSString *dateStr = [subcatDic valueForKey:@"createdDate"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:@"MMMM YYYY"];
    NSString* newDateFormat = [dateFormat stringFromDate:date];
    dateFormat.doesRelativeDateFormatting = YES;
    NSString *loc = [subcatDic valueForKey:@"location"];
    NSString *firstWord = [[loc componentsSeparatedByString:@","] objectAtIndex:0];
    if (self.pageType == PageTypeAuctions){
        AuctionListingCVC *auctionListingCVC = [collectionView dequeueReusableCellWithReuseIdentifier:@"auctionListingCVC" forIndexPath:indexPath];
        auctionListingCVC.adNameLabel.text = [NSString stringWithFormat:@"%@",[subcatDic valueForKey:@"title"]];
        //auctionListingCVC.locationNameLabel.text = [firstWord stringByAppendingString:newDateFormat];
        auctionListingCVC.locationNameLabel.text = [NSString stringWithFormat:@"%@",[subcatDic valueForKey:@"description"]];
        if(![[subcatDic valueForKey:@"current_bid_amount"] isEqual: @""]){
            auctionListingCVC.priceLabel.text = [[subcatDic valueForKey:@"current_bid_amount"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
        }
        else{
            auctionListingCVC.priceLabel.text = @"";
        }
        [auctionListingCVC.adImageView sd_setImageWithURL:[NSURL URLWithString:urlImg_FULL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:image,@"image",[NSString stringWithFormat:@"%ld",(long)indexPath.row],@"indexRow", nil];
            [self.dataDictimagesMutArray addObject:dict];
            [self.listingCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        }];
        NSString *timeString = NSLocalizedString(@"Expired", @"Expired");
        [auctionListingCVC.timerButton setTitle:timeString forState:UIControlStateNormal];
        auctionListingCVC.auctionDetails = subcatDic;
        if(  totalCount == indexPath.row+1  ){
            _subCatStart = indexPath.row+1 - [self calculateDED:indexPath.row];
            [self performSelector:@selector(checkAndLoadList:) withObject:self afterDelay:2];
            
        }
        return auctionListingCVC;
    }
    else{
        ListingCollectionCell *catCell = [collectionView dequeueReusableCellWithReuseIdentifier:CatogoryCellReuseIdentifier
                                                                                   forIndexPath:indexPath];
        catCell.adNameLabel.text = [NSString stringWithFormat:@"%@",[subcatDic valueForKey:@"title"]];
        catCell.locationLabel.text = [firstWord stringByAppendingString:newDateFormat];
        if([[subcatDic valueForKey:@"price"] isEqual: @""]){
            catCell.priceView.hidden = true;
        }else if(![[subcatDic valueForKey:@"price"] isEqual: @""]){
            catCell.priceView.hidden = false;
            catCell.priceLabel.text = [[subcatDic valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
        }
        [catCell.catImageView sd_setImageWithURL:[NSURL URLWithString:urlImg_FULL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:image,@"image",[NSString stringWithFormat:@"%ld",(long)indexPath.row],@"indexRow", nil];
            [self.dataDictimagesMutArray addObject:dict];
            [self.listingCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        }];
        
        
        //
        if(  totalCount == indexPath.row+1  ){
            _subCatStart = indexPath.row+1 - [self calculateDED:indexPath.row];
            [self performSelector:@selector(checkAndLoadList:) withObject:self afterDelay:2];
            
        }
        return catCell;
    }
    //
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.pageType == PageTypeAuctions){
        NSDictionary *dataObj = [subcatArrayList objectAtIndex:indexPath.row];
        NSString *ad_id = [dataObj valueForKey:@"slug"];
        
        AuctionDetailVC *auctionDetailVC = [[AuctionDetailVC alloc] initWithNibName:@"AuctionDetailVC" bundle:nil];
        auctionDetailVC.auctionDetailDelegate = self;
        auctionDetailVC.adId = ad_id;
        [self.navigationController pushViewController:auctionDetailVC animated:YES];
    }
    else{
        AdDetailedViewController *adDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdDetailedVC"];
        // listing data
        NSDictionary *dataObj = [subcatArrayList objectAtIndex:indexPath.row];
        NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
        adDetailsViewController.adId = ad_id;
        adDetailsViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:adDetailsViewController animated:YES];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSPredicate *indexPredicate = [NSPredicate predicateWithFormat:@"SELF.indexRow == %@",[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    NSArray *indexArray;
    indexArray  = [self.dataDictimagesMutArray filteredArrayUsingPredicate:indexPredicate];
  
    CGFloat labelHeights = 0;
    if (self.pageType == PageTypeAuctions){
        labelHeights = 100;
    }
    else{
        labelHeights = 50;
    }
    if(indexArray.count>0){
        CGFloat cellWidth = (self.view.frame.size.width-3*CellInterItemSpacing)/2;
        UIImage *imag = [[indexArray firstObject] valueForKey:@"image"];
        UIImage *scaledImage = [self imageWithImage:imag scaledToWidth:cellWidth];
        return CGSizeMake(cellWidth, scaledImage.size.height+labelHeights);
    }
    return CGSizeMake((self.view.frame.size.width-3*CellInterItemSpacing)/2, 100+labelHeights);
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return CellInterItemSpacing;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return CellInterItemSpacing;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.listingTableView reloadData];
    [self.listingCollectionView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if(indexPath.row > totalCountsort){
//       CustomSortTableViewCell *adCell = [[CustomSortTableViewCell alloc]init];
//        return adCell;
//    }
    
    static NSString *catCellidentifier = @"ListCell";
    CustomListingTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:catCellidentifier];
    
    // data load after sort
    if(fromSort){
        if (totalCountsort > 3){
            
            if (indexPath.row == 3 )
                showAd = true;
            else {
                showAd = ((indexPath.row - 3) % 6) == 0;
            }
        }else {
            showAd = false;
            
        }
        
       if (showAd  && (totalCountsort > 3 || indexPath.row == 3 )) {
           //Without Google Ad
           saveSearchDataDict = [saveSearchDataArray objectAtIndex:indexPath.row];
           //Google Ad
//           
//           if( UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
//               self.bannerView = [[GADBannerView alloc]
//                                  initWithAdSize:kGADAdSizeSmartBannerPortrait];
//           }else{
//           
//        self.bannerView = [[GADBannerView alloc]
//                               initWithAdSize:kGADAdSizeSmartBannerLandscape];
//           }
//           
//           CustomListingTableViewCell *adCell = [[CustomListingTableViewCell alloc]init];
//           adCell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            [adCell.contentView addSubview:_bannerView];
//            
//            self.bannerView.adUnitID = @"ca-app-pub-3310088406325999/3684441066";
//            self.bannerView.rootViewController = self;
//            [self.bannerView loadRequest:[GADRequest request]];
//            
//            totalNoOfAdsort = totalNoOfAdsort + 1;
 //           return adCell;
            
        }else if(indexPath.row < 3 && !showAd){
            
            saveSearchDataDict = [saveSearchDataArray objectAtIndex:indexPath.row];
   
        }else if(totalCountsort > 3 && !showAd){
            
            saveSearchDataDict = [saveSearchDataArray objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
        }
        
        
        NSString *url_savesearchImg = [saveSearchDataDict valueForKey:@"image_url"];
        NSString *url_savesearchImg_FULL;
        
        if (url_savesearchImg ==(id)[NSNull null]) {
            url_savesearchImg_FULL = default_adsListImg_Url;
        } else {
            url_savesearchImg_FULL = [adsListImg_Url stringByAppendingPathComponent:url_savesearchImg];
        }
        
        NSString *dateStr = [saveSearchDataDict valueForKey:@"createdDate"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        [dateFormat setDateFormat:@"MMMM YYYY"];
        NSString* newDateFormat = [dateFormat stringFromDate:date];
        dateFormat.doesRelativeDateFormatting = YES;
        
        listCell.title.text = [saveSearchDataDict valueForKey:@"title"];
        
        
        NSString *loc = [saveSearchDataDict valueForKey:@"location"];
        
        NSString *firstWord = [[loc componentsSeparatedByString:@","] objectAtIndex:0];
        
        listCell.location.text = firstWord;
        
        
        NSString *isFeatured = [saveSearchDataDict valueForKey:@"is_featured"];
        if( [isFeatured  isEqual: @"Yes"]){
            [listCell.isFeatured setHidden:NO];
        }else{
            [listCell.isFeatured setHidden:YES];
        }
        
        DataClass *objc=[DataClass getInstance];
        
        if(!objc.isEnglish ){
            listCell.isFeatured.text = @"متميز";
        }
        
        

        /*
        if(![[saveSearchDataDict valueForKey:@"price"] isEqual: @""]){
            
        listCell.price.text = [[saveSearchDataDict valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];;
            }else{
        listCell.price.text = @"";
        }
        */
        
      // price attribute
        
        if([[saveSearchDataDict valueForKey:@"price"] isEqual: @""] && [[saveSearchDataDict valueForKey:@"price_type"] isEqual: @""]){
            
            listCell.priceImg.hidden = true;
            listCell.price.text = @"";

            
        }else if(![[saveSearchDataDict valueForKey:@"price"] isEqual: @""]){
            
            listCell.price.text = [[saveSearchDataDict valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
            
            if(![[saveSearchDataDict valueForKey:@"price_type"] isEqual: @""]){
                
                listCell.priceImg.hidden = false;
                NSString *priceType = [saveSearchDataDict valueForKey:@"price_type"];
                
                if([priceType isEqualToString:@"Exchange"]){
                    
                    listCell.priceImg.image = [UIImage imageNamed: @"price_exchange"];
                    
                }else if([priceType isEqualToString:@"Negotiable"]){
                    
                    listCell.priceImg.image = [UIImage imageNamed: @"price_negotiable"];
                }
            }
            
            
        }else if([[saveSearchDataDict valueForKey:@"price"] isEqual: @""]){
            
            listCell.price.text = @"";
            
            if(![[saveSearchDataDict valueForKey:@"price_type"] isEqual: @""]){
                
                listCell.priceImg.hidden = false;
                NSString *priceType = [saveSearchDataDict valueForKey:@"price_type"];
                
                if([priceType isEqualToString:@"Exchange"]){
                    
                    listCell.priceImg.image = [UIImage imageNamed: @"price_exchange"];
                    
                }else if([priceType isEqualToString:@"Negotiable"]){
                    
                    listCell.priceImg.image = [UIImage imageNamed: @"price_negotiable"];
                }
            }
            
        }
        // price attribute^

        listCell.image.layer.borderWidth = 1.0;
        listCell.image.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
        
        [listCell.image sd_setImageWithURL:[NSURL URLWithString:url_savesearchImg_FULL]];
        
        listCell.dateLabel.text = [@"," stringByAppendingString:newDateFormat];

        
        if(  totalCountsort == indexPath.row+1  ){
            _sortStart = indexPath.row +1 - [self calculateDED:indexPath.row] ;
            [self performSelector:@selector(checkAndLoadList:) withObject:self afterDelay:2];
            
        }

        
        
       return listCell;
    }else {
        // long row = [indexPath row];
        
        
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
            subcatDic = [subcatArrayList objectAtIndex:indexPath.row];
            //Google Ad
//            if( UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
//                self.bannerView = [[GADBannerView alloc]
//                                   initWithAdSize:kGADAdSizeSmartBannerPortrait];
//            }else{
//                
//                self.bannerView = [[GADBannerView alloc]
//                                   initWithAdSize:kGADAdSizeSmartBannerLandscape];
//            }
//            
//            CustomListingTableViewCell *adCell = [[CustomListingTableViewCell alloc]init];
//            adCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            [adCell.contentView addSubview:_bannerView];
//            
//            self.bannerView.adUnitID = @"ca-app-pub-3310088406325999/3684441066";
//            self.bannerView.rootViewController = self;
//            [self.bannerView loadRequest:[GADRequest request]];
//            
//            totalNoOfAd = totalNoOfAd + 1;
           // return adCell;
            
        }else if(indexPath.row < 3 && !showAd){
        subcatDic = [subcatArrayList objectAtIndex:indexPath.row];
            
            
        }else if(totalCount > 3 && !showAd) {
            
        subcatDic = [subcatArrayList objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];

        }
        
        
        NSString *url_Img = [subcatDic valueForKey:@"image_url"];
        
        NSString *urlImg_FULL;
        if (url_Img ==(id)[NSNull null]) {
            urlImg_FULL = default_Img_Url;
        }else{
            urlImg_FULL =[base_Img_Url stringByAppendingPathComponent:url_Img];
        }
        
        NSString *dateStr = [subcatDic valueForKey:@"createdDate"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        [dateFormat setDateFormat:@"MMMM YYYY"];
        NSString* newDateFormat = [dateFormat stringFromDate:date];
        dateFormat.doesRelativeDateFormatting = YES;
        
        listCell.title.text = [subcatDic valueForKey:@"title"];
        
        NSString *loc = [subcatDic valueForKey:@"location"];
        
        NSString *firstWord = [[loc componentsSeparatedByString:@","] objectAtIndex:0];

        listCell.location.text = firstWord;
        
        NSString *isFeatured = [subcatDic valueForKey:@"is_featured"];
        if( [isFeatured  isEqual: @"Yes"]){
            [listCell.isFeatured setHidden:NO];
        }else{
            [listCell.isFeatured setHidden:YES];
        }
        DataClass *objc=[DataClass getInstance];
        if(!objc.isEnglish ){
            listCell.isFeatured.text = @"متميز";
        }
        
        if([[subcatDic valueForKey:@"price"] isEqual: @""] && [[subcatDic valueForKey:@"price_type"] isEqual: @""]){
            listCell.price.text = @"";

            listCell.priceImg.hidden = true;
            
        }else if(![[subcatDic valueForKey:@"price"] isEqual: @""]){
            
            listCell.price.text = [[subcatDic valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
            
            if(![[subcatDic valueForKey:@"price_type"] isEqual: @""]){
                
                listCell.priceImg.hidden = false;
                NSString *priceType = [subcatDic valueForKey:@"price_type"];
                
                if([priceType isEqualToString:@"Exchange"]){
                    
                    listCell.priceImg.image = [UIImage imageNamed: @"price_exchange"];
                    
                }else if([priceType isEqualToString:@"Negotiable"]){
                    
                    listCell.priceImg.image = [UIImage imageNamed: @"price_negotiable"];
                }
            }
            
            
        }else if([[subcatDic valueForKey:@"price"] isEqual: @""]){
            
            listCell.price.text = @"";
            
            if(![[subcatDic valueForKey:@"price_type"] isEqual: @""]){
                
                listCell.priceImg.hidden = false;
                NSString *priceType = [subcatDic valueForKey:@"price_type"];
                
                if([priceType isEqualToString:@"Exchange"]){
                    
                    listCell.priceImg.image = [UIImage imageNamed: @"price_exchange"];
                    
                }else if([priceType isEqualToString:@"Negotiable"]){
                    
                    listCell.priceImg.image = [UIImage imageNamed: @"price_negotiable"];
                }
            }
            
        }
        // price attribute^

        listCell.price.textColor = [UIColor colorWithRed:0/255.0 green:178/255.0 blue:176/255.0 alpha:1];
        
        listCell.image.layer.borderWidth = 1.0;
        listCell.image.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
        [listCell.image sd_setImageWithURL:[NSURL URLWithString:urlImg_FULL]];
        
        listCell.dateLabel.text = [@"," stringByAppendingString:newDateFormat];
        //
        if(  totalCount == indexPath.row+1  ){
            _subCatStart = indexPath.row+1 - [self calculateDED:indexPath.row];
            [self performSelector:@selector(checkAndLoadList:) withObject:self afterDelay:2];
            
        }
        
        return listCell;
        //
    }
   // return listCell;
}

-(void) checkAndLoadList:(id) sender{
    if(totalSubCatResult > totalCount){
        if (self.pageType == PageTypeAuctions) {
            [self callingAuctionListApi];
        }
        else{
            [self subCatList];
        }
    }
}

-(int)calculateDED:(int)row{
    
    //Google Ad
//    int endRow;
//    if(row<3)
//        endRow = 0;
//    else if (row == 3)
//        endRow = 1;
//    else if(row >3)
//        endRow = 1 + ((row - 3)/6);
//    else
//        endRow = 0;
//    return endRow;
    
    return 0;
    
}
- (IBAction)sortButton:(id)sender {
    //  [self performSegueWithIdentifier:@"Sort" sender:self];
    
    
}

- (IBAction)filterButton:(id)sender {
    [self loadFilterVC];
    //  [self performSegueWithIdentifier:@"Filter" sender:self];
    
}

-(void)loadFilterVC{
    FilterVC *filterVC = [[FilterVC alloc] initWithNibName:@"FilterVC" bundle:nil];
    filterVC.filterVcDelegate = self;
    [self.navigationController pushViewController:filterVC animated:YES];
}

- (IBAction)backButton:(id)sender {
    if(self.listingDelegate && [self.listingDelegate respondsToSelector:@selector(backButtonAcionDelegateFromListingPage)]){
        [self.listingDelegate backButtonAcionDelegateFromListingPage];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)locationButton:(id)sender {
    SeachLocationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SeachLocationViewController"];
    controller.fromList = true;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];
    [hud hideAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:(BOOL)animated];
    [hud hideAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%@",segue.identifier);
    if ([segue.identifier isEqualToString:@"listingToSort"]){
        SortViewController *sortVC = (SortViewController *)segue.destinationViewController;
        sortVC.sortDelegate = self;
    }
}

#pragma mark - Sort VC Delegate

-(void)sortTypeSelectedDelegate{
    [subcatArrayList removeAllObjects];
    [self callingApis];
}

-(void)callingApis{
    _subCatStart = 0;
    if (self.pageType == PageTypeAuctions) {
        [self callingAuctionListApi];
    }
    else{
        [self subCatList];
    }
}

#pragma mark - Filter VC Delegate

-(void)filterVcItem:(FilterVC *)viewController clickedItem:(id)item{
    [subcatArrayList removeAllObjects];
    [self callingApis];
}

#pragma mark - Auction Detail Page Delegate

-(void)bidDetailsModifiedDelegate{
    [subcatArrayList removeAllObjects];
    [self callingApis];
}

@end
