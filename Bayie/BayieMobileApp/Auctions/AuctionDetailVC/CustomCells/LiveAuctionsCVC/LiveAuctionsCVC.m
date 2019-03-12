//
//  LiveAuctionsCVC.m
//   
//
//  Created by Bibin Mathew on 2/27/19.
//  Copyright © 2019 Abbie. All rights reserved.
//

#import "LiveAuctionsCVC.h"

@implementation LiveAuctionsCVC

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialisation];
    // Initialization code
}

-(void)initialisation {
    [self.bidNowButton setTitle:NSLocalizedString(@"BIDNOW", @"BID NOW") forState:UIControlStateNormal];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:0.00 green:0.69 blue:0.69 alpha:0.3].CGColor ;
}

-(void)setAuction:(Auction *)auction{
    self.adNameLabel.text = auction.adTitle;
    self.locationNameLabel.numberOfLines = 1;
    self.locationNameLabel.text = auction.adDescription;
    if (auction.currentBidAmount == 0.0){
        self.priceLabel.text = @"";
    }
    else{
        self.priceLabel.text = [NSString stringWithFormat:@"%0.1f%@",auction.currentBidAmount,NSLocalizedString(@" OMR", nil)];
    }
    NSString *imageUrl = @"";
    if (auction.imageUrl.length>0){
        imageUrl = [auction.imageBaseUrl stringByAppendingString:auction.imageUrl];
    }
    else{
        imageUrl = auction.defaultImageUrl;
    }
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    if (auction.isExpired ){
        NSString *timeString = NSLocalizedString(@"BiddingClosed", @"Bidding closed");
        [self.timerButton setTitle:timeString forState:UIControlStateNormal];
        self.bidNowButton.hidden = YES;
    }
    else{
        //[self.timerButton setTitle:auction.expiredOn forState:UIControlStateNormal];
         [self.timerButton setTitle:auction.expirationTime forState:UIControlStateNormal];
    }
}

@end
