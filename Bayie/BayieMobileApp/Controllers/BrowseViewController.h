//
//  BrowseViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 29/03/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCategoryCollectionViewCell.h"
#import "CustomTrendingAdsCollectionViewCell.h"
#import "CustomAdsCollectionViewCell.h"
//Google Ad
//#import <GoogleMobileAds/GADInterstitial.h>
//#import <GoogleMobileAds/GADBannerView.h>
@import GoogleMobileAds;

@interface BrowseViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)NSTimer *task;
@property (assign ) int colHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (nonatomic, assign) CGFloat categoryCellHeight;
@property (weak, nonatomic)   NSString *lastCall;
@property (weak, nonatomic) IBOutlet UILabel *locSelectionLabel;


@end
