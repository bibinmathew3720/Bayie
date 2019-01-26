//
//  ListingViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 10/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseViewController.h"
#import "CustomListingTableViewCell.h"
#import <GoogleMobileAds/GADInterstitial.h>
#import <GoogleMobileAds/GADBannerView.h>
@import GoogleMobileAds;
@protocol ListingViewControllerDelegate;
@interface ListingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSString * catTitle;
    NSString *catID;
    
}
@property (strong, nonatomic) NSString *catTitle;
@property (strong, nonatomic) NSString *catID;

@property (weak, nonatomic) IBOutlet UITableView *listingTableView;

@property (weak, nonatomic) IBOutlet UILabel *categoryTitle;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowIcon;
@property (weak, nonatomic) IBOutlet NSString *lastLoc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortViewheightConstraint;
@property (weak, nonatomic) IBOutlet UIView *topView;


@property (nonatomic,assign) int subCatStart;
@property (nonatomic,assign) int totalSubCatResult;
@property (nonatomic,assign) int sortStart;
@property (nonatomic,assign) int totalSortResult;

@property (weak, nonatomic) IBOutlet UILabel *noRecordsLabel;
@property (weak, nonatomic)   NSString *lastApiCall;

@property (nonatomic, assign) id <ListingViewControllerDelegate>listingDelegate;
@property (nonatomic, assign) PAGETYPE pageType;
//Google Ad
//@property(nonatomic, strong) GADBannerView *bannerView;


@end

@protocol ListingViewControllerDelegate<NSObject>
-(void)backButtonAcionDelegateFromListingPage;
@end
