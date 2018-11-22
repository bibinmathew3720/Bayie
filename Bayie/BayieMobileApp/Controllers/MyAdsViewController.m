//
//  MyAdsViewController.m
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 24/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import "MyAdsViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "CustomMyAdsTableViewCell.h"
#import "DataClass.h"
#import "BayieHub.h"
#import "AdDetailedViewController.h"
#import "PostBAdViewController.h"
#import "MyChatsViewController.h"

#import "DeletePopUpView.h"

@interface MyAdsViewController ()<DeletePopUpViewDelegate>
{
    NSDictionary *myAdsdataDict;
    NSMutableArray *myAdsdataArray;
    NSString *base_Imageurlmyads;
    NSString *default_Imageurlmyads;
    MBProgressHUD *hud;
    
}
@property (nonatomic, strong) DeletePopUpView *deletePopUpView;
@property (nonatomic, strong) UIView *topGradientView;
@property (nonatomic, strong) NSString *selAdId;
@property (nonatomic, assign) BOOL isDeleteApiCalled;
@end

@implementation MyAdsViewController{
    BOOL showAd;

    NSInteger totalCount;
    NSInteger totalAdRows;
    NSInteger totalNoOfAd;
}

@synthesize totalMyadsResult;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.myAdsTableView.estimatedRowHeight = 155;
    self.myAdsTableView.rowHeight = UITableViewAutomaticDimension;
    [self loadDeletePopUpView];
}

-(void)loadDeletePopUpView{
    [self creatingGradientView];
    CGFloat xMargin = 20, popUpViewHeight = 400;
    self.deletePopUpView = [[[NSBundle mainBundle] loadNibNamed:@"DeletePopUpView"
                                                          owner:self
                                                        options:nil] firstObject];
    self.deletePopUpView.frame = CGRectMake(xMargin, self.view.frame.size.height/2-self.deletePopUpView.frame.size.height/2, self.view.frame.size.width - 2*xMargin, self.deletePopUpView.frame.size.height);
    self.deletePopUpView.hidden = YES;
    self.deletePopUpView.deletePopUpViewDelegate = self;
    [self.view addSubview:self.deletePopUpView];
}

-(void)creatingGradientView{
    self.topGradientView = [[UIView alloc] init];
    self.topGradientView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.topGradientView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.topGradientView.userInteractionEnabled = YES;
    self.topGradientView.hidden = YES;
    [self.view addSubview:self.topGradientView];
    [self addingGestureInTopGradientView];
}

-(void)addingGestureInTopGradientView{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.topGradientView addGestureRecognizer:tapGesture];
}

-(void)tapGestureAction:(UITapGestureRecognizer *)tapGesture{
    [self hideDeleteAdView];
}

-(void)hideDeleteAdView{
    self.topGradientView.hidden = YES;
    self.deletePopUpView.hidden = YES;
    self.selAdId = @"";
    self.deletePopUpView.reasonTextView.text = @"";
    self.isDeleteApiCalled = NO;
    [self.view endEditing:YES];
}

#pragma mark - DeletePopUpViewDelegates

-(void)deleteChatWithComment:(NSString *)comment andReason:(NSString *)reasonString{
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    DataClass *adsobj=[DataClass getInstance];
    NSDictionary *parameters =  @{@"adId":self.selAdId,@"comments":comment,@"language":[DataClass currentLanguageString],@"userToken":adsobj.userToken,@"reason":reasonString};

    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    self.isDeleteApiCalled = YES;
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"deleteMyAd"];
}

-(void)viewWillAppear:(BOOL)animated{
    [_myAdsTableView setContentOffset:CGPointZero animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
   
    self.myAdsTableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotBayieAPIData:) name:@"BayieResponse" object:nil];
    if(myAdsdataArray.count == 0)
        [self myAdsList];
    
    [super viewWillAppear:animated];
}

