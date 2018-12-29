//
//  AuctionDetailVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/27/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "AuctionDetailVC.h"

#import "Auction.h"
#import "DataClass.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface AuctionDetailVC (){
    UIButton *favouriteBtn;
    UILabel *imageCountLbl;
    MBProgressHUD *hud;
}
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
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
@property (weak, nonatomic) IBOutlet UITableView *bidHistoryTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidHistoryTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *yourBidHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBidPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBidPriceTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *bidButton;

@property (nonatomic, strong) Auction *auctionDetails;

@end

@implementation AuctionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self localisation];
    [self customiseNavigationBar];
    [self getAdDetailsFromServer];
    // Do any additional setup after loading the view from its nib.
}

-(void)localisation{
    self.descriptionHeadingLabel.text = NSLocalizedString(@"Description", @"Description");
    self.detailsHeadingLabel.text = NSLocalizedString(@"Details", @"Details");
    self.conditionHeadingLabel.text = NSLocalizedString(@"Condition", @"Condition");
    self.modelHeadingLabel.text = NSLocalizedString(@"Model", @"Model");
    self.priceHeadingLabel.text = NSLocalizedString(@"Price", @"Price");
    self.brandNameHeadingLabel.text = NSLocalizedString(@"BrandName", @"Brand Name");
    self.biddingHistoryHeadingLabel.text = NSLocalizedString(@"BiddingHistory", @"Bidding History");
    self.yourBidHeadingLabel.text = NSLocalizedString(@"YourBid", @"Your bid");
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
        myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow-right"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
    }
    else {
        myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked)];
        
    }
    self.navigationItem.leftBarButtonItem = myBackButton;
    favouriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,-1,44,44)];
    [favouriteBtn setImage:[UIImage
                            imageNamed:@"fav"] forState:UIControlStateNormal];
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

- (void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAdDetailsFromServer{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = [NSString stringWithFormat:NSLocalizedString(@"LOADING", nil), @(1000000)];
    
    NSString *URLString = [NSLocalizedString(@"AUCTIONS_MANAGEMENT_URL", nil) stringByAppendingString:@"auctionDetails"];
    //    DataClass *obj=[DataClass getInstance];
    
    NSDictionary *parameters =  @{@"slug":self.adId,@"language":[DataClass currentLanguageString]};
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
    self.adTitleLabel.text = self.auctionDetails.adTitle;
    NSString *prodDetailString = [NSString stringWithFormat:@"%@:%d | %@:%d | %@ - %0.2f OMR",NSLocalizedString(@"ID", @"ID"),self.auctionDetails.auctionId,NSLocalizedString(@"Bids", @"Bids"),self.auctionDetails.bidCount,self.auctionDetails.currentBidUser,self.auctionDetails.currentPrice];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"%0.2f OMR",self.auctionDetails.currentBidAmount];
    self.productDetailsLabel.text = prodDetailString;
    self.descriptionLabel.text = self.auctionDetails.adDescription;
    self.conditionLabel.text = self.auctionDetails.itemCondition;
    //self.modelLabel.text = self.auctionDetails.
    self.priceLabel.text = [NSString stringWithFormat:@"%0.2f OMR",self.auctionDetails.basePrice];
    //self.brandLabel.text = self.auctionDetails.
}

#pragma mark - Button Actions

- (IBAction)shareButtonAction:(UIButton *)sender {
}

- (IBAction)bidButtonAction:(UIButton *)sender {
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
