//
//  CustomAdsCollectionViewCell.h
//  BayieMobileApp
//
//  Created by Pintlab Technologies on 03/04/17.
//  Copyright © 2017 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAdsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *imageDescription;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *isFeaturedLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceHeight;
@end
