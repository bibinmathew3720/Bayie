//
//  AuctionDetailVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/27/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "AuctionDetailVC.h"

#import "Utility.h"
#import "VideoVC.h"
#import "Auction.h"
#import "DataClass.h"
#import "JTSImageInfo.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "BidHistoryTVC.h"
#import "AuctionImagesCVC.h"
#import "NSString+Extension.h"
#import "JTSImageViewController.h"

#define favoriteImageName @"fav-active"
#define favoriteSelectedImageName @"fav_selected"

@interface AuctionDetailVC ()<UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout>{
    UIButton *favouriteBtn;
    UILabel *imageCountLbl;
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandNameHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *biddingHistoryHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *noBidHistoryLabel;
@property (weak, nonatomic) IBOutlet UITableView *bidHistoryTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidHistoryTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *yourBidHeadingLabel;
@property (weak, nonatomic) IBOutlet UITextField *myBidPriceTF;
@property (weak, nonatomic) IBOutlet UILabel *myBidPriceTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *bidButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidNowButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yourBidViewHeiCnstaint;

@property (nonatomic, strong) Auction *auctionDetails;
@property (nonatomic, assign) CGFloat bidHistoryCellHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidNowSeparatorHeiConstraint;
@property (nonatomic, assign) BOOL isBidded;
@end

@implementation AuctionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self localisation];
    [self initialisation];
    [self customiseNavigationBar];
    [self getAdDetailsFromServer];
    // Do any additional setup after loading the view from its nib.
}

-(void)initialisation{
    self.bidHistoryCellHeight = 50;
    [self.bidHistoryTableView registerNib:[UINib nibWithNibName:@"BidHistoryTVC" bundle:nil]
         forCellReuseIdentifier:@"bidHistoryCell"];
    [self.imagesCollectionView registerNib:[UINib nibWithNibName:@"AuctionImagesCVC" bundle:nil] forCellWithReuseIdentifier:@"auctionImagesCVC"];
}

-(void)localisation{
    self.descriptionHeadingLabel.text = NSLocalizedString(@"Description", @"Description");
    self.detailsHeadingLabel.text = NSLocalizedString(@"Details", @"Details");
    self.conditionHeadingLabel.text = NSLocalizedString(@"Condition", @"Condition");
    self.modelHeadingLabel.text = NSLocalizedString(@"Model", @"Model");
    self.priceHeadingLabel.text = NSLocalizedString(@"Price", @"Price");
    self.brandNameHeadingLabel.text = NSLocalizedString(@"BrandName", @"Brand Name");
    self.biddingHistoryHeadingLabel.text = NSLocalizedString(@"BiddingHistory", @"Bidding History");
    self.noBidHistoryLabel.text = NSLocalizedString(@"NoBidHistoryAvailable", @"No Bid History Available");
    self.yourBidHeadingLabel.text = NSLocalizedString(@"YourBid", @"Your bid");
    self.myBidPriceTF.placeholder = NSLocalizedString(@"YourBid", @"Your bid");
    [self.bidButton setTitle:NSLocalizedString(@"BIDNOW", @"BID NOW") forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:false];
}

-(void)viewWillDisappear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:true];
}

-(void)customiseNavigationBar{
    [self.navigationController setNavigationBarHidden:false];
    UIBarButtonItem *myBackButton;
    NSString *strSelectedLanguage = [[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if([strSelectedLanguage isEqualToString:[NSString stringWithFormat: @"ar"]]){
        myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:ArabicBackArrowImageName] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    }
    else {
        myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BackArrowImageName] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
        
    }
    self.navigationItem.leftBarButtonItem = myBackButton;
    favouriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,-1,44,44)];
    [favouriteBtn setImage:[UIImage
                            imageNamed:favoriteImageName]  forState:UIControlStateNormal];
    favouriteBtn.tag = 0;
    [favouriteBtn addTarget:self action:@selector(favoriteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    favouriteBtn.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *favButton = [[UIBarButtonItem alloc] initWithCustomView:favouriteBtn];
    UIView *titltViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0,0,40,40)];
    titltViewContainer.backgroundColor = [UIColor clearColor];
    imageCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(25,-3,60,40)];
    imageCountLbl.backgroundColor = [UIColor clearColor];
    imageCountLbl.textColor = [UIColor whiteColor];
    imageCountLbl.font = [UIFont systemFontOfSize:18.0];
    imageCountLbl.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *cameraIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera"]];
    cameraIcon.frame = CGRectMake(0,7,20,20);
    cameraIcon.contentMode = UIViewContentModeCenter;
    [titltViewContainer addSubview:cameraIcon];
    [titltViewContainer addSubview:imageCountLbl];
    
    self.navigationItem.titleView = titltViewContainer;
    self.navigationItem.rightBarButtonItem = favButton;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAdDetailsFromServer{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    DataClass *obj=[DataClass getInstance];
    NSString *URLString = [NSLocalizedString(@"AUCTIONS_MANAGEMENT_URL", nil) stringByAppendingString:@"auctionDetails"];
    //    DataClass *obj=[DataClass getInstance];
    
   // NSDictionary *parameters =  @{@"slug":self.adId,@"language":[DataClass currentLanguageString],@"userToken":obj.userToken};
    
    NSMutableDictionary *parameters =  [[NSMutableDictionary alloc]init];
    [parameters setValue:self.adId forKey:@"slug"];
    [parameters setValue:[DataClass currentLanguageString] forKey:@"language"];
    if (obj.userToken != nil){
        [parameters setValue:obj.userToken forKey:@"userToken"];
    }

    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    
    [req setValue:obj.userToken forHTTPHeaderField:@"userToken"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error.code == NSURLErrorTimedOut) {
            //time out error here
            NSLog(@"Trigger TIME OUT");
        }
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = responseObject;
                
                if (![responseDict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    
                    
                }
                else{
                    self.auctionDetails = [[Auction alloc] initWithAuctionDictionary:responseDict];
                    [self populateAdDetails];
                    NSLog(@"Response:%@",responseObject);
                }
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        [hud hideAnimated:YES];
    }]resume];
}

