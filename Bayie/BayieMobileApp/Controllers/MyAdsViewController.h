//
//  MyAdsViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 24/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface MyAdsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myAdsTableView;

//Google Ad
//@property(nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic,assign) int myadsStart;
@property (nonatomic,assign) int totalMyadsResult;


@end
