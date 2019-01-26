//
//  AuctionListingCVC.h
//  BayieMobileApp
//
//  Created by Bibin Mathew on 1/1/19.
//  Copyright © 2019 Abbie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuctionListingCVC : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *adNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *timerButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UIButton *bidNowButton;

@property (nonatomic, strong) id auctionDetails;

@end