-(void)populateAdDetails{
    if (self.auctionDetails.isExpired){
        NSString *expiredString = NSLocalizedString(@"BiddingClosed", @"Bidding closed");
        [self.timerButton setTitle:expiredString forState:UIControlStateNormal];
        self.bidNowButtonHeightConstraint.constant = 0;
        self.yourBidViewHeiCnstaint.constant = 0;
        self.bidNowSeparatorHeiConstraint.constant = 0;
        self.myBidPriceTF.hidden = YES;
        self.myBidPriceTypeLabel.hidden = YES;
        self.yourBidHeadingLabel.hidden = YES;
        self.bidButton.hidden = YES;
    }
    else{
        [self.timerButton setTitle:self.auctionDetails.expiredOn forState:UIControlStateNormal];
    }
    [self changeFavouriteBtnImage:self.auctionDetails.isFavorite];
    if (self.auctionDetails.imagesArray.count>0){
        NSUInteger count = self.auctionDetails.imagesArray.count;
        imageCountLbl.text = [NSString stringWithFormat:@"%d/%lu",1, (unsigned long)count];
        self.pageControl.numberOfPages = count;
    }
    else{
        self.imagesCollectionView.hidden = YES;
        [self.defaultImageView sd_setImageWithURL:[NSURL URLWithString:self.auctionDetails.defaultImageUrl]];
        self.pageControl.hidden = YES;
    }
    self.adTitleLabel.text = self.auctionDetails.adTitle;
    NSString *prodDetailString = [NSString stringWithFormat:@"%@:%d | %@ - %0.2f OMR",NSLocalizedString(@"Bids", @"Bids"),self.auctionDetails.bidCount,self.auctionDetails.currentBidUser,self.auctionDetails.currentPrice];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"%0.2f OMR",self.auctionDetails.currentBidAmount];
    self.productDetailsLabel.text = prodDetailString;
    self.descriptionLabel.text = [self.auctionDetails.adDescription removeBrTag];
    self.conditionLabel.text = self.auctionDetails.itemCondition;
    //self.modelLabel.text = self.auctionDetails.
    self.priceLabel.text = [NSString stringWithFormat:@"%0.2f OMR",self.auctionDetails.basePrice];
    //self.brandLabel.text = self.auctionDetails.
    //self.myBidPriceTF.text = [NSString stringWithFormat:@"%0.0f",self.auctionDetails.currentBidAmount];
    self.bidHistoryTableViewHeightConstraint.constant = self.bidHistoryCellHeight * self.auctionDetails.bidHistory.count;
    if (self.auctionDetails.bidHistory.count == 0){
        self.noBidHistoryLabel.hidden = NO;
        self.bidHistoryTableView.hidden = YES;
    }
    else{
        self.noBidHistoryLabel.hidden = YES;
        self.bidHistoryTableView.hidden = NO;
    }
    [self.bidHistoryTableView reloadData];
    [self.imagesCollectionView reloadData];
}

- (void)indexValue:(int)index{
    NSUInteger count = self.auctionDetails.imagesArray.count;
    imageCountLbl.text = [NSString stringWithFormat:@"%d/%lu",index + 1, (unsigned long)count];
    self.pageControl.currentPage = index;
}

