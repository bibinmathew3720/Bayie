//
//  FavoritesViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 25/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface FavoritesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *favoritesTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (assign) BOOL fromProfile;
//Google Ad
//@property(nonatomic, strong) GADBannerView *bannerView;


@property (nonatomic,assign) int favStart;
@property (nonatomic,assign) int totalFavResult;


@end
