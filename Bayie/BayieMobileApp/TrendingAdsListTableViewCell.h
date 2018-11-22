//
//  TrendingAdsListTableViewCell.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 04/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendingAdsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;
//@property (weak, nonatomic) IBOutlet UIStackView *teststack;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *teststackhyt;
@property (weak, nonatomic) IBOutlet UILabel *isFeaturedLabel;

@property (weak, nonatomic) IBOutlet UIImageView *priceImage;

@end
