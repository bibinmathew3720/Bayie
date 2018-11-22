//
//  CustomSeeAllAdsTableViewCell.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 17/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSeeAllAdsTableViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIImageView *priceImage;
@property (weak, nonatomic) IBOutlet UILabel *featuredLabel;


@end
