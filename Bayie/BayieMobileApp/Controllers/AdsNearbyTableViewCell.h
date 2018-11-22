//
//  AdsNearbyTableViewCell.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 05/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdsNearbyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *adImg;
@property (weak, nonatomic) IBOutlet UILabel *adTitle;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *priceImage;

@property (weak, nonatomic) IBOutlet UILabel *isFeaturedLabel;


@end
