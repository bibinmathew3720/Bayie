//
//  CustomSavedSearchesAdTableViewCell.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 23/06/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSavedSearchesAdTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *loclabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabl;
@property (weak, nonatomic) IBOutlet UILabel *datelabel;


@property (weak, nonatomic) IBOutlet UIImageView *priceImage;

@property (weak, nonatomic) IBOutlet UILabel *featuredLabel;

@end
