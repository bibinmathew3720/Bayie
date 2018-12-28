//
//  AuctionDetailVC.m
//  BayieMobileApp
//
//  Created by Bibin Mathew on 12/27/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import "AuctionDetailVC.h"

@interface AuctionDetailVC (){
    UIButton *favouriteBtn;
    UILabel *imageCountLbl;
}
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *productDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLbael;
@property (weak, nonatomic) IBOutlet UILabel *brandNameHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *biddingHistoryHeadingLabel;
@property (weak, nonatomic) IBOutlet UITableView *bidHistoryTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bidHistoryTableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *yourBidHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBidPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBidPriceTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *bidButton;

@end

@implementation AuctionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customiseNavigationBar];
    // Do any additional setup after loading the view from its nib.
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
