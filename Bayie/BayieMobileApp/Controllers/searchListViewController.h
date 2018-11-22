//
//  searchListViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 19/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface searchListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *searchResultTitle;


@property (weak, nonatomic) IBOutlet UITableView *searchResult;

@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSString *categoryID;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property(nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic,assign) int searchListStart;
@property (nonatomic,assign) int totalsearchListResult;


@end
