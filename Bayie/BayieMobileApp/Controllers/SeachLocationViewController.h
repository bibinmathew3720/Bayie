//
//  SeachLocationViewController.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 24/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SeachLocationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UILabel *fromLabel;
}


@property (nonatomic,retain) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UILabel *locationTitle;
@property (weak, nonatomic) IBOutlet UILabel *otherCitiesLabel;

@property (weak, nonatomic)   NSString *lastApiCall;
//@property (weak, nonatomic) IBOutlet UIButton *locationUpdtedIndication;

@property (assign) BOOL isSearch;
@property (assign) BOOL fromList;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIStackView *otherCityBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;



@end
