//
//  SeeAllAdsViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 17/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface SeeAllAdsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UIButton *backButton;


@property (weak, nonatomic) IBOutlet UILabel *seeAllAdsTitle;
@property (weak, nonatomic) IBOutlet UITableView *seeAllAdsTableView;

@property (strong, nonatomic) NSString *user_ID;

@property(nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic,assign) int seeAllAdsStart;
@property (nonatomic,assign) int totalseeAllAdsResult;

@end
