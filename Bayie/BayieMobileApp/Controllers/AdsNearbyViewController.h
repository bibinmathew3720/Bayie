//
//  AdsNearbyViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 05/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdsNearbyTableViewCell.h"
@import GoogleMobileAds;

@interface AdsNearbyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *adsNearbyTableView;

//Google Ad
//@property(nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic,assign) int nearStart;
@property (nonatomic,assign) int totalNearResult;


@end
