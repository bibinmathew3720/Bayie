//
//  TrendingAdsListViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 04/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrendingAdsListTableViewCell.h"
@import GoogleMobileAds;

@interface TrendingAdsListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *trendingAdsTableView;
@property (weak, nonatomic) IBOutlet UILabel *trendingAdsTitle;

//Google Ad
//@property(nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic,assign) int trendStart;
@property (nonatomic,assign) int totalTrendResult;


@end