-(BOOL)isLoggedIn{
    DataClass *dataCllas = [DataClass getInstance];
    if(dataCllas.userToken!=nil)
        return YES;
    else
        return NO;
}

- (void)changeFavouriteBtnImage:(BOOL)isFavourite {
    if (isFavourite == true){
        [favouriteBtn setImage:[UIImage imageNamed:favoriteSelectedImageName] forState:UIControlStateNormal];
    }else{
        [favouriteBtn setImage:[UIImage imageNamed:favoriteImageName] forState:UIControlStateNormal];
    }
}

#pragma mark - Button Actions

- (void)backBtnClicked{
    if (self.isBidded){
        if (self.auctionDetailDelegate && [self.auctionDetailDelegate respondsToSelector:@selector(bidDetailsModifiedDelegate)]){
            [self.auctionDetailDelegate bidDetailsModifiedDelegate];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)favoriteBtnClicked:(id)sender {
    if(![self isLoggedIn]){
        [Utility showLogInAlertInController:self];
    }
    else{
        if (self.auctionDetails.isFavorite){
            [self callingRemoveFromFavoriteApi];
        }
        else{
           [self callingAddToFavoriteApi];
        }
    }
}

- (IBAction)shareButtonAction:(UIButton *)sender {
    NSString *shareData = @"";
    if (self.auctionDetails.shareUrl){
        shareData = self.auctionDetails.shareUrl;
    }
    
    NSArray *items = @[shareData];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    // and present it
    [self presentViewController:controller animated:YES completion:^{
        // executes after the user selects something
    }];
}

- (IBAction)bidButtonAction:(UIButton *)sender {
    if(![self isLoggedIn]){
        [Utility showLogInAlertInController:self];
    }
    else{
        if ([self isValidBidAmount]){
            [self callingBidNowApi];
        }
    }
}

-(BOOL)isValidBidAmount{
    BOOL isValid = YES;
    NSString *messageString = @"";
    if (self.myBidPriceTF.text.length == 0){
        isValid = NO;
        messageString = NSLocalizedString(@"PleaseEnterbidAmount", @"Please enter bid amount");
    }
    if (!isValid){
        [Utility showAlertInController:self withMessageString:messageString withCompletion:^(BOOL isCompleted) {
            
        }];
    }
    return isValid;
}

#pragma mark - Calling Bid Now Api

-(void)callingBidNowApi{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [NSLocalizedString(@"AUCTIONS_MANAGEMENT_URL", nil) stringByAppendingString:@"bidNow"];
    
    NSDictionary *parameters =  @{@"auction_id":[NSString stringWithFormat:@"%d",self.auctionDetails.auctionId],@"language":[DataClass currentLanguageString],@"bid_amount":self.myBidPriceTF.text};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    DataClass *obj=[DataClass getInstance];
    [req setValue:obj.userToken forHTTPHeaderField:@"userToken"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error.code == NSURLErrorTimedOut) {
            //time out error here
            NSLog(@"Trigger TIME OUT");
        }
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                int statusCode = [[responseObject valueForKey:@"status"] intValue];
                NSString *messageString = @"";
                if (statusCode == 200){
                    self.isBidded = YES;
                    _myBidPriceTF.text = @"";
                    messageString = [[responseObject valueForKey:@"data"] valueForKey:@"msg"];
                }
                else{
                    if ([responseObject valueForKey:@"error"]){
                        messageString = [responseObject valueForKey:@"error"];
                    }
                }
                if (messageString.length>0){
                    [Utility showAlertInController:self withMessageString:messageString withCompletion:^(BOOL isCompleted) {
                        [self getAdDetailsFromServer];
                    }];
                }
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        [hud hideAnimated:YES];
    }]resume];
}

#pragma mark - Calling Add to Favorite Api

-(void)callingAddToFavoriteApi{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSString *URLString = [NSLocalizedString(@"AUCTIONS_MANAGEMENT_URL", nil) stringByAppendingString:@"addToFavourite"];
    DataClass *obj=[DataClass getInstance];
    NSDictionary *parameters =  @{@"adId":[NSString stringWithFormat:@"%d",self.auctionDetails.adId],@"language":[DataClass currentLanguageString],@"userToken":obj.userToken};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    [req setValue:obj.userToken forHTTPHeaderField:@"userToken"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error.code == NSURLErrorTimedOut) {
            //time out error here
            NSLog(@"Trigger TIME OUT");
        }
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                int statusCode = [[responseObject valueForKey:@"status"] intValue];
                NSString *messageString = @"";
                if (statusCode == 200){
                    self.auctionDetails.isFavorite = YES;
                    [self populateAdDetails];
                    //messageString = [[responseObject valueForKey:@"data"] valueForKey:@"msg"];
                }
                else{
                    if ([responseObject valueForKey:@"error"]){
                        messageString = [responseObject valueForKey:@"error"];
                    }
                }
                if (messageString.length>0){
                    [Utility showAlertInController:self withMessageString:messageString withCompletion:^(BOOL isCompleted) {
                        
                    }];
                }
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        [hud hideAnimated:YES];
    }]resume];
    
}

