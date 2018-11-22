//
//  ListingCollectionCell.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 2/25/18.
//  Copyright © 2018 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *catImageView;
@property (nonatomic, strong) id categoryItem;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *adNameLabel;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end
