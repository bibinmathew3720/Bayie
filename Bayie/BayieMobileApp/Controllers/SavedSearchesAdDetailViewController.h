//
//  SavedSearchesAdDetailViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 23/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface SavedSearchesAdDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *savedSearchAdDetail;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


@property (weak, nonatomic)   NSString *savid;

@property (weak, nonatomic)   NSString *lastApi;
//Google Ad
//@property(nonatomic, strong) GADBannerView *bannerView;

@property (nonatomic,assign) int savedAdDetailStart;
@property (nonatomic,assign) int totalsavedAdDetailResult;

@end