- (void) gotBayieAPIData:(NSNotification *) notification
{

    if ([[notification name] isEqualToString:@"BayieResponse"]){
        if([notification.object isKindOfClass:[NSError class]]){
            // manage error here
            if(self.isDeleteApiCalled)
                self.isDeleteApiCalled = NO;
            UIAlertController * alert =[UIAlertController
                                        alertControllerWithTitle:@"Bayie" message: @"Error occurs" preferredStyle:UIAlertControllerStyleAlert];
            
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
            if(self.isDeleteApiCalled){
                [self hideDeleteAdView];
                self.myadsStart = 0;
                [self myAdsList];
            }
            else{
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                NSArray *dataArray = responseDict[@"data"];
                NSString *listImgURL = responseDict[@"imageBaseUrl"];
                NSString *defaultAdsListImgUrl = responseDict[@"defaultImage"];
                
                totalMyadsResult =  [[responseDict valueForKey:@"totalResult"] integerValue];
                
                if (nil != dataArray && [dataArray isKindOfClass:[NSArray class]] && dataArray.count > 0 && [listImgURL isKindOfClass:[NSString class]] && listImgURL.length > 0 && [defaultAdsListImgUrl isKindOfClass:[NSString class]] && defaultAdsListImgUrl.length > 0)
                {
                    NSMutableArray *tmp = [[NSMutableArray alloc] initWithArray: dataArray];
                    
                    if(myAdsdataArray == nil )
                        myAdsdataArray = [[NSMutableArray alloc] init];
                    if(self.myadsStart == 0)
                        [myAdsdataArray removeAllObjects];
                    [myAdsdataArray addObjectsFromArray:tmp] ;
                    
                    base_Imageurlmyads = listImgURL;
                    default_Imageurlmyads = defaultAdsListImgUrl;
                    //  [self.listingTableView reloadData];
                    
                }
            }
        }else if (![errormsg isEqualToString:@""]){
            if(self.isDeleteApiCalled)
                self.isDeleteApiCalled = NO;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bayie"
                                                            message: responseDict[@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [hud hideAnimated:YES];
        }
        [self.myAdsTableView reloadData];
        [hud hideAnimated:YES];
    }
 }
-(void)myAdsList{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    DataClass *adsobj=[DataClass getInstance];
    NSString *start = [NSString stringWithFormat:@"%d",_myadsStart];
    NSLog(@"Start Index:%d",_myadsStart);
    NSDictionary *parameters =  @{@"language":[DataClass currentLanguageString],@"userToken":adsobj.userToken,@"start":start,@"limit":@"20"};
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[BayieHub sharedInstance] PostrequestcallServiceWith:jsonString :@"myAds"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(myAdsdataArray.count > 3){
        //Google Ad
        //totalAdRows =  ((myAdsdataArray.count  - 3)/6) + 1;
        totalCount = (myAdsdataArray.count + totalAdRows) ;
        return totalCount;
        
    }
    totalCount = myAdsdataArray.count;
    return totalCount;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.myAdsTableView reloadData];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MyAds";
    
    CustomMyAdsTableViewCell *myAdcell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
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
     myAdsdataDict = [myAdsdataArray objectAtIndex:indexPath.row];
        //Google Ad
//     if( UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
//         self.bannerView = [[GADBannerView alloc]
//                            initWithAdSize:kGADAdSizeSmartBannerPortrait];
//     }else{
//         
//         self.bannerView = [[GADBannerView alloc]
//                            initWithAdSize:kGADAdSizeSmartBannerLandscape];
//     }
//     
//        CustomMyAdsTableViewCell *adCell = [[CustomMyAdsTableViewCell alloc]init];
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
    
    myAdsdataDict = [myAdsdataArray objectAtIndex:indexPath.row];
        
    }else if(totalCount > 3 && !showAd){
        
        myAdsdataDict = [myAdsdataArray objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
  
    }
    
    NSString *url_Img = [myAdsdataDict valueForKey:@"image_url"];
    NSString *url_Img_FULL;
    if(url_Img == (id)[NSNull null]){
        url_Img_FULL = default_Imageurlmyads;
    }else {
        url_Img_FULL = [base_Imageurlmyads stringByAppendingPathComponent:url_Img];
    }
    
    myAdcell.myAdImage.layer.borderWidth = 1.0;
    myAdcell.myAdImage.layer.borderColor = [UIColor colorWithRed:(215/255.f) green:(215/255.f) blue:(215/255.f) alpha:1].CGColor;
    
    NSString *dateStr = [myAdsdataDict valueForKey:@"created_on"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    [dateFormat setDateFormat:@"MMMM YYYY"];
    NSString* newDateFormat = [dateFormat stringFromDate:date];
    dateFormat.doesRelativeDateFormatting = YES;
    
    [myAdcell.myAdImage sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]];
    
    myAdcell.adTitle.text = [myAdsdataDict valueForKey:@"title"];
    
    NSString *loc = [myAdsdataDict valueForKey:@"location"];
    
    NSString *firstWord = [[loc componentsSeparatedByString:@","] objectAtIndex:0];

    myAdcell.location.text = firstWord;
    myAdcell.adId = [myAdsdataDict valueForKey:@"ad_Id"];
    
    myAdcell.editButton.tag =[[myAdsdataDict valueForKey:@"ad_Id"] integerValue];
    myAdcell.deleteButton.tag =[[myAdsdataDict valueForKey:@"ad_Id"] integerValue];
    NSString *isFeatured = [myAdsdataDict valueForKey:@"is_featured"];
    if( [isFeatured  isEqual: @"Yes"]){
        [myAdcell.isFeatured setHidden:NO];
    }else{
        [myAdcell.isFeatured setHidden:YES];
    }

    DataClass *objc=[DataClass getInstance];
    if(!objc.isEnglish ){
        myAdcell.isFeatured.text = @"متميز";
    }
    
    //price attribt >>>>>
    if([[myAdsdataDict valueForKey:@"price"] isEqual: @""] && [[myAdsdataDict valueForKey:@"price_type"] isEqual: @""]){
        
        myAdcell.priceImg.hidden = true;
        myAdcell.price.text = @"";
        myAdcell.priceHeightConstraint.constant = 0;
        
    }else if(![[myAdsdataDict valueForKey:@"price"] isEqual: @""]){
        
        myAdcell.price.text = [[myAdsdataDict valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
        
        if(![[myAdsdataDict valueForKey:@"price_type"] isEqual: @""]){
            
            myAdcell.priceImg.hidden = false;
            NSString *priceType = [myAdsdataDict valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                myAdcell.priceImg.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                myAdcell.priceImg.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
        
    }else if([[myAdsdataDict valueForKey:@"price"] isEqual: @""]){
        
        myAdcell.price.text = @"";
        
        if(![[myAdsdataDict valueForKey:@"price_type"] isEqual: @""]){
            
            myAdcell.priceImg.hidden = false;
            NSString *priceType = [myAdsdataDict valueForKey:@"price_type"];
            
            if([priceType isEqualToString:@"Exchange"]){
                
                myAdcell.priceImg.image = [UIImage imageNamed: @"price_exchange"];
                
            }else if([priceType isEqualToString:@"Negotiable"]){
                
                myAdcell.priceImg.image = [UIImage imageNamed: @"price_negotiable"];
            }
        }
        
    }
    
    // >>>> price atrbt
    // myAdcell.price.text = [[myAdsdataDict valueForKey:@"price"]stringByAppendingString:NSLocalizedString(@" OMR", nil)];
    myAdcell.dateLabel.text = [@", " stringByAppendingString:newDateFormat];
    
    
    if(  totalCount == indexPath.row+1  ){
        _myadsStart = indexPath.row+1;
        [self performSelector:@selector(checkAndLoadList:) withObject:self afterDelay:2];
        
    }
    
    return myAdcell;
}

-(void) checkAndLoadList:(id) sender{
    if(totalMyadsResult > totalCount)
        [self myAdsList];
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

    if(indexPath.row < 3){
        
    NSDictionary *dataObj = [myAdsdataArray objectAtIndex:indexPath.row];
    NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
    
    adDetailsViewController.adId = ad_id;
    adDetailsViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:adDetailsViewController animated:YES];
     }else{
         
    NSDictionary *dataObj = [myAdsdataArray objectAtIndex:indexPath.row - [self calculateDED:indexPath.row]];
    NSString *ad_id = [dataObj valueForKey:@"ad_Id"];
    adDetailsViewController.adId = ad_id;
    adDetailsViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:adDetailsViewController animated:YES];
     }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        return 200;
    }
    //Google Ad
//    if (indexPath.row == 3 || ((indexPath.row - 3) % 6) == 0) {
//        
//        return 50;     // setting google ad height.
//    }
    return UITableViewAutomaticDimension;
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
    [self.navigationController popViewControllerAnimated:YES];
  //  [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)editButtonAction:(UIButton *)sender {
    NSString *adId = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self addingPostAdControllerInVCwithAdId:adId];
}
- (IBAction)chatButtonAction:(UIButton *)sender {
    [self addingChatViewController];
}
- (IBAction)deleteButtonAction:(UIButton *)sender {
    NSString *adId = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    self.selAdId = adId;
    self.topGradientView.hidden = NO;
    self.deletePopUpView.hidden = NO;
}

-(void)addingPostAdControllerInVCwithAdId:(NSString *)adId{
    PostBAdViewController *postAdViewController = [[PostBAdViewController alloc]initWithNibName:@"PostBAdViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postAdViewController];
    postAdViewController.isFromEditAd = YES;
    postAdViewController.adId = adId;
    [self presentViewController:nav animated:true completion:nil];
}

-(void)addingChatViewController{
    MyChatsViewController *myChats = [[UIStoryboard storyboardWithName:@"Chat" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"chats"];
    myChats.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:myChats animated:1];
}
@end