#pragma mark - Calling Remove From favorite api

-(void)callingRemoveFromFavoriteApi{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    NSString *URLString = [NSLocalizedString(@"AUCTIONS_MANAGEMENT_URL", nil) stringByAppendingString:@"removeFavourite"];
    DataClass *obj=[DataClass getInstance];
    NSDictionary *parameters =  @{@"adId":[NSString stringWithFormat:@"%d",self.auctionDetails.adId],@"language":[DataClass currentLanguageString],@"userToken":obj.userToken};
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:AuthValue forHTTPHeaderField:@"Authentication"];
    [req setValue:obj.userToken forHTTPHeaderField:@"userToken"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error.code == NSURLErrorTimedOut) {
            //time out error here
            NSLog(@"Trigger TIME OUT");
        }
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSLog(@"Response == %@",responseObject);
            }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                int statusCode = [[responseObject valueForKey:@"status"] intValue];
                NSString *messageString = @"";
                if (statusCode == 200){
                    self.auctionDetails.isFavorite = NO;
                    [self populateAdDetails];
                    //messageString = [[responseObject valueForKey:@"data"] valueForKey:@"msg"];
                }
                else{
                    if ([responseObject valueForKey:@"error"]){
                        messageString = [responseObject valueForKey:@"error"];
                    }
                }
                if (messageString.length>0){
                    [Utility showAlertInController:self withMessageString:messageString withCompletion:^(BOOL isCompleted) {
                        
                    }];
                }
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        [hud hideAnimated:YES];
    }]resume];
    
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableView  Datasources and Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.auctionDetails.bidHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidHistoryTVC *cell = (BidHistoryTVC *)[tableView dequeueReusableCellWithIdentifier:@"bidHistoryCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BidHistoryTVC" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.bidHistory = [self.auctionDetails.bidHistory objectAtIndex:indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.bidHistoryCellHeight;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 1;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 1;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [UIView new];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - UICollection View Datasources and Delegates

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.auctionDetails.imagesArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AuctionImagesCVC *imageCollectionCell = [collectionView
                                                    dequeueReusableCellWithReuseIdentifier:@"auctionImagesCVC"
                                                    forIndexPath:indexPath];
    imageCollectionCell.adImage = [self.auctionDetails.imagesArray objectAtIndex:indexPath.row];
    return imageCollectionCell;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0,0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(( [UIScreen mainScreen].bounds.size.width),240);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.imagesCollectionView.frame.size.width;
    int currentPage = self.imagesCollectionView.contentOffset.x / pageWidth;
    [self indexValue:currentPage];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AuctionImagesCVC *collectionCell = (AuctionImagesCVC *)[collectionView cellForItemAtIndexPath:indexPath];
    AdImages *imageItem = [self.auctionDetails.imagesArray objectAtIndex:indexPath.row];
    if ([imageItem.type isEqualToString:@"image"]){
        [self imageSelected:indexPath.row images:self.auctionDetails.imagesArray andImageView:collectionCell.adImagesView];
    }
    else if ([imageItem.type isEqualToString:@"video"]){
        NSString *videoUrlString = [imageItem.imageBaseUrl stringByAppendingString:imageItem.videoUrl];
        [self selectedWithVideo:videoUrlString];
    }
}

#pragma mark - Showing Image and Video in Full Screen

-(void)imageSelected:(NSInteger)index images:(NSArray*)imageURLs andImageView:(UIImageView *)imageView{
    [self addingFullImageControllerWithImagae:imageView.image withImageView:imageView];
}

-(void)selectedWithVideo:(NSString *)videoUrlString{
    VideoVC *videoVC = [[VideoVC alloc] initWithNibName:@"VideoVC" bundle:nil
                        ] ;
    videoVC.videoUrl = videoUrlString;
    UINavigationController *videoNavntlr = [[UINavigationController alloc] initWithRootViewController:videoVC];
    [self presentViewController:videoNavntlr animated:true completion:nil];
}

-(void)addingFullImageControllerWithImagae:(UIImage *)fullImage withImageView:(UIImageView *)imageView{
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = imageView.image;
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;
    imageInfo.referenceContentMode = imageView.contentMode;
    imageInfo.referenceCornerRadius = imageView.layer.cornerRadius;
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

